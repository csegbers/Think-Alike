---------------------------------------------------------------------------------------
-- Login Overlay scene
---------------------------------------------------------------------------------------
local myApp = require( "myapp" ) 

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local widgetExtras = require( myApp.utilsfld .. "widget-extras" )

local parse = require( myApp.utilsfld .. "mod_parse" ) 

local common = require( myApp.utilsfld .. "common" )

local currScene = "policyadd"      --- cant use composer current scene since this is overlay
print ("Inxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " .. currScene .. " Scene")

local sceneparams
local container

local cancelButton
local addButton

local policyField
local zipField
local secField

local txtPolicyLabel
local txtZipLabel
local txtSecLabel

local btnpushed = true


------------------------------------------------------
-- Called first time. May not be called again if we dont recyle
--
-- self.view -> Container -> SCrollvew
------------------------------------------------------
function scene:create(event)
    print ("Create  " .. currScene)

end

function scene:show( event )

    local group = self.view
    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)
    sceneparams = event.params   or {}         -- params contains the item table 
    local sceneinfo = sceneparams.sceneinfo -- myApp.otherscenes.login.sceneinfo

    -----------------------------
    -- call incase the parent needs to do any action
    ------------------------------
    pcall(function() event.parent:overlay({type="show",phase = phase,time=sceneparams.navigation.composer.time } ) end)
 

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).

            display.remove( container )           -- wont exist initially no biggie
            container = nil
            
            container = display.newContainer(myApp.sceneWidth-sceneinfo.edge*2,sceneinfo.height)
            container.y = myApp.sceneStartTop + container.height / 2 + sceneinfo.edge
            container.x = myApp.cW / 2


            local background = display.newRoundedRect(0, 0 ,container.width -sceneinfo.edge/2,container.height -sceneinfo.edge/2 , sceneinfo.cornerradius)
            background.strokeWidth = sceneinfo.strokewidth
            background:setStrokeColor( sceneinfo.strokecolor.r,sceneinfo.strokecolor.g,sceneinfo.strokecolor.b,sceneinfo.strokecolor.a )
            background:setFillColor(sceneinfo.groupbackground.r,sceneinfo.groupbackground.g,sceneinfo.groupbackground.b,sceneinfo.groupbackground.a)


            container:insert(background)

             -------------------------------------------------
             -- policy number  text
             -------------------------------------------------
             txtPolicyLabel = display.newText({text=sceneinfo.policylabel, font= myApp.fontBold, fontSize=sceneinfo.textfontsize,align="left" })
             txtPolicyLabel:setFillColor( sceneinfo.textcolor.r,sceneinfo.textcolor.g,sceneinfo.textcolor.b,sceneinfo.textcolor.a )
             txtPolicyLabel.anchorX = 0
             txtPolicyLabel.anchorY = 0
             txtPolicyLabel.x = background.x - background.width/2 + sceneinfo.edge/2
             txtPolicyLabel.y = background.y - background.height/2 + sceneinfo.edge/2
             
             container:insert(txtPolicyLabel)

 
             -------------------------------------------------
             -- pwd text
             -------------------------------------------------
             txtZipLabel = display.newText({text=sceneinfo.ziplabel, font= myApp.fontBold, fontSize=sceneinfo.textfontsize,align="left" })
             txtZipLabel:setFillColor( sceneinfo.textcolor.r,sceneinfo.textcolor.g,sceneinfo.textcolor.b,sceneinfo.textcolor.a )
             txtZipLabel.anchorX = 0
             txtZipLabel.anchorY = 0
             txtZipLabel.x = background.x - background.width/2 + sceneinfo.edge/2
             txtZipLabel.y = txtPolicyLabel.y + txtPolicyLabel.height + sceneinfo.policyfieldheight + sceneinfo.edge
             
             container:insert(txtZipLabel)

 
             -------------------------------------------------
             -- security text
             -------------------------------------------------
             txtSecLabel = display.newText({text=sceneinfo.seclabel, font= myApp.fontBold, fontSize=sceneinfo.textfontsize,align="left" })
             txtSecLabel:setFillColor( sceneinfo.textcolor.r,sceneinfo.textcolor.g,sceneinfo.textcolor.b,sceneinfo.textcolor.a )
             txtSecLabel.anchorX = 0
             txtSecLabel.anchorY = 0
             txtSecLabel.x = background.x - background.width/2 + sceneinfo.edge/2
             txtSecLabel.y = txtZipLabel.y + txtZipLabel.height + sceneinfo.zipfieldheight + sceneinfo.edge
             
             container:insert(txtSecLabel)


             ---------------------------------------------
             -- Cancel button
             ---------------------------------------------
             cancelButton = widget.newButton {
                    shape=sceneinfo.btnshape,
                    fillColor = { default={ sceneinfo.btncanceldefcolor.r,  sceneinfo.btncanceldefcolor.g, sceneinfo.btncanceldefcolor.b, sceneinfo.btncanceldefcolor.a}, over={ sceneinfo.btncancelovcolor.r, sceneinfo.btncancelovcolor.g, sceneinfo.btncancelovcolor.b, sceneinfo.btncancelovcolor.a } },
                    label = sceneinfo.btncanceltext,
                    labelColor = { default={ sceneinfo.btncanceldeflabelcolor.r,  sceneinfo.btncanceldeflabelcolor.g, sceneinfo.btncanceldeflabelcolor.b, sceneinfo.btncanceldeflabelcolor.a}, over={ sceneinfo.btncancelovlabelcolor.r, sceneinfo.btncancelovlabelcolor.g, sceneinfo.btncancelovlabelcolor.b, sceneinfo.btncancelovlabelcolor.a } },
                    fontSize = sceneinfo.btnfontsize,
                    font = myApp.fontBold,
                    width = sceneinfo.btnwidth,
                    height = sceneinfo.btnheight,
                    ---------------------------------
                    -- stick inside a time to prevent the buton press from passing thru to the current scene
                    ---------------------------------
                    onRelease = function() 
                                   if btnpushed == false then
                                      btnpushed = true 
                                      timer.performWithDelay(10,function () myApp.hideOverlay({callback=nill}) end)  
                                      return true
                                   end
                                end,

                  }
               cancelButton.anchorX = 0
               cancelButton.anchorY = 0
               cancelButton.x = txtPolicyLabel.x  
               cancelButton.y = background.y + background.height/2 - sceneinfo.btnheight - sceneinfo.edge/2   -- background uses .5 anchor
               --debugpopup (background.y .. " " .. background.height)
               container:insert(cancelButton)


             ---------------------------------------------
             -- Login button
             ---------------------------------------------
             addButton = widget.newButton {
                    shape=sceneinfo.btnshape,
                    fillColor = { default={ sceneinfo.btnadddefcolor.r,  sceneinfo.btnadddefcolor.g, sceneinfo.btnadddefcolor.b, sceneinfo.btnadddefcolor.a}, over={ sceneinfo.btnaddovcolor.r, sceneinfo.btnaddovcolor.g, sceneinfo.btnaddovcolor.b, sceneinfo.btnaddovcolor.a } },
                    label = sceneinfo.btnaddtext,
                    labelColor = { default={ sceneinfo.btnadddeflabelcolor.r,  sceneinfo.btnadddeflabelcolor.g, sceneinfo.btnadddeflabelcolor.b, sceneinfo.btnadddeflabelcolor.a}, over={ sceneinfo.btnaddovlabelcolor.r, sceneinfo.btnaddovlabelcolor.g, sceneinfo.btnaddovlabelcolor.b, sceneinfo.btnaddovlabelcolor.a } },
                    fontSize = sceneinfo.btnfontsize,
                    font = myApp.fontBold,
                    width = sceneinfo.btnwidth,
                    height = sceneinfo.btnheight,
                    ---------------------------------
                    -- stick inside a time to prevent the buton press from passing thru to the current scene
                    ---------------------------------
                    onRelease = function() 
                                        if btnpushed == false then
                                            btnpushed = true 
                                            local inputpolicy = policyField.textField.text or ""
                                            local inputzip = zipField.textField.text or ""
                                            local inputsec = secField.textField.text or ""
                                            if (myApp.authentication.objectId or "") == "" or (myApp.authentication.loggedin or false ) == false then
                                                native.showAlert( sceneinfo.btnaddmessage.errortitleuser, sceneinfo.btnaddmessage.errormessageuser, { "Okay" } ,function() btnpushed = false  end )
                                            else
                                                if inputpolicy == "" or inputzip == "" or inputsec == "" then
                                                   native.showAlert( sceneinfo.btnaddmessage.errortitle, sceneinfo.btnaddmessage.errormessage, { "Okay" } ,function() btnpushed = false  end )
                                                else
                                                    native.setActivityIndicator( true )
                                                    local userDataTable = { ["userId"] = myApp.authentication.objectId , ["policyNumber"] = inputpolicy, ["policyPostalCode"] = inputzip , ["policyObjectId"] = inputsec }
                                                    parse:run(        myApp.otherscenes.policyadd.functionname.addpolicy,
                                                                      userDataTable,  
                                                                      function(event)
                                                                           native.setActivityIndicator( false )
                                                                           if (event.response.error or "" ) == "" then                                                         
                                                                                timer.performWithDelay(10,
                                                                                              function () 
                                                                                                  myApp.hideOverlay({callback=nill}) 
                                                                                                  timer.performWithDelay(10,function () myApp.fncUserUpdatePolicies()  end) 
                                                                                              end
                                                                                              ) 
                                                                           else
                                                                              native.showAlert( sceneinfo.btnaddmessage.failuretitle, event.response.error, { "Okay" },function() btnpushed = false  end  )
                                                                           end
                                                                      end    --- return function from parse
                                                                     )   -- end of parse
                                                 end -- end of checking for valid input
                                             end -- end of myApp.authentication.objectId  check
                                      end -- end of btnpush check
                                 end,    -- end onrelease
                  }
               addButton.anchorX = 0
               addButton.anchorY = 0
               addButton.x = background.x + background.width/2  - sceneinfo.btnwidth - sceneinfo.edge/2 
               addButton.y = background.y + background.height/2 - sceneinfo.btnheight - sceneinfo.edge/2   -- background uses .5 anchor
               --debugpopup (background.y .. " " .. background.height)
               container:insert(addButton)

               group:insert(container)




    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.


              -------------------------------------------------
             -- userid field
             -------------------------------------------------
            policyField = widget.newTextField({
                width = container.width - sceneinfo.edge*2,
                height = sceneinfo.policyfieldheight,
                cornerRadius = sceneinfo.policyfieldcornerradius,
                strokeWidth = 0,
                fontSize = sceneinfo.policyfieldfontsize,
                placeholder = sceneinfo.policyfieldplaceholder,
                font = myApp.fontBold,
                labelWidth = 0,
                inputType = "default",
                listener = function()     if ( "began" == event.phase ) then
                                          elseif ( "submitted" == event.phase ) then
                                             native.setKeyboardFocus( zipField )
                                          end 
                            end,
                        })
            -- Hide the native part of this until we need to show it on the screen.
            
         --   local lbX, lbY = txtPolicyLabel:localToContent( txtPolicyLabel.width/2-sceneinfo.edge/2, 0 )
            local lbX, lbY = txtPolicyLabel:localToContent( 0 , 0 )     -- get center points relative to device
            policyField.x = lbX - txtPolicyLabel.width/2 + policyField.width / 2 
            policyField.y = lbY + sceneinfo.policyfieldheight
     
            group:insert(policyField)      -- insertng into container messes up


              -------------------------------------------------
             -- userid field
             -------------------------------------------------
            zipField = widget.newTextField({
                
                width = container.width - sceneinfo.edge*2 ,
                height = sceneinfo.zipfieldheight,
                cornerRadius = sceneinfo.zipfieldcornerradius,
                strokeWidth = 0,
                text = "",
                fontSize = sceneinfo.zipfieldfontsize,
                placeholder = sceneinfo.zipfieldplaceholder,
                font = myApp.fontBold,
                labelWidth = 0,
                isSecure = false,    -- note a border shows up... cannot get rid of when issecure
                listener = function()     if ( "began" == event.phase ) then
                                          elseif ( "submitted" == event.phase ) then
                                             native.setKeyboardFocus( secField )
                                          end 
                            end,
            })
            -- Hide the native part of this until we need to show it on the screen.
            
            lbX, lbY = txtZipLabel:localToContent( 0,0 )
            zipField.x = lbX - txtZipLabel.width/2 + zipField.width / 2
            zipField.y = lbY + sceneinfo.zipfieldheight

            group:insert(zipField)      -- insertng into container messes up


              -------------------------------------------------
             -- userid field
             -------------------------------------------------
            secField = widget.newTextField({
                
                width = container.width - sceneinfo.edge*2 ,
                height = sceneinfo.secfieldheight,
                cornerRadius = sceneinfo.secfieldcornerradius,
                strokeWidth = 0,
                text = "",
                fontSize = sceneinfo.secfieldfontsize,
                placeholder = sceneinfo.secfieldplaceholder,
                font = myApp.fontBold,
                labelWidth = 0,
                isSecure = false,    -- note a border shows up... cannot get rid of when issecure
                listener = function()   if ( "submitted" == event.phase ) then native.setKeyboardFocus( nil )end end,
            })
            -- Hide the native part of this until we need to show it on the screen.
            
            lbX, lbY = txtSecLabel:localToContent( 0,0 )
            secField.x = lbX - txtSecLabel.width/2 + secField.width / 2
            secField.y = lbY + sceneinfo.secfieldheight

            group:insert(secField)      -- insertng into container messes up


            native.setKeyboardFocus( policyField )

            btnpushed = false

 
    end
	
 
end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    -----------------------------
    -- call incase the parent needs to do any action
    ------------------------------
    pcall(function() event.parent:overlay({type="hide",phase = phase,time=sceneparams.navigation.composer.time } ) end)
    if ( phase == "will" ) then
        policyField:removeSelf()
        policyField = nil

        zipField:removeSelf()
        zipField = nil

        secField:removeSelf()
        secField = nil

        native.setKeyboardFocus( nil )
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
-- use if someone wants us to transition away
-- for navigational appearnaces
-- used from the more button
---------------------------------------------------
function scene:morebutton( parms )
     transition.to(  policyField, {  time=parms.time,delta=true, x = parms.x , transition=parms.transition})
     transition.to(  zipField,  {  time=parms.time,delta=true, x = parms.x , transition=parms.transition})
     transition.to(  secField,  {  time=parms.time,delta=true, x = parms.x , transition=parms.transition})

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene