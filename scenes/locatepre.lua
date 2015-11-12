---------------------------------------------------------------------------------------
-- locateagent scene
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
local addressField
local itemGrp
local curlocButton
local addressButton

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
             -- Called when the scene is still off screen (but is about to come on screen).
             display.remove( container )           -- wont exist initially no biggie
             container = nil

             container  = common.SceneContainer()
             group:insert(container )

             ---------------------------------------------
             -- lets create the group
             ---------------------------------------------

             itemGrp = display.newGroup(  )
             local headcolor = sceneparams.groupheader or myApp.locatepre.groupheader
             local startX = 0
             local startY = 0 -myApp.cH/2 + myApp.locatepre.groupheight/2 + myApp.locatepre.edge*2 + myApp.sceneStartTop
             local groupwidth = myApp.sceneWidth-myApp.locatepre.edge*2
             local dumText = display.newText( {text="X",font= myApp.fontBold, fontSize=myApp.locatepre.textfontsize})
             local textHeightSingleLine = dumText.height
             
             -------------------------------------------------
             -- Background
             -------------------------------------------------
             local myRoundedRect = display.newRoundedRect(startX, startY , groupwidth-myApp.locatepre.groupstrokewidth*2,myApp.locatepre.groupheight, 1)
             myRoundedRect:setFillColor(myApp.locatepre.groupbackground.r,myApp.locatepre.groupbackground.g,myApp.locatepre.groupbackground.b,myApp.locatepre.groupbackground.a )
             myRoundedRect.strokeWidth = myApp.locatepre.groupstrokewidth
             myRoundedRect:setStrokeColor( headcolor.r,headcolor.g,headcolor.b ) 
             itemGrp:insert(myRoundedRect)

             -------------------------------------------------
             -- Header Background
             -------------------------------------------------
             local startYother = startY- myApp.locatepre.groupheight/2  
             local myRoundedTop = display.newRoundedRect(startX, startYother ,groupwidth, myApp.locatepre.groupheaderheight, 1 )
             myRoundedTop:setFillColor(headcolor.r,headcolor.g,headcolor.b,headcolor.a )
             itemGrp:insert(myRoundedTop)
             
             -------------------------------------------------
             -- Header text
             -------------------------------------------------
             local myText = display.newText( sceneparams.title, startX, startYother,  myApp.fontBold, myApp.locatepre.headerfontsize )
             myText:setFillColor( myApp.locatepre.headercolor.r,myApp.locatepre.headercolor.g,myApp.locatepre.headercolor.b,myApp.locatepre.headercolor.a )
             itemGrp:insert(myText)

             -------------------------------------------------
             -- Icon ?
             -------------------------------------------------
             if sceneparams.pic then
                 local myIcon = display.newImageRect(myApp.imgfld .. sceneparams.pic, sceneparams.originaliconwidth or myApp.locatepre.iconwidth ,sceneparams.originaliconheight or myApp.locatepre.iconheight )
                 common.fitImage( myIcon, sceneparams.iconwidth or myApp.locatepre.iconwidth   )
                 myIcon.x = startX
                 myIcon.y = startYother + itemGrp.height/2 - 20
                 itemGrp:insert(myIcon)
             end

             -------------------------------------------------
             -- Desc text
             -------------------------------------------------
             local myDesc = display.newText( {text=sceneparams.text, x=startX , y=0, height=0,width=groupwidth-myApp.locatepre.edge*2 ,font= myApp.fontBold, fontSize=myApp.locatepre.textfontsize,align="center" })
             myDesc.y=startYother+myApp.locatepre.groupheight - (myDesc.height/2) -  myApp.locatepre.textbottomedge
             myDesc:setFillColor( myApp.locatepre.textcolor.r,myApp.locatepre.textcolor.g,myApp.locatepre.textcolor.b,myApp.locatepre.textcolor.a )
             itemGrp:insert(myDesc)

             container:insert(itemGrp)

             -------------------------------------------------
             -- Range text
             -------------------------------------------------
             local myRangetext = display.newText( {text="Range",font= myApp.fontBold, fontSize=myApp.locatepre.textfontsize,align="left" })
             myRangetext.x = myApp.cW/2*-1 + myRangetext.width/2 + myApp.locatepre.edge  + 2
             myRangetext.y=startYother+myApp.locatepre.groupheight  + myApp.locatepre.edge* 2
             myRangetext:setFillColor( myApp.locatepre.textcolor.r,myApp.locatepre.textcolor.g,myApp.locatepre.textcolor.b,myApp.locatepre.textcolor.a )
             container:insert(myRangetext)

             -------------------------------------------------
             -- Miles text
             -------------------------------------------------
             local myMilestext = display.newText( {text="xxx Miles",font= myApp.fontBold, fontSize=myApp.locatepre.textfontsize,align="right" })
             myMilestext.x = myApp.cW/2 - myMilestext.width/2 - myApp.locatepre.edge  - 2
             myMilestext.y=startYother+myApp.locatepre.groupheight  + myApp.locatepre.edge* 2
             myMilestext:setFillColor( myApp.locatepre.textcolor.r,myApp.locatepre.textcolor.g,myApp.locatepre.textcolor.b,myApp.locatepre.textcolor.a )
             container:insert(myMilestext)

            local function milesCheck()
                if sceneparams.sceneinfo.locateinfo.miles > myApp.locatepre.milerange.high then
                    sceneparams.sceneinfo.locateinfo.miles = myApp.locatepre.milerange.high
                else
                    if sceneparams.sceneinfo.locateinfo.miles < myApp.locatepre.milerange.low then
                        sceneparams.sceneinfo.locateinfo.miles = myApp.locatepre.milerange.low
                    end
                end
            end
            milesCheck()

            --------------------------------------------
            -- Create a horizontal slider
            -- slider value is 0-100 so we have to caluclate based on min and max range
            ---------------------------------------------
            local horizontalSlider = widget.newSlider {
                x = itemGrp.x - myApp.locatepre.edge,
                y = myRangetext.y + 3,
                width = itemGrp.width - myRangetext.width - myMilestext.width - myApp.locatepre.edge*5,
                id = "miles",
                orientation = "horizontal",
                value = (sceneparams.sceneinfo.locateinfo.miles-myApp.locatepre.milerange.low)  / myApp.locatepre.milerange.high * 100,
                listener = function(event) 
                             sceneparams.sceneinfo.locateinfo.miles = ((event.value/100) * myApp.locatepre.milerange.high) +  myApp.locatepre.milerange.low 
                             milesCheck()
                             myMilestext.text = sceneparams.sceneinfo.locateinfo.miles .. " Miles"
                          end,
            }
            myMilestext.text = sceneparams.sceneinfo.locateinfo.miles .. " Miles"
            container:insert( horizontalSlider )

             -------------------------------------------------
             -- Current loc button pressed return
             -------------------------------------------------

             local function launchLocateScene(inputparms) 
                      local locatelaunch = {  
                                         title = myApp.mappings.objects[sceneparams.sceneinfo.locateinfo.object].desc.plural , --sceneparams.title, 
                                         pic=sceneparams.pic,
                                         originaliconwidth = sceneparams.originaliconwidth,
                                         originaliconheight = sceneparams.originaliconheight,
                                         iconwidth = sceneparams.iconwidth,      -- height will be scaled appropriately
                                         text=sceneparams.text,
                                         backtext = sceneparams.backtext,
 
                                         locateinfo = {
                                                        desc = inputparms.desc,
                                                        functionname=myApp.mappings.objects[sceneparams.sceneinfo.locateinfo.object].functionname.locate,
                                                        limit=sceneparams.sceneinfo.locateinfo.limit,
                                                        miles=sceneparams.sceneinfo.locateinfo.miles,
                                                        object=sceneparams.sceneinfo.locateinfo.object,
                                                        lat = inputparms.lat,
                                                        lng = inputparms.lng,
                                                        mapping= myApp.mappings.objects[sceneparams.sceneinfo.locateinfo.object].mapping,
                                                      },
                                         navigation = { 
                                               composer = {
                                                              -- this id setting this way we will rerun if different than prior request either miles or lat.lng etc...
                                                             id = sceneparams.sceneinfo.locateinfo.object.."-" ..sceneparams.sceneinfo.locateinfo.miles.."-" .. sceneparams.sceneinfo.locateinfo.limit .."-".. inputparms.lat .."-".. inputparms.lng,   
                                                             lua=myApp.locatepre.lua ,
                                                             time=sceneparams.navigation.composer.time, 
                                                             effect=myApp.locatepre.effect,
                                                             effectback=myApp.locatepre.effectback,
                                                          },
                                                     },
                                 }      

                         local parentinfo =  sceneparams 
                         locatelaunch.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
                         myApp.showSubScreen ({instructions=locatelaunch})

             end


             local function curlocReleaseback() 
                  ------------------------------------------------------
                  -- have accurate location ?
                  ------------------------------------------------------
                  if myApp.gps.haveaccuratelocation == true then
                       launchLocateScene{desc=string.format (myApp.mappings.objects[sceneparams.sceneinfo.locateinfo.object].desc.plural ..  " within %i miles of your current location.",sceneparams.sceneinfo.locateinfo.miles), lat=myApp.gps.currentlocation.latitude,lng=myApp.gps.currentlocation.longitude}
                  end

             end


             local function addressReleaseback(event) 
                   ------------------------------------------------------
                  -- have accurate location ?
                  ------------------------------------------------------
                  if ( event.isError ) then
                  else
                       if event.latitude then
                          launchLocateScene{desc=string.format (myApp.mappings.objects[sceneparams.sceneinfo.locateinfo.object].desc.plural  ..  " within %i miles of %s.",sceneparams.sceneinfo.locateinfo.miles,addressField.textField.text),lat=event.latitude,lng=event.longitude}
                       end
                  end
              end  


             ---------------------------------------------
             -- Use Current Location button
             ---------------------------------------------
              curlocButton = widget.newButton {
                    shape=myApp.locatepre.shape,
                    fillColor = { default={ headcolor.r, headcolor.g, headcolor.b, myApp.locatepre.btndefaultcoloralpha}, over={ headcolor.r, headcolor.g, headcolor.b, myApp.locatepre.btnovercoloralpha } },
                    label = myApp.locatepre.curlocbtntext,
                    labelColor = { default={ myApp.locatepre.headercolor.r,myApp.locatepre.headercolor.g,myApp.locatepre.headercolor.b }, over={ myApp.locatepre.headercolor.r,myApp.locatepre.headercolor.g,myApp.locatepre.headercolor.b, .75 } },
                    fontSize = myApp.locatepre.headerfontsize,
                    font = myApp.fontBold,
                    width = itemGrp.width,
                    height = myApp.locatepre.btnheight,
                    x = itemGrp.x,
                    y = startY +  itemGrp.height /2 + myApp.locatepre.btnheight /2 + horizontalSlider.height,
                    onRelease = function() 
                                    myApp.getCurrentLocation({callback=curlocReleaseback}) 
                                end,
                  }
               container:insert(curlocButton)


              
             ---------------------------------------------
             -- Use location entered button
             ---------------------------------------------
              addressButton = widget.newButton {
                    shape=myApp.locatepre.shape,
                    fillColor = { default={ headcolor.r, headcolor.g, headcolor.b, myApp.locatepre.btndefaultcoloralpha }, over={ headcolor.r, headcolor.g, headcolor.b, myApp.locatepre.btnovercoloralpha } },
                    label = myApp.locatepre.addressbtntext,
                    labelColor = { default={ myApp.locatepre.headercolor.r,myApp.locatepre.headercolor.g,myApp.locatepre.headercolor.b }, over={ myApp.locatepre.headercolor.r,myApp.locatepre.headercolor.g,myApp.locatepre.headercolor.b, .75 } },
                    fontSize = myApp.locatepre.headerfontsize,
                    font = myApp.fontBold,
                    width = itemGrp.width,
                    height = myApp.locatepre.btnheight,
                    x = itemGrp.x,
                    y = curlocButton.y +  myApp.locatepre.btnheight  + myApp.locatepre.edge,
                    onRelease = function() 
                                      local inputtext = addressField.textField.text or ""
                                      if inputtext == "" then
                                         native.showAlert( myApp.locatepre.addresslocate.errortitle, myApp.locatepre.addresslocate.errormessage, { "Okay" } )
                                      else
                                         myApp.getAddressLocation({address=addressField.textField.text,callback=addressReleaseback}) 
                                      end
                                end,
                  }
               container:insert(addressButton)
 
--print ("fist time ".. container.y .. " " .. curlocButton.y .. " " .. showdidstarty .." " .. startY .. " " .. itemGrp.height /2  .. " " .. myApp.locatepre.btnheight /2 .. " " ..horizontalSlider.height)


        --myApp.sceneWidth / 2 ,myApp.sceneHeight  /2 + myApp.sceneStartTop


                -- local debuglink = common.DeepCopy({
                --                      title = "Dbug Info", 
                --                      backtext = "<",
                --                      groupheader = { r=53/255, g=48/255, b=102/255, a=1 },
                --                      composer = {
                --                                  lua="debugapp",
                --                                  time=250, 
                --                                  effect="slideLeft",
                --                                  effectback="slideRight",
                --                               },
                --                          })

                -- local parentinfo = common.DeepCopy(params)


               --          local debuglink = {
               --                       title = "Dbug Info", 
               --                       backtext = "<",
               --                       groupheader = { r=53/255, g=48/255, b=102/255, a=1 },
               --                       navigation = { composer = {
               --                                   lua="debugapp",
               --                                   time=250, 
               --                                   effect="slideLeft",
               --                                   effectback="slideRight",
               --                                },
               --                              },
               --                           } 

               --  local parentinfo =  params 
               --  debuglink.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
               --  local debugbackButton = widget.newButton {
               --      label = "Debug Link" ,
               --      labelColor = { default={ 0, 1, 1 }, over={ 0, 0, 0, 0.5 } },
               --      fontSize = 30,
               --      font = myApp.fontBold,
               --      onRelease = function () myApp.showSubScreen ({instructions=debuglink}) end,
               --   }
               -- debugbackButton.y = 150
               -- container:insert(debugbackButton)


    elseif ( phase == "did" ) then
        parse:logEvent( "Scene", { ["name"] = currScene} )
        --sceneparams = event.params           -- params contains the item table 
            local function textFieldHandler( event )
                --
                -- event.text only exists during the editing phase to show what's being edited.  
                -- It is **NOT** the field's .text attribute.  That is event.target.text
                --
                if event.phase == "began" then

                    -- user begins editing textField
                    print( "Begin editing", event.target.text )

                elseif event.phase == "ended" or event.phase == "submitted" then

                    -- do something with defaulField's text
                    print( "Final Text: ", event.target.text)
                    native.setKeyboardFocus( nil )

                elseif event.phase == "editing" then

                    print( event.newCharacters )
                    print( event.oldText )
                    print( event.startPosition )
                    print( event.text )

                end
            end
            addressField = widget.newTextField({
                width = itemGrp.width,
                height = myApp.locatepre.addressfieldheight,
                cornerRadius = myApp.locatepre.addressfieldcornerradius,
                strokeWidth = 0,
                text = sceneparams.address,
                fontSize = myApp.locatepre.addresstextfontsize,
                placeholder = myApp.locatepre.addressfieldplaceholder,
                font = myApp.fontBold,
                labelWidth = 0,
                --labelFont = "HelveticaNeue",
                --labelFontSize = 14,
                --labelWidth = 60,
                listener = textFieldHandler,
                --label = "Location"
            })
            -- Hide the native part of this until we need to show it on the screen.

            addressField.x = myApp.cW/2  
            addressField.y = addressButton.y + addressButton.height + myApp.locatepre.edge*2 + container.y
     
            group:insert(addressField)      -- insertng into container messes up

    end
	

end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        sceneparams.address=addressField.textField.text
        addressField:removeSelf()
        addressField = nil
        native.setKeyboardFocus( nil )
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
     transition.to(  addressField, {  time=parms.time,delta=true, x = parms.x , transition=parms.transition})
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene