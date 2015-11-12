--module(..., package.seeall)
local M = {}

--================================================
--== DB Load
--================================================
local fncDBLoadGeneric = function(dbref,parms,insertdef)
       local retsta = true
       local reterr = ""

	   --======================================
	   --== create db table
	   --======================================
       dbref:exec( [[CREATE TABLE IF NOT EXISTS ]] .. parms.table .. [[ (]] .. parms.key .. [[ ]] .. parms.keyatt .. [[);]] )
       if dbref:errcode() ~= 0 then reterr = ("DBError-" .. dbref:errcode() .. "-" .. dbref:errmsg()) retsta = false end
 
       
       if retsta then
	   	    --======================================
	        --== Insert default record ?
	        --======================================
	        if insertdef  then
				local haverec = false
				for row in dbref:nrows("SELECT * FROM " ..  parms.table  .. " where " .. parms.key .. " = " .. parms.defrec  ) do
					haverec = true
				end
				if haverec == false then
				   dbref:exec( [[insert into ]] .. parms.table .. [[(]] ..  parms.key .. [[) values(]] .. parms.defrec .. [[)]] )
				   if dbref:errcode() ~= 0 then   reterr = ("DBError-" .. dbref:errcode() .. "-" .. dbref:errmsg()) retsta = false	   end
				   print ("last rowid", M.fncDBLastID(dbref))
				end
			end
		   --==============================
		   --== Add new columns as needed with new releases so we dont wipe out existing data
		   --==============================
	        if retsta then
				local sql = nil
				local key, value, v,numcols,tb, found
				local found = false
				for key,value in pairs(parms.fields) do
				    --=======================================
					--== Grab current colums - do this once
					--=======================================
					if sql == nil then
						sql = [[select * from ]] .. parms.table .. [[ limit 1;]]
						local stmt = dbref:prepare(sql)
						tb = stmt:get_names()
						if dbref:errcode() ~= 0 then reterr = ("DBError-" .. dbref:errcode() .. "-" .. dbref:errmsg()) retsta = false end
						numcols = stmt:columns()
					end
					--=========================================
					--== Add column if not on db
					--=========================================
					found = false
					for v = 1, numcols do
						if tb[v] == value.name then found = true break end
					end
					if found == false then
					   local tablesetup = [[ALTER TABLE ]] .. parms.table .. [[ ADD COLUMN ]] .. value.name .. [[ ]] .. value.att .. [[;]]
					   print (tablesetup)
					   dbref:exec( tablesetup )
					   if dbref:errcode() ~= 0 then reterr = ("DBError-" .. dbref:errcode() .. "-" .. dbref:errmsg()) retsta = false end
					   --==================================
					   --== do we have a table with a defualt record ?
					   --== update the default value for that record with this new column
					   --===================================
					   if value.def and insertdef and retsta then
					      local thedefault = value.def
					      if thedefault == "currentdate" then thedefault = os.time() end
						  local defsetup = [[Update ]] .. parms.table .. [[ set ]] .. value.name .. [[ = ']] .. thedefault .. [[' where ]] .. parms.key .. [[ = ]] .. parms.defrec .. [[;]] -- 1 record
						  dbref:exec( defsetup )
						  if dbref:errcode() ~= 0 then reterr = ("DBError-" .. dbref:errcode() .. "-" .. dbref:errmsg()) retsta = false end
					   end
					end
					if retsta == false then break end
				end
			end

	  end
	  --======================================
	  --== create db indexes if not exists
	  --== do last ion case new fields aded
	  --======================================
      if retsta and parms.indexes then
           local keyindex, valueindex
           for keyindex,valueindex in pairs(parms.indexes) do
			   --print ("INDEX ",[[CREATE INDEX IF NOT EXISTS ]] .. keyindex .. [[ ON ]] .. parms.table .. [[ (]] .. valueindex .. [[);]] )
			   dbref:exec( [[CREATE INDEX IF NOT EXISTS ]] .. keyindex .. [[ ON ]] .. parms.table .. [[ (]] .. valueindex .. [[);]] )
			   if dbref:errcode() ~= 0 then reterr = ("DBError-" .. dbref:errcode() .. "-" .. dbref:errmsg()) retsta = false end
			   if retsta == false then break end
           end
      end
      return retsta,reterr
end 
--=================================================
--== Primary function to call. Pass in parms with dbpath and dbconfig table which must have .dbschema we will set dbref
--=================================================
M.fncDBLoad = function(parms)
      local retsta = true   
      local reterr,k,v

      print ("DB file to open or create " .. parms.dbpath)
      parms.dbref = sqlite3.open(parms.dbpath ) 

	  for k,v in pairs(parms.dbconfig.dbschema) do 
	      retsta,reterr = fncDBLoadGeneric(parms.dbref,parms.dbconfig.dbschema[k],(v.defrec and true or false))
	      if not retsta then break end
	  end
	  
	  return retsta,reterr
end
--=================================================
--== Primary function to call to close. Pass in parms with dbref already set
--=================================================
M.fncDBClose = function(parms)
      local retsta = true   
      local reterr 

      if parms.dbref and parms.dbref:isopen() then
	     print ("DB Close")
	     parms.dbref:close() 
	     if parms.compactdb then
	     	print ("DB Compacting")
	     	parms.dbref = sqlite3.open( parms.dbpath )     -- have it closed first
			parms.dbref:exec("vacuum")
			parms.dbref:close()
		 end
	  end
	  return retsta,reterr
end
--=================================================
--== Get Last Inserted ID into database
--=================================================
M.fncDBLastID = function(dbref)
	  return dbref:last_insert_rowid()
end

return M