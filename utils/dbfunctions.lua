-------------------------------------------------------
-- Loaded once in startup, used for some common db functions
-------------------------------------------------------
local myApp = require( "myapp" ) 
local dbmodule = require( myApp.utilsfld ..  "dbmodule")  
local crypto = require "crypto"
require( "sqlite3" ) 

-------------------------------------------------------
-- Database intiation
-------------------------------------------------------
local retsta,reterr
myApp.mydb.dbname = myApp.databasename
myApp.mydb.dbpath = system.pathForFile(myApp.databasename, system.DocumentsDirectory)
myApp.mydb.dbconfig = require( myApp.myappadds .. "myappdbconfig" ) 
myApp.mydb.compactdb = false     -- set to true to compact when we leave
retsta,reterr = dbmodule.fncDBLoad(myApp.mydb)
--myApp.mydb.dbref eill have the db reference now

function myApp.fncGetHash (value)
  return crypto.hmac( crypto.sha256, value, myApp.hashkey )
end

function myApp.fncGetUD (infld)

   local parms = myApp.mydb.dbconfig.dbschema.UD
   local tf = parms.fields[infld].name     -- actual field name in database not key in config
   local lCC = myApp.mydb.lCC
   if lCC[tf] == nil then
       lCC[tf] = {}
       for row in myApp.mydb.dbref:nrows("SELECT " .. tf .. " FROM " ..parms.table .. " where " .. parms.key .. " = " .. parms.defrec ) do
         lCC[tf].value = row[tf]
         lCC[tf].dirty = false
         print ("retrieve field",infld,tf,row[tf],lCC[tf].value or "")
         break
     end
   end
    print ("return field",infld,tf,lCC[tf].value or "")
   return (lCC[tf].value or "")
end

function myApp.fncPutUD (infld,value)
   local parms = myApp.mydb.dbconfig.dbschema.UD
   local tf = parms.fields[infld].name
   local lCC = myApp.mydb.lCC
   --print ("fncPutUD",infld,value,lCC[tf].value)
   if lCC[tf] == nil then myApp.fncGetUD(infld) end     -- may or may not have read from table. No biggie if not since we are updating
   print ("field should we update " ,infld,lCC[tf].value,value)
   if parms.fields[infld].storehashed == true then value = myApp.fncGetHash(value) end
   if lCC[tf].value ~= value then
       local ov = lCC[tf].value
       lCC[tf].value = value    
       print ("field updated " .. infld )
       lCC[tf].dirty = true
       Runtime:dispatchEvent{ name="udchanged",field=infld,value=value,oldvalue=ov }
   end

end

--================================================
--== Updates pending db changes
--================================================
function myApp.fncCCDBFlushUpdates()
    if myApp.mydb.dbref and myApp.mydb.dbref:isopen() then
       local upstr =nil
       local key,value
       for key,value in pairs(myApp.mydb.lCC) do
            if value.dirty == true then
                value.dirty = false
                if upstr ~= nil then upstr = upstr .. ", " else upstr = "" end
                upstr = upstr .. key .. [[ = ']] .. value.value .. [[']]
                print ("Updating UD Table Key ".. key ..  " value " .. value.value )
            end 
        end    -- for
        if upstr then
          local parms = myApp.mydb.dbconfig.dbschema.UD
          local defsetup = [[Update ]] .. parms.table .. [[ set ]] ..upstr.. [[ where ]] .. parms.key .. [[ = ]] .. parms.defrec .. [[;]] -- 1 record
          myApp.mydb.dbref:exec( defsetup )
          if myApp.mydb.dbref:errcode() ~= 0 then 
             parse:logEvent( "Error", { ["name"] = "dbupdate",["errorcode"] = myApp.mydb.dbref:errcode() ,["errormessage"] = myApp.mydb.dbref:errmsg() } )
             native.showAlert( "Error Saving User Defaults",("Write User Defaults Failed - Reason failed: " .. myApp.mydb.dbref:errcode() .. "-" .. myApp.mydb.dbref:errmsg()),{ "OK" })
          end
        end   -- if upstr 
    end
end



