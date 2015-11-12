---------------------------------------------------------------------------------------
-- HOME scene
---------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myApp = require( "myapp" ) 
local common = require( myApp.utilsfld .. "common" )

local currScene = (composer.getSceneName( "current" ) or "unknown")
print ("In " .. currScene .. " Scene")

local sceneparams
local scrollView
local container

function scene:create(event)
  print ("Create  " .. currScene)
    local group = self.view
    sceneparams = event.params or {}

    container = common.SceneContainer()
    group:insert(container)
 

end

function scene:show( event )


    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
         sceneparams = event.params           -- params contains the item table 
            local group = self.view

            scrollView = widget.newScrollView
                {
                    x = 0,
                    y = 0,
                    width = myApp.sceneWidth, 
                    height =  myApp.sceneHeight,
                    horizontalScrollDisabled = true,
                    hideBackground = true,
                }
            container:insert(scrollView)



            local starty = 10


            local function renderInfo(whatText)
                starty = starty + 10
                local disNt = display.newText( whatText, myApp.cCx, starty, native.systemFont, 12 )
                disNt:setFillColor( 1, 0, 0 )
                scrollView:insert(disNt)
                starty = starty + disNt.height
            end

            ---------------------------------------------------
            -- gps info
            ---------------------------------------------------
            myApp.getCurrentLocation( {callback=
                 function() 
                    renderInfo("latitude " .. string.format( '%.4f', (myApp.gps.currentlocation.latitude or 0)))
                    renderInfo("longitude " .. string.format( '%.4f', (myApp.gps.currentlocation.longitude or 0)))
                    renderInfo("altitude " .. string.format( '%.4f', (myApp.gps.currentlocation.altitude or 0)))
                    renderInfo("accuracy " .. string.format( '%.4f', (myApp.gps.currentlocation.accuracy or 0)))
                    renderInfo("speed " .. string.format( '%.4f', (myApp.gps.currentlocation.speed or 0)))
                    renderInfo("direction " .. string.format( '%.4f', (myApp.gps.currentlocation.direction or 0)))
                    renderInfo("time " .. string.format( '%.4f', (myApp.gps.currentlocation.time or 0)))
                    renderInfo("errorcode " ..  ( myApp.gps.currentlocation.errorCode or "" ))
                    renderInfo("erromessage " .. ( myApp.gps.currentlocation.errorMessage or "" ))

                    renderInfo("  " )                    
                  end })

                ---------------------------------------------------
                -- other info
                ---------------------------------------------------
               
                for k,v in pairs(myApp.deviceinfo) do 
 
                     if v.cat then
                        fieldvalue = system.getPreference( v.cat, v.name )
                     else
                        fieldvalue = system.getInfo( v.name )
                     end
                    renderInfo(v.title .. " Value: " .. fieldvalue)
                end  

            renderInfo(" ")

               ------------
               -- user
               ----
               renderInfo("email " ..  ( myApp.authentication.email or "" ))
               renderInfo("emailVerified " ..  tostring(( myApp.authentication.emailVerified or "" )))
               renderInfo("username " ..  ( myApp.authentication.username or "" ))
               renderInfo("user objectId " ..  ( myApp.authentication.objectId or "" ))
               renderInfo("sessionToken " ..  ( myApp.authentication.sessionToken or "" ))
               renderInfo("agencycode " ..  ( myApp.authentication.agencycode or "" ))
              

               renderInfo(" ")
 

    elseif ( phase == "did" ) then
               

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
	

end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
             if scrollView   then 
                scrollView:removeSelf()
               scrollView = nil
            end
    end

end

function scene:destroy( event )
 
    print ("Destroy "   .. currScene)
end

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