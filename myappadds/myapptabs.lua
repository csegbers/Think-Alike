
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local tabs = { 
  
        tabbtnw = 32,tabbtnh = 32, tabBarHeight = 50,frameWidth = 20,launchkey = "ahome", transitiontime = 200,
        btns = {
            ahome = {
                        label="Home", title="State Auto" ,def="saicon.png",over="saicon-down.png",
                        sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { object="homepage" , navigate = "mainscene"},
                                             },
                        navigation = { composer = { id = "home",lua="scrollblocks" ,time=250, effect="crossFade" },},
                    },
          bagent = {
                        label="My Agent" ,title="My Agent" ,def="myagent.png",over="myagent-down.png",
                        objecttype = "Agency",
                        objectexisting = "myagent",
                        sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { },
                                               usage = { navigate = "mainscene"},

                                             },
                        navigation = { composer = {id = "myagent", lua="locatedetails" ,time=250, effect="crossFade" },},
                                
                    },
          caccount = {
                        label="My Account",  title="My Account" ,def="account.png",over="account-down.png",
                         objecttype = "",  -- not used
                         objectexisting = "myaccount",
                         sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { },
                                               usage = { navigate = "mainscene"},
                                             },
                        navigation = { composer = { id = "myaccount",lua="account" ,time=250, effect="crossFade" },},
                    },

          zdebug = {
                     label="Debug" ,title="Debug" ,def="tabbaricon.png",over="tabbaricon-down.png" ,showonlyindebugMode=true,
                     sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { },
                                             },
                    navigation = { composer = { id = "debug",lua="debugapp" ,time=250, effect="crossFade" },},
                  }
                }
        } 

         

return tabs
-- The following string values are supported for the effect key of the options table:

-- "fade"
-- "crossFade"
-- "zoomOutIn"
-- "zoomOutInFade"
-- "zoomInOut"
-- "zoomInOutFade"
-- "flip"
-- "flipFadeOutIn"
-- "zoomOutInRotate"
-- "zoomOutInFadeRotate"
-- "zoomInOutRotate"
-- "zoomInOutFadeRotate"
-- "fromRight" — over current scene
-- "fromLeft" — over current scene
-- "fromTop" — over current scene
-- "fromBottom" — over current scene
-- "slideLeft" — pushes current scene off
-- "slideRight" — pushes current scene off
-- "slideDown" — pushes current scene off
-- "slideUp" — pushes current scene off