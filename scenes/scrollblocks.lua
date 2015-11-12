---------------------------------------------------------------------------------------
-- HOME scene
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



        --------------------------------------
        -- since this scene can be used for multiple purposes
        -- sbi will point to the table for what items to show etc...etc
        ---------------------------------------
        sbi = myApp[sceneparams.sceneinfo.scrollblockinfo.object]
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
                    y = 0,
                    width = myApp.sceneWidth, 
                    height =  myApp.sceneHeight,
                    listener = scrollListener,
                    horizontalScrollDisabled = true,
                    hideBackground = true,
                }
             container:insert(scrollView)

             ----------------------------------------------
             -- Tcouhed an object - go do something
             ----------------------------------------------
             local function onObjectTouch( event )
                print ("sceneparams " .. sbi.groupwidth)
                local homepageitem = sbi.items[event.target.id] 
            --    local homepageitem = sbi.items[event.target.id] 
                -------------------------------------------
                -- launch another scene ?
                -- Pass in our scene info for the new scene callback
                -------------------------------------------
                local function onObjectTouchAction(  )
                    ------------------------------
                    -- subscene with a composer ?
                    ------------------------------
                    if sceneparams.sceneinfo.scrollblockinfo.navigate == "subscene" and homepageitem.navigation.composer then
                         --debugpopup (sceneparams.sceneinfo.scrollblockinfo.navigate .. " " )
                         local parentinfo =  sceneparams 
                         homepageitem.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
                         myApp.showSubScreen ({instructions=homepageitem})
                    else
                         myApp.navigationCommon(homepageitem)
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

             --------------------------------------------
             -- must sort otherwise order is not honered
             -- so the KEYS must be in alphabetical order you want !!
             --------------------------------------------
             local a = {}
             for n in pairs(sbi.items) do table.insert(a, n) end
             table.sort(a)
             local row = 1
             local col = 1
             for i,k in ipairs(a) do 
                 local v = sbi.items[k]
                 print ("home page item " .. k)
                 -- local showbtn = true
                 -- if (v.showonlyindebugMode and myApp.debugMode == false) then showbtn = false end
                 -- if (v.showonlyinloggedin and myApp.authentication.loggedin == false) then showbtn = false  end
                 local showbtn = common.appCondition(v)

                 if showbtn then
                     --------------------------------------
                     -- need to start a new row ?
                     --------------------------------------
                     if col > groupsPerRow then
                          row = row + 1
                          col = 1
                     end

                     local cellworkingGroupWidth = workingGroupWidth
                     local cellgroupwidth = groupwidth 
                     local iconverticaladjust = 10
                     local iconhorizontaladjust = 0
                     local textwidthadjust = 0
                     local textxadjust = 0
                     local blnadjusttexty = false  
                     if v.doublewide then 
                        iconverticaladjust = 0
                        cellworkingGroupWidth = cellworkingGroupWidth * 2  
                        cellgroupwidth = cellgroupwidth * 2 + sbi.groupbetween
                        iconhorizontaladjust = cellgroupwidth / 3
                        textwidthadjust =  cellgroupwidth   / 2   
                        textxadjust =   textwidthadjust /2 - 15
                        blnadjusttexty = true
                        --col = col + 1
                        if col == groupsPerRow then
                          row = row + 1
                           col = 1
                         end
                     end

                     ---------------------------------------------
                     -- lets create the group
                     ---------------------------------------------
                     local itemGrp = display.newGroup(  )
                     itemGrp.id = k
                     local startX = cellworkingGroupWidth*(col-1) + leftY + cellgroupwidth/2
                     local startY = (groupheight/2 +sbi.groupbetween*row) + (row-1)* groupheight
                     
                     -------------------------------------------------
                     -- Background
                     -------------------------------------------------
                     local myRoundedRect = display.newRoundedRect(startX, startY ,cellgroupwidth,  groupheight, 1 )
                     local backcolor = v.groupbackground or sbi.groupbackground
                     local backcolorstyle = v.groupbackgroundstyle or sbi.groupbackgroundstyle
                     -----------------------------
                     -- anything from sepfici item being used ? use it first
                     -----------------------------
                     if v.groupbackground or v.groupbackgroundstyle then
                        if v.groupbackground then backcolorstyle = nil else backcolor = nil end
                     end
                     -------------------------------------
                     -- style wins over regular color
                     ---------------------------------
                     if  backcolorstyle then
                        myRoundedRect:setFillColor(backcolorstyle)
                     else
                        myRoundedRect:setFillColor(backcolor.r,backcolor.g,backcolor.b,backcolor.a )
                     end
                    -- myRoundedRect:setFillColor(sbi.groupbackground.r,sbi.groupbackground.g,sbi.groupbackground.b,sbi.groupbackground.a )
                     itemGrp:insert(myRoundedRect)

                     -------------------------------------------------
                     -- Header Background
                     -------------------------------------------------
                     local startYother = startY- groupheight/2 + sbi.groupbetween
                     local groupheaderheight = v.groupheaderheight or sbi.groupheaderheight
                     local myRoundedTop = display.newRoundedRect(startX, startYother ,cellgroupwidth, groupheaderheight, 1 )
                     local headcolor = v.groupheader or sbi.groupheader
                     local headcolorstyle = v.groupheaderstyle or sbi.groupheaderstyle
                     -----------------------------
                     -- anything from sepfici item being used ? use it first
                     -----------------------------
                     if v.groupheader or v.groupheaderstyle then
                        if v.groupheader then headcolorstyle = nil else headcolor = nil end
                     end
                     -------------------------------------
                     -- style wins over regular color
                     ---------------------------------
                     if  headcolorstyle then
                        myRoundedTop:setFillColor(headcolorstyle)
                     else
                        myRoundedTop:setFillColor(headcolor.r,headcolor.g,headcolor.b,headcolor.a )
                     end

                     itemGrp:insert(myRoundedTop)
                     
                     -------------------------------------------------
                     -- Header text
                     -------------------------------------------------
                     local headerfontsize = v.headerfontsize or sbi.headerfontsize
                     local myText = display.newText( (v.title or ""), startX, startYother,  myApp.fontBold, headerfontsize )
                     myText:setFillColor( sbi.headercolor.r,sbi.headercolor.g,sbi.headercolor.b,sbi.headercolor.a )
                     itemGrp:insert(myText)

                     -------------------------------------------------
                     -- Icon ?
                     -------------------------------------------------
                     if v.pic then
                         local myIcon = display.newImageRect(myApp.imgfld .. v.pic, v.originaliconwidth or sbi.iconwidth ,v.originaliconheight or sbi.iconheight )
                         common.fitImage( myIcon, v.iconwidth or sbi.iconwidth   )
                         myIcon.x = startX - iconhorizontaladjust
                         myIcon.y = startYother + itemGrp.height/2 - iconverticaladjust --- sbi.iconwidth
                         itemGrp:insert(myIcon)
                     end

                     -------------------------------------------------
                     -- Desc text
                     -------------------------------------------------
                     local textfontsize = v.textfontsize or sbi.textfontsize
                     local myDesc = display.newText( {text=(v.text or ""), x=startX +   textxadjust, y=0, height=0,width=cellgroupwidth-5 - textwidthadjust ,font= myApp.fontBold, fontSize= textfontsize,align="center" })
                     myDesc.y=startYother+groupheight - (myDesc.height/2) - sbi.textbottomedge  
                     if blnadjusttexty then
                        myDesc.y=startYother + itemGrp.height/2
                     end
                     myDesc:setFillColor( sbi.textcolor.r,sbi.textcolor.g,sbi.textcolor.b,sbi.textcolor.a )
                     itemGrp:insert(myDesc)

                     -------------------------------------------------
                     -- Add touch event
                     -------------------------------------------------
                     itemGrp:addEventListener( "tap", onObjectTouch )

                     -------------------------------------------------
                     -- insert each individual group into the master group
                     -------------------------------------------------

                     primGroup:insert(itemGrp)

                     col = col+1
                     if v.doublewide then 
                      col = col+1
                     end
                 end   -- end showbtn
              end     -- end for

              scrollView:insert(primGroup)

              ---------------------------------------------
              -- stick in a buffer for the scroll
              ----------------------------------------------
               scrollView:insert(display.newRoundedRect(1, (sbi.groupbetween*(row+1)) + row*sbi.groupheight ,1, sbi.groupbetween, 1 ))
               print ("end of will show")
        end -- runit ?
       
    elseif ( phase == "did" ) then
         print ("end of did show")
        parse:logEvent( "Scene", { ["name"] = currScene} )
        

            -- Called when the scene is now on screen.
            -- Insert code here to make the scene come alive.
            -- Example: start timers, begin animation, play audio, etc.

         if myApp.authentication.loggedin == false and myApp.justLaunched == true then
            myApp.justLaunched = false
            timer.performWithDelay(10, myApp.showSubScreen({instructions=myApp.otherscenes.login}))  --- cant just launch if we recycle composer for some reason

         end
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
     print ("overlay happening on top of " .. currScene .. " " .. parms.type .. " " .. parms.phase)
     -- local deltamult
     -- if parms.phase == "will"  then
     --     if parms.type == "show"  then
     --        deltamult = 1
     --     else     -- parms.type == "hide"then
     --        deltamult = -1
     --     end
     --     transition.to(  container, {  time=parms.time,delta=true, y=(parms.height + 20 )* deltamult  , height = (parms.height+40) *deltamult*-1  , transition=parms.transition})
     -- end
end


---------------------------------------------------
-- use if someone wants us to transition away
-- for navigational appearnaces
-- used from the more button
---------------------------------------------------
function scene:replaceself( parms )

    transition.to(  container, {  time=parms.time,delta=true, x=parms.x  })
    return true    -- return otherwise caller does not know we exist
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