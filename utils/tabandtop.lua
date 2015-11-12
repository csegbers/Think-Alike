------------------------------------------------------
print ("tabandtop: IN")
------------------------------------------------------

local myApp = require( "myapp" )  
local common = require( myApp.utilsfld .. "common" )

local widget = require( "widget" )
local composer = require( "composer" )

----------------------------------------------------------
--    Top Title Bar stuff
----------------------------------------------------------
myApp.topBarBg = myApp.imgfld .. "topBarBg7.png"
myApp.TitleGroup = display.newGroup( )

----------------------------------------------------------
--   This goes behind the status bar
----------------------------------------------------------
local statusBarBackground = display.newImageRect(myApp.topBarBg, myApp.cW, myApp.tSbch)
statusBarBackground.x = myApp.cCx
statusBarBackground.y = myApp.tSbch * .5  
statusBarBackground.alpha = .5
myApp.TitleGroup:insert(statusBarBackground)

----------------------------------------------------------
--   This is the title bar
----------------------------------------------------------
local tbry = myApp.titleBarHeight / 2
local tbrheight = myApp.titleBarHeight

-------------------------------------------------
-- translucent status bar - adjust our background rect size and position.
-- bascially we want the whole rect to be gradient and status on top
-------------------------------------------------
if myApp.statusBarType == display.TranslucentStatusBar then 
   tbrheight = tbrheight + myApp.tSbch
   tbry = tbry + (myApp.tSbch /2)
else
   tbry = tbry + myApp.tSbch 
end

local titleBarRect = display.newRect(myApp.cW/2,tbry, myApp.cW, tbrheight )
titleBarRect.strokeWidth = 0
titleBarRect:setFillColor(  myApp.titleGradient )
myApp.TitleGroup:insert(titleBarRect)

----------------------------------------------------------
--   text in the Titlebar Set to blank initially
----------------------------------------------------------
local titleText = display.newText("", 0, 0, myApp.fontBold, 20 )
titleText:setFillColor (myApp.titleBarTextColor.r,myApp.titleBarTextColor.g,myApp.titleBarTextColor.b,myApp.titleBarTextColor.a)
titleText.x = myApp.cCx
titleText.y = myApp.titleBarHeight * 0.5 + myApp.tSbch  
myApp.TitleGroup.titleText = titleText
myApp.TitleGroup:insert(myApp.TitleGroup.titleText) 

----------------------------------------------------------
--   right side more button
----------------------------------------------------------
myApp.TitleGroup.moreIcon = widget.newButton {
        defaultFile = myApp.imgfld .. myApp.moreinfo.morebutton.defaultFile,
        overFile = myApp.imgfld .. myApp.moreinfo.morebutton.overFile ,
        height = myApp.tabs.tabbtnh,
        width = myApp.tabs.tabbtnw,
        x = myApp.sceneWidth - myApp.tabs.tabbtnw/2 - myApp.titleBarEdge  ,
        y = (myApp.titleBarHeight * 0.5 )  + myApp.tSbch  ,
        onRelease = function() if myApp.moreinfo.imsliding == false then myApp.MoreInfoMove() end end,
   }

myApp.TitleGroup:insert(myApp.TitleGroup.moreIcon) 
 
----------------------------------------------------------
--   the icon is added in the showscreen
----------------------------------------------------------


----------------------------------------------------------
--    Bottom Tab sections
----------------------------------------------------------

myApp.tabBar = {}

local tabButtons = {}
local tabCnt = 0
local function addtabBtn(tkey)
    local btnrntry = myApp.tabs.btns[tkey]      -- will refernece same copy no biggie for now
    -- local showbtn =   true
    -- if (btnrntry.showonlyindebugMode and myApp.debugMode == false) then showbtn = false end
    -- if (btnrntry.showonlyinloggedin and myApp.authentication.loggedin == false) then showbtn = false  end
    local showbtn = common.appCondition(btnrntry)

    if showbtn then
        tabCnt = tabCnt + 1

        ---------------------------------
        -- dynamically add a couple items
        ---------------------------------
        btnrntry.sel=tabCnt                         -- add a sequence
        btnrntry.key=tkey                           -- add the key to the table

        ----------------------------------
        -- Track special tabs like myagent. The actual key could be anything
        ----------------------------------
        if btnrntry.objectexisting  then
            if btnrntry.objectexisting == "myagent" then
                myApp.tabMyAgentKey = tkey
            elseif btnrntry.objectexisting == "myaccount" then
                myApp.tabMyAccountKey = tkey
            end
        end

        local tabitem = 
            {
                id = tkey,
                label = btnrntry.label,
                defaultFile = myApp.imgfld .. btnrntry.def,
                overFile = myApp.imgfld .. btnrntry.over,
                labelColor = { default = myApp.colorGray,   over = myApp.saColor,  },
                width = myApp.tabs.tabbtnw,
                height = myApp.tabs.tabbtnh,
                onPress= function () myApp.showScreen({instructions=btnrntry}) end,
            }
        table.insert(tabButtons, tabitem)
    end
end
------------------------------------------------
-- have to sort first
------------------------------------------------
 local a = {}
 for n in pairs(myApp.tabs.btns) do table.insert(a, n) end
 table.sort(a)
 for i,k in ipairs(a) do addtabBtn(k) end

 myApp.tabBar = widget.newTabBar{
    top =  myApp.cH - myApp.tabs.tabBarHeight ,
    left = 0,
    width = myApp.cW,
    backgroundFile = myApp.imgfld .. "tabBarBg7.png",
    tabSelectedLeftFile = myApp.imgfld .. "tabBar_tabSelectedLeft7.png",       
    tabSelectedRightFile = myApp.imgfld .. "tabBar_tabSelectedRight7.png",     
    tabSelectedMiddleFile = myApp.imgfld .. "tabBar_tabSelectedMiddle7.png",       
    tabSelectedFrameWidth = myApp.tabs.frameWidth,                                         
    tabSelectedFrameHeight = myApp.tabs.tabBarHeight,                                          
    buttons = tabButtons,
    height = myApp.tabs.tabBarHeight,
    --background="images/tabBarBg7.png"
}

----------------------------------------------------------
--   following may not be needed
----------------------------------------------------------
myApp.scenemaskFile = myApp.imgfld .. "mask-320x380.png"
if myApp.is_iPad then
    myApp.scenemaskFile = myApp.imgfld .. "mask-360x380.png"
end
if myApp.isTall then
    myApp.scenemaskFile = myApp.imgfld .. "mask-320x448.png"
end

------------------------------------
-- will gracefully close down the overlay if it is up
-- then do a callback or the regulat scene
--
-- you can alos pass in nil for callback to use this to simply shut down the overlay
-------------------------------------
function myApp.hideOverlay(parms)
    local currOverlay = (composer.getSceneName( "overlay" ))
    if currOverlay  then
       local v =  composer.getScene( currOverlay).myparams()
       print ("overlay effect back " .. v.navigation.composer.effectback)
       composer.hideOverlay(  v.navigation.composer.effectback , v.navigation.composer.time * 2 )   -- for some reason the time goes twice as fast
       timer.performWithDelay(v.navigation.composer.time * 2  ,function() myApp.composer.inoverlay = false end)   -- flag no longer in overlay
       if parms.callback then timer.performWithDelay(v.navigation.composer.time /2,parms.callback) end
    else
       if parms.callback then parms.callback() end
    end
    return true
end

--------------------------------------------------
-- parms - {instructions (table)}
--
-- Does the current screen want to possibly
-- do something when they hit the < > navigation buttons
-- case: webview.. maybe forward back on the web page if needed ?
--
-- if so do it
--------------------------------------------------
function myApp.showScreenCallback(parms)
    
    local returncode = false
    local currOverlay = (composer.getSceneName( "overlay" ))
    ----------------------------------------------
    -- does the current screen want to do something with navigation ?
    -- if so do it otherwise default to the normal navigation
    --
    -- But if we have an overlay scene showing... 
    -- hideOverlay would have remove it to get us back to normal processing
    --------------------------------------------------
    if currOverlay  then
        myApp.hideOverlay({callback=  nil})
    else
        pcall(function() returncode = composer.getScene( composer.getSceneName( "current" ) ):navigationhit({phase=parms.phase} ) end)
        if returncode == false then
            parms.callBack()
        end
    end
    
 
end


--------------------------------------------------
-- clear Title bar icons nav elements
--
-- parms - {instructions (table)}
--------------------------------------------------
function myApp.clearScreenIconWidget(parms)

    local xendpoint = -1
    if parms and parms.effectback then  
        xendpoint = 3
    end

    --------------------------------------------
    -- is there an icon ? get rid of
    --------------------------------------------
    if myApp.TitleGroup.titleIcon then
        transition.to( myApp.TitleGroup.titleIcon, { time=myApp.tabs.transitiontime*2, transition=easing.outQuint, alpha=0 ,x = myApp.TitleGroup.titleIcon.x*xendpoint,onComplete= function () end})
        display.remove(myApp.TitleGroup.titleIcon)    -- may not exist first time, this wont hurt
        myApp.TitleGroup.titleIcon = nil
    end

    --------------------------------------------
    -- is there a back widget ? get rid of
    --------------------------------------------
    if myApp.TitleGroup.backButton then
        transition.to( myApp.TitleGroup.backButton, { time=myApp.tabs.transitiontime*2, transition=easing.outQuint, alpha=0 ,x = myApp.TitleGroup.backButton.x*xendpoint,onComplete= function () end})
        display.remove(myApp.TitleGroup.backButton)    -- may not exist first time, this wont hurt
        myApp.TitleGroup.backButton = nil
    end

    --------------------------------------------
    -- is there a forward widget ? get rid of
    --------------------------------------------
    if myApp.TitleGroup.forwardButton then
        transition.to( myApp.TitleGroup.forwardButton, { time=myApp.tabs.transitiontime*2, transition=easing.outQuint, alpha=0 ,x = myApp.TitleGroup.forwardButton.x*xendpoint,onComplete= function () end})
        display.remove(myApp.TitleGroup.forwardButton)    -- may not exist first time, this wont hurt
        myApp.TitleGroup.forwardButton = nil
    end
end

--------------------------------------------------
-- showScreenIcon
--
-- parms - {instructions (table)}
--------------------------------------------------
function myApp.showScreenIcon(image)

        myApp.clearScreenIconWidget()

        myApp.TitleGroup.titleIcon = display.newImageRect(image,myApp.tabs.tabbtnh,myApp.tabs.tabbtnw)
        common.fitImage( myApp.TitleGroup.titleIcon, myApp.titleBarHeight - myApp.titleBarEdge, false )
        myApp.TitleGroup.titleIcon.x = myApp.titleBarEdge + (myApp.TitleGroup.titleIcon.width * 0.5 )
        myApp.TitleGroup.titleIcon.y = (myApp.titleBarHeight * 0.5 )+ myApp.tSbch

        myApp.TitleGroup.titleIcon.alpha = 0
        myApp.TitleGroup:insert(myApp.TitleGroup.titleIcon)
        transition.to( myApp.TitleGroup.titleIcon, { time=myApp.tabs.transitiontime, alpha=1 })
end
--------------------------------------------------
-- Show screen. Add function
--
-- Used for the Major scenes from the Tabbar **************************
--
-- parms - instructions(table), [firsttime], [effectback]
--         instructions table must have a composer table
--------------------------------------------------
function myApp.showScreen(parms)

    if myApp.moreinfo.direction  == "left" then 
        myApp.hideOverlay({callback= function () 
                local tnt = parms.instructions
                myApp.tabCurrentKey = tnt.key
                ----------------------------------------------------------
                --   Make sure the Tab is selected in case we came from a different direction instead of user tapping tabbar
                ----------------------------------------------------------
                myApp.tabBar:setSelected(tnt.sel)
                ----------------------------------------------------------
                --   Change the title in the status bar and launch new screen
                ----------------------------------------------------------
                if parms.firsttime  then
                    myApp.TitleGroup.titleText.text = tnt.title
                    myApp.showScreenIcon(myApp.imgfld .. parms.instructions.over)
                else
                    ---------------------------------------------------
                    -- on a subscreen coming back ? slide it on in
                    ---------------------------------------------------
                    if parms.effectback then  
                        transition.to( myApp.TitleGroup.titleText, { 
                        time=myApp.tabs.transitiontime/2, alpha=.2,x = myApp.TitleGroup.titleText.x*3,
                        onComplete= function () myApp.TitleGroup.titleText.text = tnt.title; myApp.TitleGroup.titleText.x = myApp.cCx*-1;  transition.to( myApp.TitleGroup.titleText, {alpha=1,x = myApp.cCx,   transition=easing.outQuint, time=myApp.tabs.transitiontime  }) myApp.showScreenIcon(myApp.imgfld .. parms.instructions.over) end } )
                          
                    else
                        transition.to( myApp.TitleGroup.titleText, { time=myApp.tabs.transitiontime , alpha=.2,onComplete= function () myApp.TitleGroup.titleText.text = tnt.title;  transition.to( myApp.TitleGroup.titleText, {alpha=1, time=myApp.tabs.transitiontime }) end } )
                        transition.to( myApp.TitleGroup.titleIcon, { time=myApp.tabs.transitiontime, alpha=0 ,onComplete=myApp.showScreenIcon(myApp.imgfld .. parms.instructions.over)})
                    end
                end

                local effect = tnt.navigation.composer.effect
                -----------------------------------------------
                -- override effect ? Maybe a "back" etc..
                -----------------------------------------------
                if parms.effectback then effect = parms.effectback end


                local function fncgotoScene ( event )
                   composer.gotoScene(myApp.scenesfld .. tnt.navigation.composer.lua, {time=tnt.navigation.composer.time, effect=effect, params = tnt})
                end
                 
                --------------------------------------------
                -- goto the new scene
                --
                -- If we are reusing a scene we want to simulate a clide off otherwise the scene simply gets replaced
                --------------------------------------------
                if ("scenes." .. tnt.navigation.composer.lua) == composer.getSceneName( "current" ) then
                    local rc = false
                    local samescenedelta = -1
                    if effect =="slideRight" then samescenedelta = 1 end
                    pcall(function() rc =  composer.getScene( composer.getSceneName( "current" ) ):replaceself({time=tnt.navigation.composer.time,x=myApp.sceneWidth* samescenedelta } ) end)
                    if rc then 
                        timer.performWithDelay(tnt.navigation.composer.time/2  , fncgotoScene )   -- flag no longer in overlay
                    else
                        fncgotoScene()
                    end
                else
                    fncgotoScene()
                end


          end })    -- callback funcyion
    end
    return true
end



--------------------------------------------------
-- Show sub screen. Add function
-- parms - instructions(table) 
--         instructions table must have a composer table
--------------------------------------------------
function myApp.showSubScreenRegular(parms)
        local tnt = parms.instructions or {}

        ----------------------------------------------
        -- As screen calls screen calls screen... the parms
        -- builds all by itself the trail of these calls because the callback
        -- actrually has the prior parent parms infos so...so--
        ----------------------------------------------
 
        myApp.clearScreenIconWidget(parms )
 
        --------------------------------------------
        -- Slide the current Text out
        -- and set to the new text
        -- SLide it on in
        --------------------------------------------
        ---------------------------------------------------
        -- on a subscreen coming back ? slide it on in
        ---------------------------------------------------
        local xendpoint = -1
        local xstartpoint = 3
        local xbackbutton = myApp.cW
        local effect = tnt.navigation.composer.effect
        if parms.effectback then  
           xendpoint = 3
           xstartpoint = -1
           xbackbutton = -20
           effect = parms.effectback
        end

        transition.to( myApp.TitleGroup.titleText, 
            { 
               time=myApp.tabs.transitiontime, alpha=.2,x = myApp.TitleGroup.titleText.x*xendpoint,
               onComplete= function () myApp.TitleGroup.titleText.text = tnt.title; myApp.TitleGroup.titleText.x = myApp.cCx*xstartpoint;  transition.to( myApp.TitleGroup.titleText, {alpha=1,x = myApp.cCx,   transition=easing.outQuint, time=myApp.tabs.transitiontime }) end
             } )

        --------------------------------------------
        -- Create a widget (text only or icon) for the navigation ?
        --
        -- Back button
        --------------------------------------------   
        if tnt.defaultFile then
           myApp.TitleGroup.backButton = widget.newButton {
                defaultFile = tnt.defaultFile ,
                overFile = tnt.overFile ,
                onRelease = function() myApp.showScreenCallback ({callBack=tnt.callBack,phase="back"}) end,
            }
        else
               myApp.TitleGroup.backButton = widget.newButton {
                    label = (tnt.backtext or "<") ,
                    width =  myApp.tabs.tabbtnw,
                    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
                    fontSize = 30,
                    font = myApp.fontBold,
                    onRelease = function() myApp.showScreenCallback ({callBack=tnt.callBack,phase="back"}) end,
               }
        end
        -- if tnt.backtext then    
        --        myApp.TitleGroup.backButton = widget.newButton {
        --             label = tnt.backtext ,
        --             width =  myApp.tabs.tabbtnw,
        --             labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        --             fontSize = 30,
        --             font = myApp.fontBold,
        --             onRelease = function() myApp.showScreenCallback ({callBack=tnt.callBack,phase="back"}) end,
        --        }

        -- else
        --     if tnt.defaultFile then
        --        myApp.TitleGroup.backButton = widget.newButton {
        --             defaultFile = tnt.defaultFile ,
        --             overFile = tnt.overFile ,
        --             onRelease = function() myApp.showScreenCallback ({callBack=tnt.callBack,phase="back"}) end,
        --         }
        --     end
        -- end
        --------------------------------------------
        -- Create a widget (text only or icon) for the navigation ?
        --
        -- Forward button
        --------------------------------------------   
        if tnt.forwardtext then 
           myApp.TitleGroup.forwardButton = widget.newButton {
                label = tnt.forwardtext ,
                width =  myApp.tabs.tabbtnw,
                labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
                fontSize = 30,
                font = myApp.fontBold,
                onRelease = function() myApp.showScreenCallback ({callBack=tnt.callBack,phase="forward"}) end,
           }
        else
             if tnt.defaultForwardFile then
               myApp.TitleGroup.forwardButton = widget.newButton {
                    defaultFile = tnt.defaultForwardFile ,
                    overFile = tnt.overForwardFile ,
                    onRelease = function() myApp.showScreenCallback ({callBack=tnt.callBack,phase="forward"}) end,
                }
            end
        end

        myApp.TitleGroup.backButton.x = xbackbutton
        myApp.TitleGroup.backButton.y = (myApp.titleBarHeight * 0.5 )  + myApp.tSbch  
        myApp.TitleGroup:insert(myApp.TitleGroup.backButton)

        transition.to( myApp.TitleGroup.backButton, { time=myApp.tabs.transitiontime*2, x = myApp.titleBarEdge *2 , transition=easing.outQuint})
 
        if myApp.TitleGroup.forwardButton then
            myApp.TitleGroup.forwardButton.x = xbackbutton 
            myApp.TitleGroup.forwardButton.y = (myApp.titleBarHeight * 0.5 )  + myApp.tSbch  
            myApp.TitleGroup:insert(myApp.TitleGroup.forwardButton)

            transition.to( myApp.TitleGroup.forwardButton, { time=myApp.tabs.transitiontime*2, x = myApp.titleBarEdge *2 + myApp.tabs.tabbtnw, transition=easing.outQuint})
        end

        local function fncgotoSubScene ( event )
           composer.gotoScene(myApp.scenesfld .. tnt.navigation.composer.lua, {time=tnt.navigation.composer.time, effect=effect, params = tnt})
        end

        --------------------------------------------
        -- goto the new scene
        --
        -- If we are reusing a scene we want to simulate a clide off otherwise the scene simply gets replaced
        --------------------------------------------
        if ("scenes." .. tnt.navigation.composer.lua) == composer.getSceneName( "current" ) then
            local rc = false
            local samescenedelta = -1
            if effect =="slideRight" then samescenedelta = 1 end
            pcall(function() rc =  composer.getScene( composer.getSceneName( "current" ) ):replaceself({time=tnt.navigation.composer.time,x=myApp.sceneWidth* samescenedelta } ) end)
            if rc then 
                timer.performWithDelay(tnt.navigation.composer.time/2  , fncgotoSubScene )   -- flag no longer in overlay
            else
                fncgotoSubScene()
            end
        else
            fncgotoSubScene()
        end
  
    return true
end


--------------------------------------------------
-- Show sub screen. Add function
-- parms - instructions(table) 
--         instructions table must have a composer table
--------------------------------------------------
function myApp.showSubScreen(parms)
        local currOverlay = (composer.getSceneName( "overlay" ))
        myApp.hideOverlay({callback= function () 
                local tnt = parms.instructions or {}
                if tnt.navigation.composer.otherscenes then
                    --debugpopup (myApp.otherscenes[tnt.navigation.composer.otherscenes].navigation.composer.time)
                    tnt.navigation = myApp.otherscenes[tnt.navigation.composer.otherscenes].navigation
                    tnt.sceneinfo = myApp.otherscenes[tnt.navigation.composer.otherscenes].sceneinfo
                    --print (myApp.otherscenes[tnt.navigation.composer.otherscenes].navigation.composer.time)
                end
                if tnt.navigation.composer.overlay then
                    -------------------------------------
                    -- if we just were in an overlay, it was just closed
                    -- must select action again otherwise it gets 2 overlays 
                    -- tripping on each other
                    -------------------------------------
                    if currOverlay == nil then
                       myApp.composer.inoverlay = true
                       composer.showOverlay(myApp.scenesfld .. tnt.navigation.composer.lua, {time=tnt.navigation.composer.time,effect=tnt.navigation.composer.effect,isModal=tnt.navigation.composer.isModal, params = tnt ,})
                    end
                else
                    myApp.showSubScreenRegular(parms)
                end
                end }) -- callback
end


function myApp.navigationCommon(parms)
--function myApp.navigationCommon(parms, parentinfo)
       local v = parms
       -----------------------------------
       -- composer
       -----------------------------------
       if v.navigation.composer  then
          if v.navigation.composer.otherscenes then
            local otherscene = myApp.otherscenes[v.navigation.composer.otherscenes]
            v.navigation = otherscene.navigation
            v.sceneinfo  = otherscene.sceneinfo
          end
          if ((composer.getSceneName( "current" )  == (myApp.scenesfld .. v.navigation.composer.lua))
              and (composer.getScene( composer.getSceneName( "current" ) ).myparams().navigation.composer.id == v.navigation.composer.id)) then
           else
             --if parentinfo then
              --v.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback=v.navigation.composer.effectback}) end
             --else
              v.callBack = function() myApp.showScreen({instructions=myApp.tabs.btns[myApp.tabCurrentKey],effectback=v.navigation.composer.effectback}) end
             --end
             myApp.showSubScreen ({instructions=v})   
          end
       else
           -----------------------------------
           -- tabbar
           -----------------------------------
            if v.navigation.tabbar then
               myApp.showScreen({instructions=myApp.tabs.btns[v.navigation.tabbar.key]})
            else
               -----------------------------------
               -- systemurl
               -----------------------------------
               if v.navigation.systemurl then
                  local dothenavigation = true
                  local url = v.navigation.systemurl.url

                  local function goUrl()

                      if dothenavigation then 
                         local launchsuccess = system.openURL(url) 
                         if ( launchsuccess == false ) then   
                            if v.navigation.systemurl.urlfallback then
                               system.openURL(v.navigation.systemurl.urlfallback )  
                            end
                         end
                      end
                  end
                  -----------------------------------
                  -- phone call ? SHould we prompt
                  -----------------------------------
                  if string.sub(url, 1, 4):upper() == "TEL:" then
                      -------------------------------
                      -- strip out non digits
                      -------------------------------
                      local digitsonly = (string.gsub( url, "[^0-9]", "" )  or "")
                      url = "tel:" .. digitsonly
                      if myApp.promptforphonecalls then
                           -- Show alert with two buttons
                          -- local disphone = ("(" .. string.sub(digitsonly, 1,3) .. ") " .. string.sub(digitsonly, 4,6) .. "-" .. string.sub(digitsonly, 7) )
                          -- if string.len( digitsonly) ~= 10 then
                          --   disphone = digitsonly
                          -- end
                          local disphone = common.phoneformat(digitsonly)
                          native.showAlert( myApp.appName, "Call " .. disphone .. " ?" , { "OK", "Cancel" },  function( event ) if event.action == "clicked" then   local i = event.index if i == 2 then dothenavigation = false end goUrl() end end)
                     else
                          goUrl()
                     end    -- promptforphonecalls
                  else
                     -----------------------------------
                     -- http request should be only thing left
                     -----------------------------------
                     if string.sub(url, 1, 4):upper() ~= "HTTP" then
                        url = "http://" .. common.urlencode(url)
                     end
                     goUrl()
                  end   -- tele

               else  --- else on systemurl
                  -------------------------------
                  -- directions
                  -------------------------------
                  if v.navigation.directions then
                     myApp.navigationDirections(v)
                  else
                      -------------------------------
                       -- search
                      -------------------------------
                      if v.navigation.search then
                           myApp.navigationSearch(v)
                       else
                           -------------------------------
                           -- popup like email or sms
                           -------------------------------
                           if v.navigation.popup then
                              native.showPopup( v.navigation.popup.type, v.navigation.popup.options )
                           else
                               ------------------------------
                               -- execute some code
                               ------------------------------
                               if  v.navigation.execute then
                                   v.navigation.execute.method()
                               else
                                   ------------------------------
                                   -- Launch another app
                                   ------------------------------
                                   if v.navigation.app then
                                         local launchsuccess = system.openURL(v.navigation.app.url) 
                                         if ( launchsuccess == false ) then   
                                            if v.navigation.app.urlfallback then
                                               system.openURL(v.navigation.app.urlfallback )  
                                            end
                                         end
                                   end
                               end
                           end   -- v.navigation.popup
                       end  -- v.navigation.search 
                  end   -- v.navigation.directions
               end  --v.navigation.systemurl
            end  --v.navigation.tabbar
       end   --v.navigation.composer 


end


function myApp.navigationSearch(parms)
       local v = parms
       local function navseaReleaseback() 
              ------------------------------------------------------
              -- have accurate location ?
              ------------------------------------------------------
              if myApp.gps.haveaccuratelocation == true then
                  debugpopup (myApp.maps.google.app .. "?q=" .. common.urlencode(v.navigation.search.q) .. "&center=" .. myApp.gps.currentlocation.latitude .. "," .. myApp.gps.currentlocation.longitude .. (myApp.maps.google.search.additions or "") .. "&x-success=" .. myApp.urlScheme .. "://?resume=true" .. "&x-source=" .. common.urlencode(myApp.appNameSmall))
                 local didOpenGoogleMaps = system.openURL(myApp.maps.google.app .. "?q=" .. common.urlencode(v.navigation.search.q) .. "&center=" .. myApp.gps.currentlocation.latitude .. "," .. myApp.gps.currentlocation.longitude .. (myApp.maps.google.search.additions or "") .. "&x-success=" .. myApp.urlScheme .. "://?resume=true" .. "&x-source=" .. common.urlencode(myApp.appNameSmall))
                 --local didOpenGoogleMaps = system.openURL(myApp.maps.google.app .. "?q=" .. common.urlencode(v.navigation.search.q) .. (myApp.maps.google.search.additions or "") .. "&x-success=" .. myApp.urlScheme .. "://?resume=true" .. "&x-source=" .. common.urlencode(myApp.appNameSmall))
                 if ( didOpenGoogleMaps == false ) then  --defer to Apple Maps
                    --debugpopup(myApp.maps.apple.app .. "?q=" .. common.urlencode(v.navigation.search.q) .. "&sll=" .. myApp.gps.currentlocation.latitude .. "," .. myApp.gps.currentlocation.longitude )
                    system.openURL(myApp.maps.apple.app .. "?q=" .. common.urlencode(v.navigation.search.q) .. "&sll=" .. myApp.gps.currentlocation.latitude .. "," .. myApp.gps.currentlocation.longitude .. (myApp.maps.apple.search.additions or "") )
                 end
              end
       end     
       if v.navigation.search  then
            --system.openURL("comgooglemaps://?q=Pizza&center=39.896311,-82.76")
            myApp.getCurrentLocation({callback=navseaReleaseback}) 
       end   --v.navigation.directions 
end

function myApp.navigationDirections(parms)
       local v = parms
       local function navdirReleaseback() 
              ------------------------------------------------------
              -- have accurate location ?
              ------------------------------------------------------
              if myApp.gps.haveaccuratelocation == true then
                 --debugpopup (myApp.maps.googlemapapp .. "?saddr=" .. myApp.gps.currentlocation.latitude .. "," .. myApp.gps.currentlocation.longitude .. "&daddr=" .. common.urlencode(v.navigation.directions.address) .. "&directionsmode=transit" .. "&x-success=" .. myApp.urlScheme .. "://?resume=true" .. "&x-source=" .. myApp.appName)
                 local didOpenGoogleMaps = system.openURL(myApp.maps.google.app .. "?saddr=" .. myApp.gps.currentlocation.latitude .. "," .. myApp.gps.currentlocation.longitude .. "&daddr=" .. common.urlencode(v.navigation.directions.address) .. (myApp.maps.google.directions.additions .. "") .. "&x-success=" .. myApp.urlScheme .. "://?resume=true" .. "&x-source=" .. common.urlencode(myApp.appNameSmall))
                 if ( didOpenGoogleMaps == false ) then  --defer to Apple Maps
                    system.openURL(myApp.maps.apple.app .. "?daddr=" .. common.urlencode(v.navigation.directions.address) .. "&saddr=" .. myApp.gps.currentlocation.latitude .. "," .. myApp.gps.currentlocation.longitude .. (myApp.maps.apple.directions.additions .. ""))
                 end
              end
       end     
       if v.navigation.directions  then
            myApp.getCurrentLocation({callback=navdirReleaseback}) 
       end   --v.navigation.directions 
end
-- system.openURL("comgooglemaps://?saddr=lat,lng&daddr=xxx&directionsmode=transit")


--------------------------------------
-- orientation changed ?
---------------------------------------
function myApp.onOrientationChange( event )
    local currentOrientation = event.type
    print( "Current orientation: " .. currentOrientation )
    pcall(function() composer.getScene( composer.getSceneName( "current" ) ):orientationchange(event) end)
    pcall(function() composer.getScene( composer.getSceneName( "overlay" ) ):orientationchange(event) end)

end
Runtime:addEventListener( "orientation", myApp.onOrientationChange )

------------------------------------------------------
print ("tabandtop: OUT")
------------------------------------------------------


