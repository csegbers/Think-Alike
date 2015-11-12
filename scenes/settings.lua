---------------------------------------------------------------------------------------
-- settings scene
---------------------------------------------------------------------------------------
local myApp = require( "myapp" ) 
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local widgetExtras = require( myApp.utilsfld .. "widget-extras" )
local myApp = require( "myapp" ) 

local parse = require( myApp.utilsfld .. "mod_parse" ) 
local common = require( myApp.utilsfld .. "common" )

local currScene = (composer.getSceneName( "current" ) or "unknown")
print ("Inxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " .. currScene .. " Scene")

local sceneparams
local container


------------------------------------------------------
-- Called first time. May not be called again if we dont recyle
------------------------------------------------------
function scene:create(event)

    print ("Create  " .. currScene)
    local group = self.view
    sceneparams = event.params or {}

end

function scene:show( event )

    local group = self.view
    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
        parse:logEvent( "Scene", { ["name"] = currScene} )
        --sceneparams = event.params           -- params contains the item table
    end
  
end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
 

    elseif ( phase == "did" ) then
    end

end

function scene:destroy( event )
  
    print ("Destroy "   .. currScene)
end

---------------------------------------------------
-- use if someone wants us to transition away
-- for navigational appearnaces
---------------------------------------------------
function scene:myparams( event )
       return sceneparams
end

---------------------------------------------------
-- if an overlay is happening to us
-- type (hide show)
-- phase (will did)
---------------------------------------------------
function scene:overlay( parms )
     print ("overlay happening on top of " .. currScene .. " " .. parms.type .. " " .. parms.phase)
 
end
---------------------------------------------------
-- use if someone wants us to transition away
-- for navigational appearnaces
-- used from the more button
---------------------------------------------------
 
function scene:morebutton( parms )
     
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene