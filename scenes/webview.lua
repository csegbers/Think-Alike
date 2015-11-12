---------------------------------------------------------------------------------------
-- locateagent scene
---------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myApp = require( "myapp" ) 

local parse = require( myApp.utilsfld .. "mod_parse" ) 
local common = require( myApp.utilsfld .. "common" )

local currScene = (composer.getSceneName( "current" ) or "unknown")
print ("Inxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " .. currScene .. " Scene")

local sceneparams
local webView

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
    sceneparams = event.params or {}

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
            parse:logEvent( "Scene", { ["name"] = currScene} )
            local pagewasloaded = false

            local function webListener( event )
                if event.type == "loaded" or event.type == "timeout"  and pagewasloaded == false then
                    pagewasloaded = true
                    if webView then
                       webView.isVisible = true
                       webView:removeEventListener( "urlRequest", webListener)
                    end
                    native.setActivityIndicator( false )
                    if  event.type == "timeout"  then
                        native.showAlert( myApp.appName ,myApp.webview.timeoutmessage ,{"ok"}) 
                    end
                end
            end
            -------------------------------------
            -- note this wont show in windows simulator but 
            -- doesnt error. 
            -------------------------------------
            webView = native.newWebView( myApp.sceneWidth / 2, myApp.sceneHeight  /2 + myApp.sceneStartTop,myApp.sceneWidth,myApp.sceneHeight )
            
            webView.isVisible = false
            --webView:reload()
            webView:addEventListener( "urlRequest", webListener )
            --debugpopup(sceneparams.htmlinfo.url )
            local url = sceneparams.sceneinfo.htmlinfo.url

            timer.performWithDelay(myApp.webview.pageloadwaittime, function() webListener({type="timeout"}) end) 
            if sceneparams.sceneinfo.htmlinfo.url then
                if string.sub(url, 1, 4):upper() ~= "HTTP" then  url = "http://" .. url end
                native.setActivityIndicator( true )
                webView:request( url )
            elseif  sceneparams.sceneinfo.htmlinfo.htmlfile then
                webView:request( myApp.htmlfld .. sceneparams.sceneinfo.htmlinfo.htmlfile , sceneparams.sceneinfo.htmlinfo.dir )
            elseif sceneparams.sceneinfo.htmlinfo.youtubeid then

                     local temphtml = "youtube.html"
                     local temphtmlpath  = system.pathForFile( temphtml, system.TemporaryDirectory )
                     local fh, errStr = io.open( temphtmlpath, "w" )
 
                     if fh then
                        print( "Created file" )
                        fh:write("<!DOCTYPE html><html><body>")
                        fh:write([[<iframe id="ytplayer" type="text/html" width="]] ..  myApp.sceneWidth .. [[" height="]] .. myApp.sceneHeight .. [[" src="http://www.youtube.com/embed/]] .. sceneparams.sceneinfo.htmlinfo.youtubeid  .. [[?rel=0&autoplay=1" allowfullscreen frameborder="0"/>]])
                        fh:write("</body></html>")
                        io.close( fh )
                     else
                         print( "Create file failed!" )
                    end

                    webView:request( temphtml , system.TemporaryDirectory )

            end
            
    end	

end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        if webView and webView.removeSelf then
            native.setActivityIndicator( false )     -- just incase
            webView:removeSelf()
            webView = nil
        end

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
--
-- must slide away so overlay scene can perform
---------------------------------------------------
function scene:overlay( parms )
     print ("overlay happening on top of " .. currScene .. " " .. parms.type .. " " .. parms.phase)
     if parms.phase == "will"  then
         local slidey = myApp.cH --/ 2  + myApp.tabs.tabBarHeight  + myApp.tSbch
         local alphatype = 0
         local slideytype = 1
         if parms.type == "hide"  then
            alphatype = 1
            slideytype = -1
         end
         transition.to(  webView, {  time=parms.time/2,alpha=alphatype})
         transition.to(  webView, {  time=parms.time/2,delta=true, y =  slidey * slideytype })
       --  transition.to(  webView, {  time=parms.time,delta=true, y=(parms.height + 20 -parms.height/2)* deltamult  , height = (parms.height+40) *deltamult*-1  , transition=parms.transition})
     end
end
---------------------------------------------------
-- use if someone wants us to transition away
-- for navigational appearnaces
-- used from the more button
---------------------------------------------------
function scene:morebutton( parms )
     transition.to(  webView, {  time=parms.time,delta=true, x = parms.x , transition=parms.transition})
end

---------------------------------------------------
-- Title bar navigation hit. Do we do something ?
---------------------------------------------------
function scene:navigationhit( parms )

     local returncode = false
     if parms.phase == "back" and webView.canGoBack then
        returncode = true
        webView:back()
     elseif parms.phase == "forward"  then     -- go ahead and set true even if we cant go forward since no other nav is needed
        returncode = true
        if  webView.canGoForward then
           webView:forward()
        end
     end
     return returncode
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene