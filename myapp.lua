
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local M = { 
            debugMode = true,
            appName = "The State Auto Insured App" ,
            appNameSmall = "Insured App" ,
            tabMyAgentKey = "",     -- will be key of myagent if used
            tabMyAccountKey = "",     -- will be key of myaccount if used
            tabCurrentKey = "",     -- will change as we tab
            urlScheme = "rockhillapp",
            cW = display.contentWidth,
            cH = display.contentHeight,
            cCx = display.contentCenterX,
            cCy = display.contentCenterY,
            tSbch = display.topStatusBarContentHeight,
            statusBarType = display.TranslucentStatusBar,       "display.DefaultStatusBar",    "display.DarkStatusBar",    "display.TranslucentStatusBar",
            saColor = { },
            saColorTrans = { },
            colorGray = { },
            isTall = false,
            colorDivisor = 255,
            isGraphics2 = true,
            is_iPad = false,
            titleBarHeight = 50,
            titleBarEdge = 10,
            titleBarTextColor = { r=255/255, g=255/255, b=255/255, a=1 },
            ------------------------------
            -- folders
            ------------------------------
            imgfld = "images/",
            htmlfld = "html/",
            myappadds = "myappadds.",
            scenesfld = "scenes.",
            utilsfld = "utils.",
            classfld = "classes.",

            ------------------------------
            -- database stuff
            ------------------------------            
            databasename= "insapp.db",
            hashkey = "aXaLwATgS3lPh848glLpugq5sqcHi8T2jfDQeWz1",

            theme = "widget_theme_ios7",
            font =  "HelveticaNeue-Light",
            fontBold = "HelveticaNeue",
            fontItalic = "HelveticaNeue-LightItalic",
            fontBoldItalic = "Helvetica-BoldItalic",
            sceneStartTop = 0,     -- set elsewhere
            sceneHeight = 0,     -- set elsewhere
            sceneWidth = 0,     -- set elsewhere
            sceneBackgroundcolor = { r=241/255, g=242/255, b=243/255, a=1 },
            sceneBackgroundmorecolor = { r=25/255, g=75/255, b=150/255, a=1 },
            scenemaskFile = "",
            splash = {image = "splash.jpg", delay = 150, },
            promptforphonecalls = true,


            composer = {
                          recycleOnSceneChange = false,
                          inoverlay = false,        -- our internal tracker
                       },


            webview = {
                         pageloadwaittime = 10000,
                         timeoutmessage = "Page taking too long to load.",
                     },
            lobinfo = {
                          default = {
                                   image = "lobdefault.png",
                              },
                          autop = {
                                   image = "lobautop.png",
                                   vehicles = true,
                              },
                          home = {
                                   image = "lobhome.png",
                              },
                          pumbr = {
                                   image = "lobpumbr.png",
                                   vehicles = true,
                              },
                           },
            docimages = {
                               default = {image ="docdefault.png",},
                               pdf = { image =  "pdf.png",  },          -- keep lower case !!!
 
                           },
            vehinfo = {
                               default = {
                                    image = "vehdefault.png",
                                    autoids = false,
                                       },
                               auto = {
                                    image = "vehauto.png",            -- keep lower case !!!}
                                    autoids = true,
                                      },
                               trailer = {
                                    image = "vehtrailer.png",            -- keep lower case !!!}
                                    autoids = false,
                                      },
                           },
            objecttypes = {
                        phone = {
                              launch="phone",
                              pic="phone.png",
                              title="Phone",
                              navigation = { systemurl = { url="tel:%s" },},
                            },
                        email = {
                              launch="email",
                              pic="email.png",
                              title="Email",
                              navigation = { popup = { type="mail" ,options={to="%s" },},},
                            },
                        sms = {
                              launch="sms",
                              pic="sms.png",
                              title="SMS Text",
                              navigation = { popup = { type="sms" ,options={to="%s" },},},
                            },
                        web = {
                              launch="web",
                              pic="web.png",
                              title="Web Site",
                              --navigation = { systemurl = { url="%s" },},


                              text="Sample web page",
                              backtext = "<",
                              forwardtext = ">",
                              -- htmlinfo = {
                              --               url="",    --- dyanamically changed
                              --             },
                             sceneinfo = { 
                                               htmlinfo = { url="", } ,  --- dyanamically changed  
                                               scrollblockinfo = { },
                                         },
                              navigation = { composer = {
                                         id = "", --- dyanamically changed
                                         lua="webview",
                                         time=250, 
                                         effect="slideLeft",
                                         effectback="slideRight",
                                      },},

                            },
                        facebook = {
                              launch="facebook",
                              pic="facebook.png",
                              title="Facebook",
                              navigation = { systemurl = { url="%s" },},
                            },
                        twitter = {
                              launch="twitter",
                              pic="twitter.png",
                              title="Twitter",
                              navigation = { systemurl = { url="%s" },},
                            },
                        directions = {
                              launch="directions",
                              pic="map.png",
                              title="Get Directions",
                              navigation = { directions = { address="%s" },},
                            },

                         -- xxdirections = {
                         --                  title = "Contact State Auto", 
                         --                  launch="directions",
                         --                  pic="truck.png",
                         --                  backtext = "<",
                         --                  sceneinfo = { 
                         --                       htmlinfo = {},
                         --                       scrollblockinfo = { object="contactus" , navigate = "subscene"},
                         --                               },
                         --                  navigation = { composer = { id = "contactus",lua="scrollblocks" ,time=250, effect="slideLeft" ,effectback="slideRight", },},
                         --              },


                           },    --objecttypes


            ------------------------------
            -- maps
            ------------------------------            
            maps = {
                      --googlemapapp = "comgooglemaps-x-callback://",
                      google = 
                             { 
                                 app = "comgooglemaps-x-callback://",
                                 directions = {
                                                 additions = "&directionsmode=driving",
                                              },
                                 search = {
                                                 additions = "&zoom=14",
                                              },
                            },
                      apple = 
                             {
                                 app = "http://maps.apple.com/",
                                 directions = {
                                                 additions = "",
                                              },
                                 search = {
                                                 additions = "",   --&spn=.50
                                              },
                             },
                   },
            ------------------------------
            -- gps
            ------------------------------            
            gps = {
                     --timer = 30000,                           --30 seconds
                     --timebetweenattempts = 100,              --1 seconds
                     --attempts = 0,                             -- cointer
                     --maxattempts = 10,                     
                     --event= "",                               -- set elsewhere
                     haveaccuratelocation = false ,               -- set elsewhere
                     currentlocation = {},                     -- set elsewhere
                     nearestaddress = {},                      -- set elsewhere
                     debug = {                                -- will be used if in debugmode
                                latitude=39.896311,
                                longitude=-82.7674464,
                              },
                     addresslocate = {
                                errortitle = "Not Valid Location",
                                errormessage = "Cannot Determine Location: ",
                                loadwaittime = 12000,
                                timeoutmessage = "Taking too long to determine location.",
                                    },
                     currentlocate = {
                                errortitle = "No GPS Signal",
                                errormessage = "Can't sync with GPS. Error: ",
                                    },
                     nearestlocate= {
                                errortitle = "Not Valid Address",
                                errormessage = "Cannot Determine Address: ",
                                loadwaittime = 5000,
                                timeoutmessage = "Taking too long to determine address.",
                                    },
                                  
                  },


            ------------------------------
            -- authentication
            ------------------------------            
            authentication = {
                                  loggedin = false,
                                  email="",
                                  emailVerified = false,
                                  username = "",
                                  objectId = "",       -- internal userid key
                                  sessionToken="",
                                  policies = {},
                                  agencies = {},
                                  agencycode = "",      -- will be first code if multiple policieis
                              },

            titleGradient = {
                    type = 'gradient',
                    color1 = { 189/255, 203/255, 220/255, 1 }, 
                    color2 = { 89/255, 116/255, 152/255, 1 },
                    direction = "down"
             },
            icons = "",
            iconinfo = 
               {
                       icondimensions = {
                              width = 40,
                              height = 40,
                              numFrames = 20,
                              sheetContentWidth = 200,
                              sheetContentHeight = 160
                              },
                        sheet = "ios7icons.png",
                },
            ------------------------------
            -- parse
            ------------------------------            
           parse = {
                        appId = 'nShcc7IgtlMjqroizNXtlVwjtwjfJgLsiRVgvUfA',
                        restApikey = 'DeOzYBpk6bBSha0SJ9cRUc36EbWUmuseajSyBrlF',
                        url = "https://api.parse.com/1",
                        -- endpoints = {
                        --                 config  = {
                        --                              endpoint = "/config",
                        --                              verb = "GET",
                        --                           },
                                 
                        --                 appopened  = {
                        --                              endpoint = "/events/AppOpened",
                        --                              verb = "POST",
                        --                           },
                        --                 customevent  = {
                        --                              endpoint = "/events",    -- pass in actual eventname
                        --                              verb = "POST",
                        --                           },


                        --           },
                    },


            --========================
            --== Device
            --========================
            deviceinfo = {
                            infoname = {name="name",title="Name"},
                            infoenvironment = {name="environment",title="Environment"},
                            infoplatformName = {name="platformName",title="Plat Name"},
                            infoplatformVersion = {name="platformVersion",title="Plat Version"},
                            infoversion = {name="version",title="Version"},
                            infobuild = {name="build",title="Corona BLD"},
                            infotextureMemoryUsed = {name="textureMemoryUsed",title="Memory Used"},
                            infoarchitectureInfo = {name="architectureInfo",title="Architecture"},
                            pref1 = {cat="ui",name="language",title="UI Lang"},
                            pref2 = {cat="locale",name="country",title="Loc Country"},
                            pref3 = {cat="locale",name="identifier",title="Loc ID"},
                            pref4 = {cat="locale",name="language",title="Loc Lang"},
                        },

            mydb = {   -- Databse info   other stuff will be added at startup
                      lCC  = {},    -- used to store user defaults from db record
                   },    -- 
  

        }
M.tabs     = require( M.myappadds .. "myapptabs" )  
M.moreinfo = require( M.myappadds .. "myappmoreinfo" )  
M.homepage = require( M.myappadds .. "myapphomepage" )  
M.contactus = require( M.myappadds .. "myappcontactus" )  
M.extras = require( M.myappadds .. "myappextras" )  
M.social = require( M.myappadds .. "myappsocial" )  
M.mappings = require( M.myappadds .. "myappmappings" )  
M.locate = require( M.myappadds .. "myapplocate" ).locate 
M.locatepre = require( M.myappadds .. "myapplocate" ).locatepre
M.locatedetails = require( M.myappadds .. "myapplocate" ).locatedetails
M.otherscenes = require( M.myappadds .. "myappotherscenes" ) 

 
return M
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