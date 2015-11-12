
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local homepage = { 

--------------------------------------------------------
-- note: physical order of items does not matter. 
-- Order is based on alphabetical based on key 
--------------------------------------------------------

            groupwidth = 120,
            groupmaxwidth = 170,     -- we will allow to grow to fit better if there is extra edging. This would be max however
            groupheight = 140,
            groupheaderheight = 20,
            groupbetween = 10,
            groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
            groupheader = { r=25/255, g=75/255, b=150/255, a=1 },

            iconwidth = 60,    -- can be overidden in item
            iconheight = 60,   -- can be overidden in item
            headercolor = { r=255/255, g=255/255, b=255/255, a=1 },   
            headerfontsize = 13,  
            textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
            textfontsize=12   ,       
            textbottomedge =12   ,           
            items = {
                        aaaaa = {
                             title = "Locate An Agent", 
                              
                             pic="trustedchoice.png",
                             originaliconwidth = 196,
                             originaliconheight = 77,
                             iconwidth = 120,      -- height will be scaled appropriately
                             text="Locate agents nearby or from an address",
                             backtext = "<",
                             --groupheader = { r=15/255, g=75/255, b=100/255, a=1 },   -- can override

                             sceneinfo = { 
                                            locateinfo = {
                                                limit=100,
                                                miles=25,
                                                object = "Agency", --- used for mapping and other web services
                                              },
                                               htmlinfo = {},
                                               scrollblockinfo = { },
                                             },
                             navigation = { composer = {
                                         id = "alocate1",
                                         lua="locatepre",
                                         time=250, 
                                         effect="slideLeft",
                                         effectback="slideRight",
                                      },},
                                 },
                         bbbbb = {title = "Certified Repair Shops", 
                                     pic="qsg.png",
                                      
                                     text="Locate certified repair shops nearby",
                                     backtext = "<",
                                     sceneinfo = { 
                                             locateinfo = {
                                                    limit=100,
                                                    miles=10,
                                                    object = "BodyShop", --- used for mapping and other web services
                                                  },
                                               htmlinfo = {},
                                               scrollblockinfo = { },
                                             },
                                    navigation = { composer = {
                                         id = "alocateqsg",
                                         lua="locatepre",
                                         time=250, 
                                         effect="slideLeft",
                                         effectback="slideRight",
                                      },},
                                   },
                         ccccc = {title = "Emergency" , pic="emergency.png",text="Click here for location services and to dial 911" ,
                                     backtext = "<",
                                    
                                     groupheader = { r=255/255, g=0/255, b=0/255, a=1 },
                                    -- sceneinfo = { 
                                          --     htmlinfo = {},
                                          --     scrollblockinfo = { },
                                          --   },
                                     navigation = { composer = {
                                               otherscenes = "emergency",
                                            },},

                                      
                                  },
                          ddddd = {title = "State Auto Website", 
                              pic="web.png",
                              text="Go to State Auto's website",
                              backtext = "<",
                              forwardtext = ">",
                             sceneinfo = { 
                                               htmlinfo = {url="http://www.stateauto.com/" ,},
                                               scrollblockinfo = { },
                                             },
                              navigation = { composer = {
                                   id = "stateautoweb",
                                   lua="webview",
                                   time=250, 
                                   effect="slideLeft",
                                   effectback="slideRight",
                                },},
                                
                                },
                            -- dtt= {title = "Get A Quote", 
                            --   pic="web.png",
                            --   text="Get A Quote For Your Personal Insurance",
                            --   backtext = "<",
                            --   navigation = { systemurl = {
                            --        url="https://www.trustedchoice.com/find-an-agent/personal/"
                            --     },},
                                      
                            --     },

                          -- eeeee = {title = "Roadside Assistance", pic="towing.png",text="Locate nearby towing services" ,
                          --      groupheader = { r=40/255, g=90/255, b=40/255, a=1 },
                          --      navigation = { search = { q="Towing" },},
                                      
                          --         },

                          -- fffff = {title = "Nearby Gas Stations", pic="gas.png",text="Locate nearby gas stations" ,
                          --     groupheader = { r=40/255, g=90/255, b=40/255, a=1 },
                          --      navigation = { search = { q="Gas Station" },},
                                      
                                  -- },
                           -- ec3t = {title = "Directions to segbers", pic="map.png",text="Get directions to segber shouse" ,showonlyindebugMode=true,
                           --     navigation = { directions = { address="12293 Mallard Pond Ct Pickerington Ohio 43147" },},
                                      
                           --        },
                           -- et3t = {title = "Phone Call", pic="phone.png",text="Flat tire, out of gas ? We can help" ,
                           --     navigation = { systemurl = { url="tel:614-915-9769"},},
                                      
                           --        },
                           -- ey3t = {title = "Text", pic="sms.png",text="send a text" ,
                           --     navigation = { popup = { type="sms",options= {to="614-915-9769"},},},
                                      
                           --        },
                         -- fttt = {title = "Mail", pic="email.png",text="Flat tire, out of gas ? We can help", 
                         --       navigation = { popup = { type="mail", options= {to="nobody@mycompany.com", subject="hi there"},},},
                         --         },
                         ggggg= {
                                          title = "Contact State Auto", 
                                          pic="saicon-down.png",
                                          doublewide = true,
                                          backtext = "<",
                                           text="Contact Options For State Auto",
                                           textfontsize=18   ,
                                           groupheaderheight = 30, 
                                           headerfontsize = 16,
                                    groupheaderstyle = {
                                      type = 'gradient',
                                      color1 = { 189/255, 203/255, 220/255, 1 }, 
                                      color2 = { 89/255, 116/255, 152/255, 1 },
                                      direction = "down"
                               },
                                          groupbackgroundstyle = {
                                      type = 'gradient',
                                      color1 = { 189/255, 203/255, 220/255, 1 }, 
                                      color2 = { 89/255, 116/255, 152/255, 1 },
                                      direction = "down"
                               },
                                          sceneinfo = { 
                                               htmlinfo = {},
                                               scrollblockinfo = { object="contactus" , navigate = "subscene"},
                                             },
                                          ---------------------------
                                          -- note if calling same lua from same lua... effect wont do much of course
                                          ---------------------------
                                          navigation = { composer = { id = "contactus",lua="scrollblocks" ,time=250, effect="slideLeft" ,effectback="slideRight",},},
                                      },

                     },   --items
            }
      
return homepage