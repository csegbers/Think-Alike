---------------------------------------------------------------------------------------
-- account scene
---------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myApp = require( "myapp" ) 
local parse = require( myApp.utilsfld .. "mod_parse" )  
local common = require( myApp.utilsfld .. "common" )
local login = require( myApp.classfld .. "classlogin" )

local currScene = (composer.getSceneName( "current" ) or "unknown")
local sceneparams
local sceneid
local sbi
local container
local scrollView
local justcreated  
local runit  
 
------------------------------------------------------
-- Called first time. May not be called again if we dont recyle
--
-- self.view -> Container -> SCrollvew -> primgroup -> individual item groups
------------------------------------------------------
function scene:create(event)
     print ("Create  " .. currScene)
     justcreated = true
     sceneparams = event.params or {}
end

function scene:show( event )

    local group = self.view
    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)
    sbi = myApp.otherscenes.myaccount 

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).


        ----------------------------
        -- sceneparams at this point contains prior
        -- KEEP IT THAT WAY !!!!!
        --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ------------------------------
        -- Called when the scene is still off screen (but is about to come on screen).
        runit = true
        if sceneparams and justcreated == false then
          print ("scene compare " .. sceneparams.navigation.composer.id .. " " .. event.params.navigation.composer.id )
          if  sceneparams.navigation.composer then
             if sceneid == event.params.navigation.composer.id then
               runit = false
             end
          end
        end

        --------------------
        -- update sceneparams now, not before as we check prior scene
        --------------------
        sceneparams = event.params or {}
        sceneid = sceneparams.navigation.composer.id       --- new field otherwise it is a refernce and some calls here send a reference so comparing id's is useless         

        
       --debugpopup (sceneparams.sceneinfo.scrollblockinfo.navigate)

        if (runit or justcreated) then 

            display.remove( container )           -- wont exist initially no biggie
            container = nil

            display.remove( scrollView )           -- wont exist initially no biggie
            scrollView = nil

            container = common.SceneContainer()
            group:insert(container)
         
            local function scrollListener( event )
                  return true
            end

            scrollView = widget.newScrollView
                {
                    x = 0,
                    y = 0 - sbi.btnheight/2 - sbi.groupbetween/2,
                    width = myApp.sceneWidth, 
                    height =  myApp.sceneHeight - sbi.btnheight - sbi.groupbetween,
                    listener = scrollListener,
                    horizontalScrollDisabled = true,
                    hideBackground = true,
                }
             container:insert(scrollView)

             ----------------------------------------------
             -- Tcouhed an object - go do something
             ----------------------------------------------
             local function onObjectTouch( event )
             
                local rowitem = event.target.id
            --    local homepageitem = sbi.items[event.target.id] 
                -------------------------------------------
                -- launch another scene ?
                -- Pass in our scene info for the new scene callback
                -------------------------------------------
                local function onObjectTouchAction(  )
                      local policysceneinfo = myApp.otherscenes.policydetails
                      --debugpopup (rowitem)
                      -------------------------------------------------
                      -- policy object pressed return
                      -------------------------------------------------  

                      local policylaunch = {  
                                 title = event.target.title , --rowitem, --sceneparams.title, 
                                 backtext = policysceneinfo.backtext,
                                 policynumber = rowitem,
                                 navigation = { 
                                       composer = {
                                                      -- this id setting this way we will rerun if different than prior request ...
                                                      -- we include this scene id plus the row id which is policy number for account
                                                      -- the reason is if they log out / in this sceene id is random thus we make sure we start fresh
                                                     id = sceneid .. rowitem,  
                                                     lua=policysceneinfo.navigation.composer.lua ,
                                                     time=policysceneinfo.navigation.composer.time, 
                                                     effect=policysceneinfo.navigation.composer.effect,
                                                     effectback=policysceneinfo.navigation.composer.effectback,
                                                  },
                                             },
                                 }      

                         local parentinfo =  sceneparams 
                         -----------------------------------------
                         -- are being used as a main tabbar scene ?
                         -----------------------------------------
                         if myApp.MainSceneNavidate(parentinfo) then
                           myApp.navigationCommon(policylaunch)
                         else
                            policylaunch.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
                            myApp.showSubScreen ({instructions=policylaunch})
                         end

                end       
                ---------------------------------------------
                -- simulate a pressing of a button
                ---------------------------------------------
                transition.to( event.target, { time=100, x=5,y=5,  delta=true , transition=easing.continuousLoop, onComplete=onObjectTouchAction } )  
             end

             local groupheight = sbi.groupheight
             local groupwidth = sbi.groupwidth                                -- starting width of the selection box
             local workingScreenWidth = myApp.sceneWidth - sbi.groupbetween   -- screen widh - the left edge (since each box would have 1 right edge)
             local workingGroupWidth = groupwidth + sbi.groupbetween          -- group width plus the right edge
             local groupsPerRow = math.floor(workingScreenWidth / workingGroupWidth )    -- how many across can we fit
             local leftWidth = myApp.sceneWidth - (workingGroupWidth*groupsPerRow )      -- width of the left edige
             local leftY = (leftWidth) / 2 + (sbi.groupbetween / 2 )          -- starting point of left box
             local dumText = display.newText( {text="X",font= myApp.fontBold, fontSize=sbi.textfontsize})
             local textHeightSingleLine = dumText.height
             display.remove( dumText )
             dumText=nil

             -------------------------------------------
             -- lots of extra edging ? edging > space in between ?
             -- expand the boxes but not beyond their max size
             -------------------------------------------
             if leftWidth > sbi.groupbetween then
                local origgroupwidth = groupwidth
                groupwidth = groupwidth + ((leftWidth - sbi.groupbetween) / groupsPerRow)   -- calcualte new group width
                if groupwidth > sbi.groupmaxwidth then                                      -- gone too far ? push back
                    groupwidth = sbi.groupmaxwidth 
                    if groupwidth < origgroupwidth then groupwidth = origgroupwidth end                -- just incase someone puts the max > than original
                end
                workingGroupWidth = groupwidth +  sbi.groupbetween                          -- calcualt enew total group width _ spacing
                leftWidth = myApp.sceneWidth - (workingGroupWidth*groupsPerRow )                       -- recalce leftwdith and left starting point
                leftY = (leftWidth) / 2 + (sbi.groupbetween / 2 )
             end

             -----------------------------------------------
             -- where we stuff all the little selection groups
             -----------------------------------------------
             local primGroup = display.newGroup(  )
 
 
             local row = 1
             local col = 1

             for k,v in pairs(myApp.authentication.policies) do 
                    local polgroup = myApp.authentication.policies[k]
                    -----------------------------
                    -- is there a relationship to a policy that no longer the polciy exists ? policyTerms count would be 0
                    -----------------------------
                    if #polgroup.policyTerms > 0 then
                        local polcurrentterm = polgroup.policyTerms[1]    -- should be the current term as the rest service sorrted and we instered in order
                        
                        print ("account page item " .. k .. polcurrentterm.policyinsuredname)
     
                         --------------------------------------
                         -- need to start a new row ?
                         --------------------------------------
                         if col > groupsPerRow then
                              row = row + 1
                              col = 1
                         end

                         local cellworkingGroupWidth = workingGroupWidth
                         local cellgroupwidth = groupwidth 
                         -- if v.doublewide then 
                         --    cellworkingGroupWidth = cellworkingGroupWidth * 2  
                         --    cellgroupwidth = cellgroupwidth * 2 + sbi.groupbetween
                         --    --col = col + 1
                         --    if col == groupsPerRow then
                         --      row = row + 1
                         --       col = 1
                         --     end
                         -- end

                         ---------------------------------------------
                         -- lets create the group
                         ---------------------------------------------
                         local itemGrp = display.newGroup(  )
                         itemGrp.id = k
                         itemGrp.title = (polcurrentterm.policytype or k)
                         local startX = cellworkingGroupWidth*(col-1) + leftY + cellgroupwidth/2
                         local startY = (groupheight/2 +sbi.groupbetween*row) + (row-1)* groupheight
                         
                         -------------------------------------------------
                         -- Background
                         -------------------------------------------------
                         local myRoundedRect = display.newRoundedRect(startX, startY ,cellgroupwidth,  groupheight, 1 )
                         myRoundedRect:setFillColor(sbi.groupbackground.r,sbi.groupbackground.g,sbi.groupbackground.b,sbi.groupbackground.a )
                         itemGrp:insert(myRoundedRect)

                         -------------------------------------------------
                         -- Header Background
                         -------------------------------------------------
                         local startYother = startY- groupheight/2 + sbi.groupbetween
                         local myRoundedTop = display.newRoundedRect(startX, startYother ,cellgroupwidth, sbi.groupheaderheight, 1 )
                         --local headcolor = sbi.groupheader
                         --myRoundedTop:setFillColor(headcolor.r,headcolor.g,headcolor.b,headcolor.a )
                         myRoundedTop:setFillColor(sbi.groupheader)
                         itemGrp:insert(myRoundedTop)
                         
                         -------------------------------------------------
                         -- Header text
                         -------------------------------------------------
                         local myText = display.newText( (polcurrentterm.policytype or ""), 0, startYother,  myApp.fontBold, sbi.headerfontsize )
                         myText:setFillColor( sbi.headercolor.r,sbi.headercolor.g,sbi.headercolor.b,sbi.headercolor.a )
                         myText.anchorX = 0
                         myText.x=sbi.textalignx
                         itemGrp:insert(myText)

                         -------------------------------------------------
                         -- Lob image ?
                         -------------------------------------------------
                         local lob = string.lower( (polcurrentterm.policylob or "default") )
                         local lobimage = nil
                         if myApp.lobinfo[lob]  then
                            lobimage = myApp.lobinfo[lob].image
                         else
                            lobimage = myApp.lobinfo["default"].image
                         end
                         if lobimage == nil then lobimage  =  myApp.lobinfo["default"].image end
                         if lobimage then
                             local myIcon = display.newImageRect(myApp.imgfld .. lobimage,  sbi.iconwidth , sbi.iconheight )
                             common.fitImage( myIcon,   sbi.iconwidth   )
                             myIcon.x = startX - cellgroupwidth/2 + myIcon.width/2  
                             myIcon.y = startYother  + myIcon.height/2  - sbi.groupheaderheight / 2
                             itemGrp:insert(myIcon)
                         end


                         local textwidth = cellgroupwidth  -sbi.textalignx + 5
                         -------------------------------------------------
                         -- Insured Name
                         -------------------------------------------------
                         
                         local myName = display.newText( {text=(polcurrentterm.policyinsuredname or ""), x=0, y=0, height=0,width=textwidth,font= myApp.fontBold, fontSize=sbi.nametextfontsize,align="left" })
                         myName:setFillColor( sbi.nametextcolor.r,sbi.nametextcolor.g,sbi.nametextcolor.b,sbi.nametextcolor.a )
                         myName.anchorX = 0
                         myName.anchorY = 0
                         myName.x=sbi.textalignx
                         myName.y=startYother + sbi.groupheaderheight 
                         itemGrp:insert(myName)


                         -------------------------------------------------
                         -- Balance label
                         -------------------------------------------------
                         
                         local myBalanceLabel = display.newText( {text=sbi.balancelabellabel  , x=0, y=0, height=0,font= myApp.fontBold, fontSize=sbi.balancelabelfontsize })
                         myBalanceLabel:setFillColor( sbi.balancelabelcolor.r,sbi.balancelabelcolor.g,sbi.balancelabelcolor.b,sbi.balancelabelcolor.a )
                         myBalanceLabel.x=startX - cellgroupwidth/2 + sbi.iconwidth /2  
                         myBalanceLabel.y=myName.y + 20
                         itemGrp:insert(myBalanceLabel)

                         -------------------------------------------------
                         -- Balance
                         -------------------------------------------------
                          
                         local myBalanceText = display.newText( {text=string.format("%6.2f",(polcurrentterm.policydue or "") ) , x=0, y=0, height=0,font= myApp.fontBold, fontSize=sbi.balancetextfontsize })
                         myBalanceText:setFillColor( sbi.balancetextcolor.r,sbi.balancetextcolor.g,sbi.balancetextcolor.b,sbi.balancetextcolor.a )
                         myBalanceText.x=myBalanceLabel.x
                         myBalanceText.y=myBalanceLabel.y + myBalanceLabel.height  
                         itemGrp:insert(myBalanceText)

                         -------------------------------------------------
                         -- POlicy Number 
                         -------------------------------------------------
                         
                         local myPolicy = display.newText( {text=sbi.policytextlabel .. (polcurrentterm.policynumber or ""), x=0, y=0, height=0,width=textwidth,font= myApp.fontBold, fontSize=sbi.policytextfontsize,align="left" })
                         myPolicy:setFillColor( sbi.policytextcolor.r,sbi.policytextcolor.g,sbi.policytextcolor.b,sbi.policytextcolor.a )
                         myPolicy.anchorX = 0
                         myPolicy.anchorY = 0.5
                         myPolicy.x=sbi.textalignx
                         myPolicy.y=myName.y + myName.height  + 10
                         itemGrp:insert(myPolicy)


                         -------------------------------------------------
                         -- Terms
                         -------------------------------------------------
                         local effdate = common.dateDisplayFromIso(polcurrentterm.effdate)
                         local expdate = common.dateDisplayFromIso(polcurrentterm.expdate)
                         
                         local myTerm = display.newText( {text=sbi.termtextlabel .. (effdate or "") .. " To " .. (expdate or "") , x=0, y=0, height=0,width=textwidth,font= myApp.fontBold, fontSize=sbi.termtextfontsize,align="left" })
                         myTerm:setFillColor( sbi.termtextcolor.r,sbi.termtextcolor.g,sbi.termtextcolor.b,sbi.termtextcolor.a )
                         myTerm.anchorX = 0
                         myTerm.anchorY = 0.5
                         myTerm.x=sbi.textalignx
                         myTerm.y=myPolicy.y + myPolicy.height 
                         itemGrp:insert(myTerm)

                         -------------------------------------------------
                         -- Add touch event
                         -------------------------------------------------
                         itemGrp:addEventListener( "tap", onObjectTouch )

                         -------------------------------------------------
                         -- insert each individual group into the master group
                         -------------------------------------------------

                         primGroup:insert(itemGrp)

                         col = col+1
                         -- if v.doublewide then 
                         --  col = col+1
                         -- end
                  end    -- end check for policyterms
              end     -- end for

              scrollView:insert(primGroup)

              ---------------------------------------------
              -- stick in a buffer for the scroll
              ----------------------------------------------
               scrollView:insert(display.newRoundedRect(1, (sbi.groupbetween*(row+1)) + row*sbi.groupheight ,1, sbi.groupbetween, 1 ))
               
             if myApp.authentication.loggedin then
                 ---------------------------------------------
                 -- Use Current Location button
                 ---------------------------------------------
                  addpolButton = widget.newButton {
                        shape=sbi.shape,
                        fillColor = { default={ sbi.btncolor.r, sbi.btncolor.g, sbi.btncolor.b , sbi.btndefaultcoloralpha}, over={ sbi.btncolor.r, sbi.btncolor.g, sbi.btncolor.b, sbi.btnovercoloralpha } },
                        label = sbi.addpolicybtntext,
                        labelColor = { default={ sbi.headercolor.r,sbi.headercolor.g,sbi.headercolor.b }, over={ sbi.headercolor.r,sbi.headercolor.g,sbi.headercolor.b, sbi.btnovercoloralpha } },
                        fontSize = sbi.headerfontsize,
                        font = myApp.fontBold,
                        width = myApp.sceneWidth - sbi.groupbetween*2,
                        height = sbi.btnheight,
                        x = 0,
                        y = scrollView.y + scrollView.height/2 + sbi.btnheight /2  + sbi.groupbetween/2,
                        onRelease = function() 
                                         if myApp.composer.inoverlay == false then
                                                myApp.showSubScreen({instructions=myApp.otherscenes.policyadd}) 
                                          end
                                     end,
                      }
                   container:insert(addpolButton)
              end


               print ("end of will show")
        end -- runit ?
       
    elseif ( phase == "did" ) then
         print ("end of did show")
         parse:logEvent( "Scene", { ["name"] = currScene} )
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
---------------------------------------------------
function scene:overlay( parms )
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