
-------------------------------------------------------
-- Loaded once in main, used to override variables and create some common functions
-------------------------------------------------------
local myApp = require( "myapp" ) 
local parse = require( myApp.utilsfld .. "mod_parse" )
local dbmodule = require( myApp.utilsfld ..  "dbmodule")  
require( myApp.utilsfld .. "dbfunctions" ) 
require( myApp.utilsfld .. "userfunctions" ) 
local json = require("json")

--print (require("json").encode(myApp.contactus))


function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

-------------------------------------------------------
-- Override print function make global
-------------------------------------------------------
reallyPrint = print
function print(...)
    if myApp.debugMode then
        reallyPrint("<-==============================================->") 
        --if type(arg[1]) == "table" then
            --print_r(arg[1])
        --else
            pcall(function() reallyPrint(myApp.appName .. "-> " .. unpack(arg)) end)
        --end
    end
end


-------------------------------------------------------
-- pop up messgae
------------------------------------------------------- 
function debugpopup(whatstr) 
  if myApp.debugMode then native.showAlert( myApp.appName ,whatstr ,{"ok"})  end
end

print "In startup.lua"
-------------------------------------------------------
-- Seed random generator in case we use
-------------------------------------------------------
math.randomseed( os.time() )
 
-------------------------------------------------------
-- Set app variables
-------------------------------------------------------

display.setStatusBar( myApp.statusBarType )
myApp.tSbch = display.topStatusBarContentHeight 
myApp.sceneStartTop = myApp.titleBarHeight + myApp.tSbch  
myApp.sceneWidth = myApp.cW
myApp.sceneHeight = myApp.cH - myApp.sceneStartTop - myApp.tabs.tabBarHeight
myApp.authentication.loggedin = false
myApp.justLaunched = true
myApp.moreinfo.direction = "left"
if (display.pixelHeight/display.pixelWidth) > 1.5 then  myApp.isTall = true end
if display.contentWidth > 320 then myApp.is_iPad = true end

myApp.saColor = { 0/myApp.colorDivisor, 104/myApp.colorDivisor, 167/myApp.colorDivisor } 
myApp.saColorTrans = { 0/myApp.colorDivisor, 104/myApp.colorDivisor, 167/myApp.colorDivisor, .75 }
myApp.colorGray = { 83/myApp.colorDivisor, 83/myApp.colorDivisor, 83/myApp.colorDivisor }
myApp.icons = graphics.newImageSheet(myApp.imgfld.. myApp.iconinfo.sheet,myApp.iconinfo.icondimensions)

if system.getInfo("platformName") == "Android" then
    myApp.theme = "widget_theme_android"
    myApp.font = "Droid Sans"
    myApp.fontBold = "Droid Sans Bold"
    myApp.fontItalic = "Droid Sans"
    myApp.fontBoldItalic = "Droid Sans Bold"
    myApp.topBarBg = M.imgfld .. "topBarBg7.png"
else
    local coronaBuild = system.getInfo("build")
    if tonumber(coronaBuild:sub(6,12)) < 1206 then myApp.theme = "widget_theme_ios" end
end

-------------------------------------------------------
--  Start Parse
-------------------------------------------------------
parse:init({ appId = myApp.parse.appId , apiKey = myApp.parse.restApikey,})
parse.showStatus =  myApp.debugMode-- outputs response info in the console
--parse.showAlert = myApp.debugMode -- show a native pop-up with error and result codes
parse.showJSON = myApp.debugMode -- output the raw JSON response in the console 
--parse.dispatcher:addEventListener( "parseRequest", onParseResponse )
parse:appOpened(function (e) print ("return from appOpened") print (e.requestType)   end )
--parse:getObject("Agency","9ez6Z2tcaC", function(e) if not e.error then print ("BBBBAAACCCK " .. e.response.agencyName) end end )
parse:getConfig( 
     function(e) 
      print ("back from config " .. e.error)
          if (e.response.error or "" ) == "" then 
             myApp.appName = e.response.params.appName 
             myApp.extras = json.decode(json.encode(e.response.params.appExtras ))
             print ("back from extras")
          end 
      end )
--parse:logEvent( "MyCustomEvent", { ["x"] = "modparse" ,["y"] = "ccc"}, function (e) print ("return from home logevent") print (e.requestType)   end )

----------------------------------------
-- Was the scene laucnhed as a main tabbar sceene ?
----------------------------------------
function  myApp.MainSceneNavidate( parentinfo )
     local msn = false
     if parentinfo.sceneinfo then
        if parentinfo.sceneinfo.usage then
           if (parentinfo.sceneinfo.usage.navigate or "") == "mainscene" then
              msn = true
           end
        end
     end
     return msn
end

--------------------------------------
-- any user fields changing we need to be aware of ?
---------------------------------------
function  myApp.evtudchanged( event )
     if (event.name == "udchanged")   then
        debugpopup ("udchanged - " .. event.field  )
        -------------------------------
        -- first time ever successfully logged in ? send to help ?
        --------------------------------
        if event.field == "everloggedin" and event.value == true then
        end
     end
end
Runtime:addEventListener( "udchanged", myApp.evtudchanged )

--------------------------------------
-- login status change ?
---------------------------------------
function  myApp.evtloginchanged( event )
      print "evtloginchanged  "
      if event.value == true then
         --debugpopup ("loginchanged true   "  )
      else
         --debugpopup ("loginchanged false   "  )
      end
      myApp.BuildMoreInfoList( )

end
Runtime:addEventListener( "loginchanged", myApp.evtloginchanged )

-------------------------------------
-- agencies changes ?
---------------------------------------
function  myApp.evtagencieschanged( event )

  if (myApp.tabMyAgentKey or "") ~= "" then 
     ----------------------------
     -- generate new id so the scene will refresh itself if has already been run for the myagent
     -- if never run, no biggie
     ----------------------------

     myApp.tabs.btns[myApp.tabMyAgentKey].navigation.composer.id = tostring(math.random(10000)) 
     
     ------------------------------
     -- are we on this tab currently ? including drill down scenes
     -- start over on the tab
     ----------------------------
     if myApp.tabCurrentKey == myApp.tabMyAgentKey then
        myApp.showScreen({instructions=myApp.tabs.btns[myApp.tabMyAgentKey]})
     end 
  end

end
Runtime:addEventListener( "agencieschanged", myApp.evtagencieschanged )


-------------------------------------
-- policies changes ?
---------------------------------------
function  myApp.evtpolicieschanged( event )

  if (myApp.tabMyAccountKey or "") ~= "" then 
     ----------------------------
     -- generate new id so the scene will refresh itself if has already been run for the myagent
     -- if never run, no biggie
     ----------------------------
     myApp.tabs.btns[myApp.tabMyAccountKey].navigation.composer.id = tostring(math.random(10000))  
     
     ------------------------------
     -- are we on this tab currently ? including drill down scenes
     -- start over on the tab
     ----------------------------
     if myApp.tabCurrentKey == myApp.tabMyAccountKey then
        myApp.showScreen({instructions=myApp.tabs.btns[myApp.tabMyAccountKey]})
     end 
  end

end
Runtime:addEventListener( "policieschanged", myApp.evtpolicieschanged )

--------------------------------------
-- log me out ?
---------------------------------------
function  myApp.evtlogmeout( event )
      print "Logmeout event"
      myApp.fncUserLoggedOut( )
      
end
Runtime:addEventListener( "logmeout", myApp.evtlogmeout  )


function  myApp.getCurrentLocation( event )
        --local getGPS   -- forward reference
        local parms = event or {}
        myApp.gps.haveaccuratelocation = false
        native.setActivityIndicator( true ) 
        myApp.gps.currentlocation = {}
        local function locationHandler ( event )
            native.setActivityIndicator( false ) 
            Runtime:removeEventListener( "location", locationHandler )  
            myApp.gps.currentlocation = event
            if ( myApp.gps.currentlocation.errorCode or ( myApp.gps.currentlocation.latitude == 0 and myApp.gps.currentlocation.longitude == 0 ) ) then
                
               -- myApp.gps.attempts = myApp.gps.attempts + 1
               -- print ("locationHandler" .. myApp.gps.attempts)
              --  if ( myApp.gps.attempts > myApp.gps.maxattempts ) then
                    native.showAlert( myApp.gps.currentlocate.errortitle, myApp.gps.currentlocate.errormessage .. (myApp.gps.currentlocation.errorMessage or "Unknown"), { "Okay" } )
               -- else

                   -- timer.performWithDelay( myApp.gps.timebetweenattempts,  getGPS )
               -- end
           -- else
               -- myApp.gps.attempts = myApp.gps.maxattempts + 1    -- stop the looping - success
            else
                 myApp.gps.haveaccuratelocation = true
                 if myApp.debugMode and system.getInfo( "environment" ) == "simulator" then
                     myApp.gps.currentlocation.latitude = myApp.gps.debug.latitude 
                     myApp.gps.currentlocation.longitude = myApp.gps.debug.longitude 
                 end
            end
            ----------------------------------------------
            -- Caller wants us to run something ?
            ----------------------------------------------
            if parms.callback then  parms.callback() end
        end

       -- function getGPS( event )
             
       --     Runtime:addEventListener( "location",locationHandler )    
       -- end
       ------------------------------------------------
       -- start here
       ------------------------------------------------
      -- myApp.gps.currentlocation = {}
       --myApp.gps.attempts = 0
       --returncode = false
       Runtime:addEventListener( "location",locationHandler ) 
       --getGPS()
       -- while true do
       --     print (myApp.gps.attempts)
       --     if ( myApp.gps.attempts > myApp.gps.maxattempts ) then
       --         if ( myApp.gps.currentlocation.errorCode or ( myApp.gps.currentlocation.latitude == 0 and myApp.gps.currentlocation.longitude == 0 ) ) then
       --            break
       --         else
       --            returncode = true
       --            if myApp.debugMode then
       --               myApp.gps.currentlocation.latitude = myApp.gps.debug.latitude 
       --               myApp.gps.currentlocation.longitude = myApp.gps.debug.longitude 
       --            end
       --            break
       --         end
       --     end
       -- end
       -- Runtime:removeEventListener( "location", myApp.locationHandler )   
       --return returncode
end


function  myApp.getAddressLocation( event )
        local parms = event or {}
        print ("Calulating lat.lg for: " .. parms.address)

        local callbackexecuted = false
        local activityindicator = true
        if parms.activityindicator ~= nil then  activityindicator = parms.activityindicator end
        native.setActivityIndicator( activityindicator   ) 
        local myMap = native.newMapView( -100, -100, 20, 20 ) -- keep out the way
        

        local function addressHandler ( event )
            if callbackexecuted == false then
                callbackexecuted = true
                native.setActivityIndicator( false ) 
                myMap:removeSelf()
                myMap = nil
                
                if ( event.isError ) then
                    native.showAlert( myApp.gps.addresslocate.errortitle, myApp.gps.addresslocate.errormessage .. (event.errorMessage or "Unknown"), { "Okay" } )
                else
                     if myApp.debugMode then native.showAlert( "Location for " .. parms.address, "lat: " ..  event.latitude .. "  Long "..  event.longitude , { "Okay" } ) end
                end
                ----------------------------------------------
                -- Caller wants us to run something ?
                ----------------------------------------------
                if parms.callback then  parms.callback(event) end     
            end
        end


        if myMap then 
           myMap:requestLocation( parms.address, addressHandler ) 
           timer.performWithDelay(myApp.gps.addresslocate.loadwaittime, 
                         function() 
                            if callbackexecuted == false then 
                                callbackexecuted = true 
                                native.setActivityIndicator( false ) 
                                if parms.callback then  parms.callback(event) end  
                                native.showAlert( myApp.appName ,myApp.gps.addresslocate.timeoutmessage ,{"ok"}) 
                                
                            end 
                          end
                     ) 
        else 
           native.setActivityIndicator( false )  
        end
 
end


function  myApp.getNearestAddress( event )
        local parms = event or {}
        myApp.gps.nearestaddress = {}
      
        local function curlocback() 
            ------------------------------------------------------
            -- have accurate location ?
            ------------------------------------------------------
            if myApp.gps.haveaccuratelocation == true then
                --lat=myApp.gps.currentlocation.latitude,lng=myApp.gps.currentlocation.longitude}


                  local callbackexecuted = false
                  local activityindicator = true
                  if parms.activityindicator ~= nil then  activityindicator = parms.activityindicator end
                  native.setActivityIndicator(  activityindicator   ) 
                  local myMap = native.newMapView( -100, -100, 20, 20 ) -- keep out the way

                  local function nearaddressHandler ( event )
                      if callbackexecuted == false then
                          callbackexecuted = true
                          native.setActivityIndicator( false ) 
                          myMap:removeSelf()
                          myMap = nil
                          myApp.gps.nearestaddress = event
                          if ( event.isError ) then
                              if parms.showerroralert then
                                 native.showAlert( myApp.gps.nearestlocate.errortitle, myApp.gps.nearestlocate.errormessage .. (event.errorMessage or "Unknown"), { "Okay" } )
                              end
                          else
                               --if myApp.debugMode then native.showAlert( "neaAddress is " .. parms.address, "lat: " ..  event.latitude .. "  Long "..  event.longitude , { "Okay" } ) end
                          end
                          ----------------------------------------------
                          -- Caller wants us to run something ?
                          ----------------------------------------------
                          if parms.callback then  parms.callback(event) end     
                      end
                  end

                  if myMap then 
                      myMap:nearestAddress( myApp.gps.currentlocation.latitude,myApp.gps.currentlocation.longitude, nearaddressHandler ) 
                      timer.performWithDelay(myApp.gps.nearestlocate.loadwaittime, 
                                   function() 
                                      if callbackexecuted == false then 
                                          callbackexecuted = true 
                                          native.setActivityIndicator( false ) 
                                          if parms.callback then  parms.callback(event) end  
                                          if parms.showerroralert then
                                             native.showAlert( myApp.appName ,myApp.gps.nearestlocate.timeoutmessage ,{"ok"}) 
                                          end
                                      end 
                                    end
                               ) 
                  else 
                      native.setActivityIndicator( false )  
                  end
            else
              if parms.callback then  parms.callback(event) end  
            end   -- myApp.gps.haveaccuratelocation

        end  -- curlocback 
        myApp.getCurrentLocation({activityindicator=parms.activityindicator,callback=curlocback})    -- update the gps coordinate
 
end

--================================================
--== run once at the end
--================================================
function myApp.ExitApp (closedb)

     myApp.fncCCDBFlushUpdates()
   --  fncCCDBCleanup()  
     if closedb then 
         dbmodule.fncDBClose(myApp.mydb)
         print ("DB CLOSE")
     end
end

function myApp.onSystemEvent( event )
   local launchURL
   print("onSystemEvent start - " .. event.type)
   if event.type == "applicationStart" then
    elseif event.type == "applicationExit" then
        myApp.ExitApp(true)
    elseif event.type == "applicationSuspend" then
        myApp.ExitApp(false)
    elseif event.type == "applicationResume" then
    elseif event.type == "applicationOpen" then
        if event.url then
            launchURL = event.url
            debugpopup( "AppOpened - Launched in from another app - " .. launchURL ) -- output: coronasdkapp://mycustomstring
        end
    end
end

--myApp.updateGPS()
Runtime:addEventListener( "system", myApp.onSystemEvent )



