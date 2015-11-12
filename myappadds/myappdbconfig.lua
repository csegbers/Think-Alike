local M = {}

---------------------------------------------------
-- Database User Defaults
--
-- note UNIQUE and NOT NULL apparently are not allowed with this sqlite
--
-- DEFAULT values will update existing records and new records !!
---------------------------------------------------	
M.dbenvironment = {}
M.dbschema = { 
	         UD = {   
					table = "tblUD",
					key= "udid",
					keyatt = "INTEGER PRIMARY KEY",
					defrec = 1,
					fields= {
								pin = {name="udpin",title="PIN",att="TEXT", def="",reset=false},
								
								userid = {name="uduserid",title="UserID",att="TEXT", def="",reset=false},
								email = {name="udemail",title="Email",att="TEXT", def="",reset=false},
								everloggedin = {name="udeverlogedin",title="Ever Logged In",att="INTEGER", def=0,reset=false},
																															
							},


					},
				}


return M