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
local sceneid
local container
local myList
local runit  
local justcreated  
local myMap
local myDesc
local itemGrp
local curmyListy 


  ------------------------------------------------------
  -- Row is rendered
  ------------------------------------------------------
local  onRowRender = function ( event )

         --Set up the localized variables to be passed via the event table

         local row = event.row
         local id = row.index
         local params = event.row.params
         print ("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" .. params.name)

         -- row.bg = display.newRect( 0, 0, display.contentWidth, 60 )
         -- row.bg.anchorX = 0
         -- row.bg.anchorY = 0
         -- row.bg:setFillColor( 1, 1, 1 )
         -- row:insert( row.bg )

         if ( event.row.params ) then    
            row.nameText = display.newText( params.name, 0, 0, myApp.fontBold, myApp.locate.row.nametextfontsize )
            row.nameText.anchorX = 0
            row.nameText.anchorY = 0.5
            row.nameText:setFillColor( myApp.locate.row.nametextColor )
            row.nameText.y = myApp.locate.row.nametexty
            row.nameText.x = myApp.locate.row.nametextx

            --local addressline = (params.street or "") .. "\n" .. (params.city or "") .. ", " .. (params.state or "") .. " " .. (params.zip or "") 
            row.addressText = display.newText( params.address, 0, 0, row.width / 2,0,myApp.fontBold, myApp.locate.row.addresstextfontsize  )
            row.addressText.anchorX = 0
            row.addressText.anchorY = 0.5
            row.addressText:setFillColor( myApp.locate.row.addressColor )
            row.addressText.y = myApp.locate.row.addresstexty
            row.addressText.x = myApp.locate.row.addresstextx

            row.milesText = display.newText( "Miles: " .. string.format( '%.2f', params.miles ), 0, 0, myApp.fontBold, myApp.locate.row.milestextfontsize )
            row.milesText.anchorX = 0
            row.milesText.anchorY = 0.5
            row.milesText:setFillColor( myApp.locate.row.milesColor )
            row.milesText.y = myApp.locate.row.milestexty
            row.milesText.x = myApp.locate.row.milestextx

            row.rightArrow = display.newImageRect(myApp.icons, 15 , myApp.locate.row.arrowwidth, myApp.locate.row.arrowheight)
            row.rightArrow.x = row.width - myApp.locate.row.arrowwidth/2
            row.rightArrow.y = row.height / 2

            row:insert( row.nameText )
            row:insert( row.addressText )
            row:insert( row.milesText )
            row:insert( row.rightArrow )
         end
         return true
end

 


 local function launchLocateDetailsScene(queryvalue) 

          local objecttype = sceneparams.locateinfo.object    -- Agency, BodyShop etc...
          local objectgroup = myApp.mappings.objects[objecttype]
          local objectqueryvalue = queryvalue

          local locatedetails = {  
                     objecttype = objecttype,
                     objectqueryvalue = queryvalue,
                     title = objectgroup.desc.singular, 
                     pic=sceneparams.pic,
                     originaliconwidth = sceneparams.originaliconwidth,
                     originaliconheight = sceneparams.originaliconheight,
                     iconwidth = sceneparams.iconwidth,      -- height will be scaled appropriately
                     backtext = objectgroup.backtext,

                     navigation = { 
                           composer = {
                                          -- this id setting this way we will rerun if different than prior request either object type, value etc etc...
                                         id = objecttype.."-" ..queryvalue,   
                                         lua=objectgroup.navigation.composer.lua ,
                                         time=objectgroup.navigation.composer.time, 
                                         effect=objectgroup.navigation.composer.effect,
                                         effectback=objectgroup.navigation.composer.effectback,
                                      },
                                 },
                     }      

             local parentinfo =  sceneparams 
             locatedetails.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
             myApp.showSubScreen ({instructions=locatedetails})

 end



local onRowTouch = function( event )
        local row = event.row
        if myMap then myMap:setCenter( row.params.lat, row.params.lng ,true ) end
        
        if event.phase == "press"  then     

                print ("press")
        elseif event.phase == "tap" then
               print ("tap")
        elseif event.phase == "swipeLeft" then

               print ("sl")
        elseif event.phase == "swipeRight" then
               print ("sr")
 
        elseif event.phase == "release" then
               print ("release")
               launchLocateDetailsScene( row.params.id)
            -- force row re-render on next TableView update
            
        end
    return true
end


local function markerSelected( event, params )
    print("type: ", event.type) -- event type
    print("markerId: ", event.markerId) -- id of the marker that was touched
    print("lat: ", event.latitude) -- latitude of the marker
    print("long: ", event.longitude) -- longitude of the marker
    myList:scrollToIndex( params.rowindex )
end

local function buildMap( event )
   native.setActivityIndicator( true ) 
   ---------------------------------------------
   -- loop thru results and mark
   ---------------------------------------------
   local tableViewRows = myList._view._rows
   if myMap then
     for k, row in ipairs(tableViewRows) do

         local options = { 
                  title=row.params.name, 
                  subtitle=(row.params.street or "") .. " " .. (row.params.city or "") .. ", " .. (row.params.state or "") .. " " .. (row.params.zip or "") , 
                  --imageFile = 
                 -- {
                  --    filename = "images/coronamarker.png",
                   --   baseDir = system.ResourcesDirectory
                  --},
                   listener=function(event) markerSelected(event, {id=row.params.id,rowindex = row.index})  end ,
                }
         myMap:addMarker( row.params.lat, row.params.lng, options )

     end
   end
   native.setActivityIndicator( false ) 
end



------------------------------------------------------
-- Called first time. May not be called again if we dont recyle
------------------------------------------------------
function scene:create(event)
 
    print ("Create  " .. currScene)
    justcreated = true
    local group = self.view
    sceneparams = event.params           -- params contains the item table  
     
    container  = common.SceneContainer()
    group:insert(container )

     ---------------------------------------------
     -- Header group
     -- text gets set in Show evvent
     ---------------------------------------------

     itemGrp = display.newGroup(  )
     local startX = 0
     local startY = 0 -myApp.cH/2 + myApp.locate.groupheight/2  + myApp.sceneStartTop

     local groupwidth = myApp.sceneWidth-myApp.locate.edge
     local dumText = display.newText( {text="X",font= myApp.fontBold, fontSize=myApp.locate.textfontsize})
     local textHeightSingleLine = dumText.height
     
     -------------------------------------------------
     -- Background
     -------------------------------------------------
     local myRoundedRect = display.newRoundedRect(startX, startY , groupwidth-myApp.locate.groupstrokewidth*2,myApp.locate.groupheight, myApp.locate.cornerradius )
     myRoundedRect:setFillColor(myApp.locate.groupbackground.r,myApp.locate.groupbackground.g,myApp.locate.groupbackground.b,myApp.locate.groupbackground.a )
     itemGrp:insert(myRoundedRect)

     local startYother = startY- myApp.locate.groupheight/2  

     -------------------------------------------------
     -- Desc text
     -------------------------------------------------
     myDesc = display.newText( {text="", x=startX , y=0, height=0,width=groupwidth-myApp.locate.edge*2 ,font= myApp.fontBold, fontSize=myApp.locate.textfontsize,align="center" })
     myDesc.y=myRoundedRect.y --startYother+myApp.locate.groupheight - (myDesc.height) -  myApp.locate.textbottomedge
     myDesc:setFillColor( myApp.locate.textcolor.r,myApp.locate.textcolor.g,myApp.locate.textcolor.b,myApp.locate.textcolor.a )
     itemGrp:insert(myDesc)

     container:insert(itemGrp)

    ------------------------------------------------------
    -- Table View
    ------------------------------------------------------
    myList = widget.newTableView {
           x=0,
           y= myApp.cH/2 -  myApp.locate.tableheight/2 - myApp.tabs.tabBarHeight-myApp.locate.edge, 
           width = myApp.sceneWidth-myApp.locate.edge, 
           height = myApp.locate.tableheight,
           onRowRender = onRowRender,
           onRowTouch = onRowTouch,
           listener = scrollListener,
        }
     container:insert(myList )

end

function scene:show( event )

    local group = self.view
    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)
    ----------------------------------
    -- Will Show
    ----------------------------------
    if ( phase == "will" ) then

        ----------------------------
        -- sceneparams at this point contains prior
        -- KEEP IT THAT WAY !!!!!
        --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ------------------------------
        -- Called when the scene is still off screen (but is about to come on screen).
        runit = true
        if sceneparams and justcreated == false then
          if  sceneparams.navigation.composer then
             if sceneid == event.params.navigation.composer.id then
               runit = false
             end
          end
        end
        if (runit or justcreated) then 
            myList:deleteAllRows()
            if myApp.locate.animation then
               curmyListy = myList.y
               myList.y = myList.y + myList.height
            end
        end
        ----------------------------
        -- now go ahead
        --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ------------------------------
        sceneparams = event.params           -- params contains the item table 
        sceneid = sceneparams.navigation.composer.id       --- new field otherwise it is a refernce and some calls here send a reference so comparing id's is useless         


        ---------------------------------------
        -- upodate the desc
        ---------------------------------------
        myDesc.text = sceneparams.locateinfo.desc

    ----------------------------------
    -- Did Show
    ----------------------------------
    elseif ( phase == "did" ) then
        parse:logEvent( "Scene", { ["name"] = currScene} )
        
        print(sceneparams.locateinfo.lat .." " .. sceneparams.locateinfo.lng  .. " " .. sceneparams.locateinfo.limit .. " " .. sceneparams.locateinfo.miles ) 

        if common.testNetworkConnection()  then

           -----------------------------------
           -- always do the map even if criteria is same since it gets destrpyed every scene change
           ------------------------------------
           native.setActivityIndicator( true )

           local mapheight = myApp.sceneHeight-myList.height-itemGrp.height-myApp.locate.edge*2
           myMap = native.newMapView( 0, 0, myApp.sceneWidth-myApp.locate.edge , mapheight  ) 
           if myMap then
             myMap.mapType = myApp.locate.map.type -- other mapType options are "satellite" or "hybrid"

            -- The MapView is just another Corona display object, and can be moved or rotated, etc.
             myMap.x = myApp.cCx
             myMap.y = myApp.sceneStartTop + itemGrp.height  + myApp.locate.edge+ mapheight/2 + myApp.locate.edge/2

             myMap:setCenter( sceneparams.locateinfo.lat, sceneparams.locateinfo.lng, false )
             myMap:setRegion( sceneparams.locateinfo.lat, sceneparams.locateinfo.lng, myApp.locate.map.latitudespan, myApp.locate.map.longitudespan, false)
           end
           if (runit or justcreated) then
               parse:run(sceneparams.locateinfo.functionname,
                  {
                   ["lat"] = sceneparams.locateinfo.lat , 
                   ["lng"] = sceneparams.locateinfo.lng ,
                   ["limit"] = sceneparams.locateinfo.limit, 
                   ["miles"] = sceneparams.locateinfo.miles
                   },
                   ------------------------------------------------------------
                   -- Callback inline function
                   ------------------------------------------------------------
                   function(e) 
                      print ("Back from search " .. (e.response.error or "" ))
                      if (e.response.error or "" ) == "" then  
                         
                          if myApp.locate.animation then
                             transition.to(  myList, { time=myApp.locate.animationtime, y = curmyListy , transition=easing.outQuint})
                          end
                          for i = 1, #e.response.result do
                              local resgroup = e.response.result[i]
                              --print("NAME" .. resgroup[sceneparams.locateinfo.mapping.name])
 
                             myList:insertRow{
                                rowHeight = myApp.locate.row.height,
                                isCategory = false,
                                rowColor = myApp.locate.row.rowColor,
                                lineColor = myApp.locate.row.lineColor,

                                params = {
                                             objectId = resgroup.objectId,
                                             id = resgroup[sceneparams.locateinfo.mapping.id],
                                             name = resgroup[sceneparams.locateinfo.mapping.name],
                                             miles = resgroup[sceneparams.locateinfo.mapping.miles],
                                             lat = resgroup[sceneparams.locateinfo.mapping.geo].latitude,
                                             lng = resgroup[sceneparams.locateinfo.mapping.geo].longitude,
                                             street = resgroup[sceneparams.locateinfo.mapping.street],                           
                                             city = resgroup[sceneparams.locateinfo.mapping.city],
                                             state = resgroup[sceneparams.locateinfo.mapping.state],
                                             zip = resgroup[sceneparams.locateinfo.mapping.zip],
                                             address = (resgroup[sceneparams.locateinfo.mapping.street] or "") .. "\n" .. (resgroup[sceneparams.locateinfo.mapping.city] or "") .. ", " .. (resgroup[sceneparams.locateinfo.mapping.state] or "") .. " " .. (resgroup[sceneparams.locateinfo.mapping.zip] or "") 

                                          }  -- params
                                }   --myList:insertRow

                          end

                          native.setActivityIndicator( false ) 
                          if #e.response.result > 0 then 
                            myList:scrollToIndex( 1 ) 
                            buildMap()   -- always need to do
                          end
                      else
                        native.setActivityIndicator( false ) 
                         print ("Back from search with erropr " .. e.response.error)
                       --buildMap()     no need to do. Nothing to mark
                      end  -- end of error check
                  end )  -- end of parse call
            else
              native.setActivityIndicator( false ) 
              buildMap()   -- always need to do
            end  -- end of runit or justcreated
        end    -- end of network connection check
        justcreated = false

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
        if myMap and myMap.removeSelf then
          myMap:removeSelf()
          myMap = nil
        end
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
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
--
-- must slide away so overlay scene can perform
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
     --    transition.to(  myMap, {  time=parms.time/2,delta=true, x =  slidex * slidextype })
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