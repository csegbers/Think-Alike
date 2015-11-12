-------------------------------------------------------
-- Loaded once in main, used to override variables and create some common functions
-------------------------------------------------------
local myApp = require( "myapp" ) 
local parse = require( myApp.utilsfld .. "mod_parse" ) 

function myApp.fncCopyPolicyTerm  (inrec,outrec )

    outrec.policynumber = inrec.policyNumber
    outrec.policymod = inrec.policyMod
    outrec.effdate = inrec.effDate.iso
    outrec.expdate = inrec.expDate.iso
    outrec.objectId = inrec.objectId
    outrec.policyaddress = inrec.policyAddress
    outrec.policycity = inrec.policyCity
    outrec.policycompanyname = inrec.policyCompanyName
    outrec.policyinsurancegroup = inrec.policyInsuranceGroup
    outrec.policyinsuredname = inrec.policyInsuredName
    outrec.policylob = inrec.policyLOB
    outrec.policynaic = inrec.policyNaic
    outrec.policypostalcode = inrec.policyPostalCode
    outrec.policystate = inrec.policyState
    outrec.policystatename = inrec.policyStateName
    outrec.policytype = inrec.policyType
    outrec.policydue = inrec.policyDue
    outrec.agencycode = inrec.agencyCode
    outrec.due = inrec.policyDue

end
 
function myApp.fncUserUpdatePolicies ()

   myApp.authentication.policies =  {}
   myApp.authentication.agencies =  {}
   myApp.authentication.agencycode = ""
   print ("clear out authentication")

   -----------------------------------------------
   -- logged in ?
   -----------------------------------------------
   if myApp.authentication.loggedin   then
         native.setActivityIndicator( true ) 
         parse:run(myApp.otherscenes.myaccount.functionname.getpolicies,
            {
             ["userId"] = myApp.authentication.objectId 
             },
             ------------------------------------------------------------
             -- Callback inline function
             ------------------------------------------------------------
             function(e) 
                native.setActivityIndicator( false ) 
                --debugpopup ("here from get policies")
                if (e.response.error or "" ) == "" then  
                     
                    for i = 1, #e.response.result do
                        local resgroup = e.response.result[i][1]
                        --myApp.authentication.policies[resgroup["policyNumber"]] = resgroup
                        myApp.authentication.policies[resgroup["policyNumber"]] = {}
                        myApp.authentication.policies[resgroup["policyNumber"]].policyTerms = {}
                        print("policy Number" .. resgroup["policyNumber"])
                        if #resgroup.policyTerms[1] > 0 then
                            myApp.authentication.agencycode = resgroup.policyTerms[1][1].agencyCode or ""
                            for pt = 1, #resgroup.policyTerms[1]  do
                                local termgroup = {} 
                                myApp.fncCopyPolicyTerm (resgroup.policyTerms[1][pt] ,termgroup)                       
                                --table.insert (myApp.authentication.policies[resgroup["policyNumber"]].policyTerms, pt, resgroup.policyTerms[1][pt])
                                table.insert (myApp.authentication.policies[resgroup["policyNumber"]].policyTerms, pt, termgroup)
                            end
                       end
                    end
                    Runtime:dispatchEvent{ name="policieschanged", value=myApp.authentication.loggedin }
                    
                    ------------------------------
                    -- go grab agent
                    ------------------------------
                    if myApp.authentication.agencycode ~= "" then
                       --print("function name" .. myApp.mappings.objects.Agency.functionname.details)
                       --print("agency code" .. myApp.authentication.agencycode)
                       native.setActivityIndicator( true ) 
                       parse:run(
                                   myApp.mappings.objects.Agency.functionname.details,
                                   {
                                      ["agencyCode"] = myApp.authentication.agencycode
                                   },
                                   function(e) 
                                      native.setActivityIndicator( false ) 
                                      if (e.response.error or "" ) == "" then 
                                          if #e.response.result > 0 then
                                             myApp.authentication.agencies = e.response.result[1]
                                             --print("agency name" .. myApp.authentication.agencies.agencyName)
                                          end
                                      end
                                      Runtime:dispatchEvent{ name="agencieschanged", value=myApp.authentication.loggedin }
                                   end
                                )
                    else      -- no agencycode
                       Runtime:dispatchEvent{ name="agencieschanged", value=myApp.authentication.loggedin }
                    end      -- have agencycode


                else    -- on get policies rturn error check    error on the getpolicies
                    Runtime:dispatchEvent{ name="agencieschanged", value=myApp.authentication.loggedin }
                    Runtime:dispatchEvent{ name="policieschanged", value=myApp.authentication.loggedin }
                end  -- end of error check
             end )  -- end of policies parse call anf callback
   else
            ---------------------------------
            -- logged out - dispatch event
            ---------------------------------
            Runtime:dispatchEvent{ name="policieschanged", value=myApp.authentication.loggedin }
            Runtime:dispatchEvent{ name="agencieschanged", value=myApp.authentication.loggedin }
   end     -- loggin check

end

-------------------------------
-- if user just created then not every field is there like email
-------------------------------
function myApp.fncUserLogInfo (userObject)
     print "fncUserLoggedIn  "
     myApp.authentication.email = userObject.email
     myApp.authentication.emailVerified = userObject.emailVerified
     myApp.authentication.username = userObject.username                -- for now this is email
     myApp.authentication.objectId = userObject.objectId                -- internal userid
     myApp.authentication.sessionToken = userObject.sessionToken

     local curLoggedin = myApp.authentication.loggedin or false
     myApp.authentication.loggedin =  myApp.authentication.emailVerified or false

     -----------------------------
     -- dispatch event if login status changed
     -----------------------------
     if myApp.authentication.loggedin ~= curLoggedin then
         Runtime:dispatchEvent{ name="loginchanged", value=myApp.authentication.loggedin }
     end

     ----------------------------
     -- first time logging in ?
     -- event it in case we want to do something
     ----------------------------
     if myApp.authentication.loggedin   then
          myApp.fncPutUD ("everloggedin",1)     --- if still a 0 will update and trigger event
     end

     ----------------------------
     -- always update policies and agents
     -- becuase most likely they are logging in or out
     -----------------------------
     myApp.fncUserUpdatePolicies()
end

-------------------------------
-- Log em out
-------------------------------
function myApp.fncUserLoggedOut (event)
     print "fncUserLoggedOut  "
     myApp.fncUserLogInfo({
           email = "",
           emailVerified = false,
           username = "",
           objectId = "",
           sessionToken = "",
          })
   
end