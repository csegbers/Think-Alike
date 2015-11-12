
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local moreinfo = { 
                      -- in items     showonlyindebugMode = true    showonlyinloggedin
                      imsliding = false,     -- will be updated in app
                      transitiontime = 700,
                      transitiontimealpha = 200,
                      direction = "left",     -- initial direction
                      movefactor = 1.2,      -- how much left or right. Less means less showing of the main screen
                      morebutton = {
                                      defaultFile="morebutton.png",
                                      overFile="morebutton-down.png",
                                      },
                      transparentcolor = { r=255/255, g=255/255, b=255/255, a=1 },
                      transparentalpha = .7,
                      row = {
                              over={ 1, 0.5, 0, 0.2 },
                              linecolor={ 200/255 },
                              height = 40,
                              indent = 25,
                              textcolor = 1,
                              textfontsize=16 ,
                              catheight = 30,
                              catcolor = { default={ 180 /255, 200/255, 230/255, 0.7} },
                            },
                      items = {

                               AAAlogin = {
                                   title = "Authentication", 
                                   isCategory = true,
                                      },
                               aalogout = {
                                   includeline  = false,       -- needed if prior is header otherwise it looks bad 
                                   title = "Logout", 
                                   showonlyinloggedin=true,
                                   pic="trustedchoice.png",
                                   originaliconwidth = 196,
                                   originaliconheight = 77,
                                   iconwidth = 120,      -- height will be scaled appropriately
                                   text="xxxxx",
                                   backtext = "<",
                                   --sceneinfo = { 
                                   --            htmlinfo = {},
                                   --            scrollblockinfo = { },
                                    --         },
                                   navigation = { execute = {  method = function() Runtime:dispatchEvent{ name="logmeout" } end, },},
                                           
                                       },
                              ablogin = {
                                   includeline  = false,       -- needed if prior is header otherwise it looks bad 
                                   title = "Login", 
                                   showonlyinloggedout=true,
                                   pic="trustedchoice.png",
                                   originaliconwidth = 196,
                                   originaliconheight = 77,
                                   iconwidth = 120,      -- height will be scaled appropriately
                                   text="xxxxx",
                                   backtext = "<",
                                   --sceneinfo = { 
                                   --            htmlinfo = {},
                                   --            scrollblockinfo = { },
                                    --         },
                                   navigation = { composer = {
                                               otherscenes = "login",
                                            },},
                                       },

                               bb0head = {
                                   title = "Support", 
                                   isCategory = true,
                                      },

                               bb31 = {
                                          title = "Contact State Auto", 
                                          pic="truck.png",
                                          backtext = "<",
                                          sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { object="contactus" , navigate = "subscene"},
                                             },
                                          navigation = { composer = { id = "contactus",lua="scrollblocks" ,time=250, effect="slideLeft" ,effectback="slideRight", },},
                                      },

 
                               bb4 = {title = "Help", 
                                           pic="truck.png",
                                           text="Flat tire, out of gas ? We can help",
                                           backtext = "<",

                                          sceneinfo = { 
                                                htmlinfo = {
                                                    htmlfile="help.html" ,
                                                    dir = system.ResourceDirectory ,
                                                },
                                               scrollblockinfo = { },
                                             },
                                          navigation = { composer = {
                                               id = "help",
                                               lua="webview",
                                               time=250, 
                                               effect="slideLeft",
                                               effectback="slideRight",
                                            },},
                                         },
                               bb5 = {title = "Terms", 
                                           pic="truck.png",
                                           text="Flat tire, out of gas ? We can help",
                                           backtext = "<",

                                          sceneinfo = { 
                                                htmlinfo = {
                                                    htmlfile="terms.html" ,
                                                    dir = system.ResourceDirectory ,
                                                },
                                               scrollblockinfo = { },
                                             },
                                          navigation = { composer = {
                                               id = "term",
                                               lua="webview",
                                               time=250, 
                                               effect="slideLeft",
                                               effectback="slideRight",
                                            },},
                                         },


                                   dtt= {title = "Privacy", 
                                    includeline  = false,
                                    pic="truck.png",
                                    text="Sample web page",
                                    backtext = "<",
                                          pic="truck.png",

                                            sceneinfo = { 
                                                htmlinfo = {
                                                    htmlfile="privacy.html" ,
                                                    dir = system.ResourceDirectory ,
                                                },
                                               scrollblockinfo = { },
                                             },
                                          navigation = { composer = {
                                               id = "yahooweb6",
                                               lua="webview",
                                               time=250, 
                                               effect="slideLeft",
                                               effectback="slideRight",
                                            },},
                                            
                                      },
                               xx0 = {
                                   title = "Settings", 
                                   isCategory = true,
                                      },
                               xx1 = {
                                   includeline  = false,       -- needed if prior is header otherwise it looks bad 
                                   title = "My Settings", 
                                   backtext = "<",
                                  -- groupheader = { r=15/255, g=75/255, b=100/255, a=1 },   -- can override
                                  sceneinfo = { 
                                                htmlinfo = { },
                                               scrollblockinfo = { },
                                             },
                                   navigation = { composer = {
                                               id = "mysettings",
                                               lua="settings",
                                               time=500, 
                                               effect="slideLeft",
                                               effectback="slideRight",
                                            },},
                                       },
                               zz0 = {
                                   title = "Extras", 
                                   isCategory = true,
                                      },

                               zz1 = {title = "Where Am I ?"  ,
                                     backtext = "<",
                                     navigation = { composer = {
                                               otherscenes = "whereami",
                                            },},
                                 },
                                 zz3 = {
                                          title = "Social Media", 
                                          backtext = "<",
                                          sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { object="social" , navigate = "subscene"},
                                             },
                                          navigation = { composer = { id = "social",lua="scrollblocks" ,time=250, effect="slideLeft" ,effectback="slideRight", },},
                                      },                                    
                                   
                                 zz4 = {
                                          title = "Other Extras", 
                                          backtext = "<",
                                          sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { object="extras" , navigate = "subscene"},
                                             },
                                          navigation = { composer = { id = "extras",lua="scrollblocks" ,time=250, effect="slideLeft" ,effectback="slideRight", },},
                                      },
                              -- zz5 = {title = "Home page"  ,
                              --        backtext = "<",
                              --        navigation = { tabbar = {
                              --                  key = "ahome",
                              --               },},

                                      
                              --     },
                              },  --items

     }
                        
        
return moreinfo