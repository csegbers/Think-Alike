---------------------------------------------------------------------------------------
-- locate me scene
---------------------------------------------------------------------------------------
local myApp = require( "myapp" ) 
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local widgetExtras = require( myApp.utilsfld .. "widget-extras" )
local myApp = require( "myapp" ) 

local common = require( myApp.utilsfld .. "common" )
local parse = require( myApp.utilsfld .. "mod_parse" ) 

local currScene = (composer.getSceneName( "current" ) or "unknown")
print ("Inxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " .. currScene .. " Scene")

local sceneparams
local sceneinfo
local container
local itemGrp
local myLoc
local myMap
local spinner 


------------------------------------------------------
-- The map. centered and marked for the 1 item
------------------------------------------------------
local function buildMap( event )
      --native.setActivityIndicator( true ) 

      local mapheight = myApp.sceneHeight-itemGrp.height-sceneinfo.edge*3
      myMap = native.newMapView( 0, 0, myApp.sceneWidth-sceneinfo.edge*2 , mapheight  )   -- cause
      if myMap and myApp.gps.currentlocation.latitude then
         myMap.mapType = sceneinfo.map.type -- other mapType options are "satellite" or "hybrid"

      -- The MapView is just another Corona display object, and can be moved or rotated, etc.
         myMap.x = myApp.cCx
         myMap.y = myApp.sceneStartTop + itemGrp.height  + sceneinfo.edge+ mapheight/2 + sceneinfo.edge

         myMap:setCenter( myApp.gps.currentlocation.latitude, myApp.gps.currentlocation.longitude, false )
         myMap:setRegion(  myApp.gps.currentlocation.latitude, myApp.gps.currentlocation.longitude, sceneinfo.map.latitudespan, sceneinfo.map.longitudespan, false)

      end
     -- native.setActivityIndicator( false ) 
end


------------------------------------------------------
-- Called first time. May not be called again if we dont recyle
------------------------------------------------------
function scene:create(event)

    print ("Create  " .. currScene)
    -- local group = self.view
    -- sceneparams = event.params or {}

end

function scene:show( event )

    local group = self.view
    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
             --------------------------
             -- Setting params needed on the "Will" phase !!!!
             --------------------------
             sceneparams = event.params or {}          -- params contains the item table 
             sceneinfo = sceneparams.sceneinfo --  myApp.otherscenes.xxxxxx.sceneinfo
              
             display.remove( container )           -- wont exist initially no biggie
             container = nil

             container  = common.SceneContainer()
             group:insert(container )

             ---------------------------------------------
             -- lets create the group
             ---------------------------------------------

             itemGrp = display.newGroup(  )
             local headcolor = sceneinfo.groupheader  
             local startX = 0
             local startY = 0 -myApp.cH/2 + sceneinfo.groupheight/2 + sceneinfo.edge*2 + myApp.sceneStartTop
             local groupwidth = myApp.sceneWidth-sceneinfo.edge*2
             local dumText = display.newText( {text="X",font= myApp.fontBold, fontSize=sceneinfo.textfontsize})
             local textHeightSingleLine = dumText.height

             local startYother = startY  
             
             -------------------------------------------------
             -- Background
             -------------------------------------------------
             local myRoundedRect = display.newRoundedRect(startX, startY , groupwidth-sceneinfo.groupstrokewidth*2,sceneinfo.groupheight, 1)
             myRoundedRect:setFillColor(sceneinfo.groupbackground.r,sceneinfo.groupbackground.g,sceneinfo.groupbackground.b,sceneinfo.groupbackground.a )
             myRoundedRect.strokeWidth = sceneinfo.groupstrokewidth
             myRoundedRect:setStrokeColor( headcolor.r,headcolor.g,headcolor.b ) 
             itemGrp:insert(myRoundedRect)

             -------------------------------------------------
             -- Header Background
             -------------------------------------------------
             local startYother = startY- sceneinfo.groupheight/2  
             local myRoundedTop = display.newRoundedRect(startX, startYother ,groupwidth, sceneinfo.groupheaderheight, 1 )
             myRoundedTop:setFillColor(headcolor.r,headcolor.g,headcolor.b,headcolor.a )
             itemGrp:insert(myRoundedTop)
             
             -------------------------------------------------
             -- Header text
             -------------------------------------------------
             local myText = display.newText( sceneparams.title, startX, startYother,  myApp.fontBold, sceneinfo.headerfontsize )
             myText:setFillColor( sceneinfo.headercolor.r,sceneinfo.headercolor.g,sceneinfo.headercolor.b,sceneinfo.headercolor.a )
             itemGrp:insert(myText)



             ----------------------------------------------------------
             --   Action button ? button
             ----------------------------------------------------------
             local dialbtnwidth = 0
             if sceneinfo.dialbutton then
                 local btnDial = widget.newButton {
                            defaultFile = myApp.imgfld .. sceneinfo.dialbutton.defaultFile,
                            overFile = myApp.imgfld .. sceneinfo.dialbutton.overFile,
                            height = sceneinfo.dialbutton.height,
                            width = sceneinfo.dialbutton.width,
                            x = groupwidth/2 * -1 +  sceneinfo.dialbutton.width/2 + sceneinfo.edge,
                            y = startYother + itemGrp.height/2  ,
                            onRelease = function() myApp.navigationCommon(sceneinfo.dialbutton.dial) end,
                       }

                    itemGrp:insert(btnDial) 
                    dialbtnwidth = sceneinfo.dialbutton.width
             end
 
             -------------------------------------------------
             -- current address location text
             -------------------------------------------------
             myLoc = display.newText( {text=sceneinfo.calctext, x=startX + dialbtnwidth/2 + sceneinfo.edge/2, y=0, height=0,width=groupwidth-sceneinfo.edge*2 -dialbtnwidth ,font= myApp.fontBold, fontSize=sceneinfo.textfontsize,align="center" })
             myLoc.y=startYother+sceneinfo.groupheight - (myLoc.height/2) -  sceneinfo.groupheaderheight - sceneinfo.textbottomedge
             myLoc:setFillColor( sceneinfo.textcolor.r,sceneinfo.textcolor.g,sceneinfo.textcolor.b,sceneinfo.textcolor.a )
             itemGrp:insert(myLoc)

             spinner = widget.newSpinner {x = myLoc.x,y = myLoc.y + sceneinfo.edge*3,}
             itemGrp:insert( spinner )
             spinner:start()

            --  myLoc.text = sceneinfo.text ..   "\n\n" .. "12293" .. " " .. "Mallard Pond Ct".. "\n" .. "Pickerington" .. ", " .. "Ohio" .. "  " .. "43147-3434"

             myApp.getNearestAddress({showerroralert=false,activityindicator=false,callback=
                         function() 
                            if spinner and spinner.removeSelf then
                              spinner:removeSelf()
                              spinner = nil
                            end
                            local address = myApp.gps.nearestaddress
                            -- address may or may not exist if the service dod not work
                            if address.streetDetail then
                               myLoc.text = sceneinfo.approxtext ..   "\n\n" .. (address.streetDetail or "") .. " " .. (address.street  or "") .. "\n" .. (address.city  or "") .. ", " .. (address.region  or "") .. "  " .. (address.postalCode  or "")
                            else
                               myLoc.text = sceneinfo.unabletext
                            end
                         end
                         } ) 

             container:insert(itemGrp)

    elseif ( phase == "did" ) then
        parse:logEvent( "Scene", { ["name"] = currScene} )
        --sceneparams = event.params           -- params contains the item table
         buildMap()

    end
  

end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        if myMap and myMap.removeSelf then
          myMap:removeSelf()
          myMap = nil
        end
        if spinner and spinner.removeSelf then
            spinner:removeSelf()
            spinner = nil
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
---------------------------------------------------
function scene:overlay( parms )
     print ("overlay happening on top of " .. currScene .. " " .. parms.type .. " " .. parms.phase)
     if parms.phase == "will"  then
         local slidex = myApp.cW --/ 2  + myApp.tabs.tabBarHeight  + myApp.tSbch
         local alphatype = 0
         local slidextype = 1
         if parms.type == "hide"  then
            alphatype = 1
            slidextype = -1
         end
         transition.to(  myMap, {  time=parms.time/2,alpha=alphatype})
      --   transition.to(  myMap, {  time=parms.time/2,delta=true, x =  slidex * slidextype })
     end
end


---------------------------------------------------
-- use if someone wants us to transition away
-- for navigational appearnaces
-- used from the more button
---------------------------------------------------
 
function scene:morebutton( parms )
     transition.to(  myMap, {  time=parms.time,delta=true, x = parms.x , transition=parms.transition})
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene