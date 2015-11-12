---------------------------------------------------------------------------------------
-- menu scene
---------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myApp = require( "myapp" ) 
local common = require( myApp.utilsfld .. "common" )


local currScene = (composer.getSceneName( "current" ) or "unknown")
print ("In " .. currScene .. " Scene")

local titleText
local locationtxt
local views = {}
local params


local function ignoreTouch( event )
	return true
end

function scene:create(event)
        print "menu createscene"
	local group = self.view
    params = event.params or {}

    local background = common.SceneBackground()
    group:insert(background)
	background:addEventListener("touch", ignoreTouch)

    local button1 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Corona Blogs",
        labelColor = { 
            default =  myApp.saColor, 
            over = myApp.saColorTrans, 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreen2
    })
    group:insert(button1)
    button1.x = display.contentCenterX
    button1.y = display.contentCenterY - 120


    local button2 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Photo Gallery",
        labelColor = { 
            default = { 232/myApp.colorDivisor, 153/myApp.colorDivisor, 87/myApp.colorDivisor, 255/myApp.colorDivisor }, 
            over = { 202/myApp.colorDivisor, 123/myApp.colorDivisor, 77/myApp.colorDivisor, 255/myApp.colorDivisor} 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreen3
    })
    group:insert(button2)
    button2.x = display.contentCenterX
    button2.y = display.contentCenterY - 40


    local button3 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Corona Videos",
        labelColor = { 
            default = { 232/myApp.colorDivisor, 153/myApp.colorDivisor, 87/myApp.colorDivisor, 255/myApp.colorDivisor }, 
            over = { 202/myApp.colorDivisor, 123/myApp.colorDivisor, 77/myApp.colorDivisor, 255/myApp.colorDivisor} 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreen4
    })
    group:insert(button3)
    button3.x = display.contentCenterX
    button3.y = display.contentCenterY + 40

    local button4 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Map",
        labelColor = { 
            default = { 232/myApp.colorDivisor, 153/myApp.colorDivisor, 87/myApp.colorDivisor, 255/myApp.colorDivisor }, 
            over = { 202/myApp.colorDivisor, 123/myApp.colorDivisor, 77/myApp.colorDivisor, 255/myApp.colorDivisor} 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreen5
    })
    group:insert(button4)
    button4.x = display.contentCenterX
    button4.y = display.contentCenterY + 120
 
end

function scene:show( event )
 
    local group = self.view
    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
         params = event.params           -- params contains the item table 
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
       


    end
end

function scene:hide( event )
	local group = self.view

	--
	-- Clean up native objects
	--

end

function scene:destroy( event )
	local group = self.view
end

function scene:myparams( event )
       return params
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene