
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local contactus = { 

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

                          -- ccc = {title = "Roadside Assistance", pic="towing.png",text="Locate nearby towing services" ,
                          --      navigation = { search = { q="Towing" },},
                                      
                          --         },


                               -- bb5 = {title = "video", 
                               --             pic="video.png",
                               --             text="Flat tire, out of gas ? We can help",
                               --             backtext = "<",

                               --            sceneinfo = { 
                               --                  htmlinfo = {
                               --                      youtubeid="6EKIB8vhki8" ,
                               --                  },
                               --                 scrollblockinfo = { },
                               --               },
                               --            navigation = { composer = {
                               --                 id = "term",
                               --                 lua="webview",
                               --                 time=250, 
                               --                 effect="slideLeft",
                               --                 effectback="slideRight",
                               --              },},
                               --           },
                     aaa = {title = "Call State Auto", pic="phone.png",text="State Auto Main Phone Line" ,
                             doublewide=true, 
                             textfontsize=18   ,   
                             groupheaderheight = 30, 
                              groupheaderstyle = {
                                      type = 'gradient',
                                      color1 = { 189/255, 203/255, 220/255, 1 }, 
                                      color2 = { 89/255, 116/255, 152/255, 1 },
                                      direction = "down"
                               },
                             headerfontsize = 16 ,
                             navigation = { systemurl = { url="tel:614-464-5000"},},
                                    
                                },

                      bbb = {title = "Live Chat", 
                              pic="livechat.png",
                              text="Chat live with a State Auto representative",
                              backtext = "<",
                             -- forwardtext = ">",

                             sceneinfo = { 
                                  htmlinfo = {     url="https://stateauto.webex.com/stateauto/supportcenter/webacd.wbx?WQID=e29ea21658790f784c1ca0a97c85bbf8" , },
                                 scrollblockinfo = { },
                                             },
                              navigation = { composer = {
                                   id = "stateautochat",
                                   lua="webview",
                                   time=250, 
                                   effect="slideLeft",
                                   effectback="slideRight",
                                },},
                                
                                },
                      ccc = {title = "Billing Questions", pic="billing.png",text="Call for billing questions" ,
                               navigation = { systemurl = { url="tel:800-444-9950"},},
                                      
                                  },


                     ddd = {title = "Report A Claim", pic="claim.png",text="Call The 24 Hour Claim Contact Center" ,
                               --doublewide=true,
                               groupheader = { r=1/255, g=1/255, b=1/255, a=1 },
                               navigation = { systemurl = { url="tel:800-766-1853"},},
                                      
                                  },
                    eee = {title = "Report A Glass Claim", pic="claimglass.png",text="For Auto Glass Only Claims" ,
                               groupheader = { r=1/255, g=1/255, b=1/255, a=1 },
                               navigation = { systemurl = { url="tel:888-504-4527"},},
                                      
                                  },
                       fff = {title = "Report Fraud", pic="fraud.png",text="Anonomously call to report fraud" ,
                               groupheader = { r=1/255, g=1/255, b=1/255, a=1 },
                               navigation = { systemurl = { url="tel:888-999-8037"},},
                                      
                                  },
                     ggg = {
                                  title = "Social Media", 
                                  --doublewide=true,
                                  pic="socialmedia.png",
                                  text="State Auto On Social Media",
                                  iconwidth = 90,      -- height will be scaled appropriately
                                  groupheader = { r=90/255, g=50/255, b=90/255, a=1 },
                                  backtext = "<",
                                  sceneinfo = { 
                                       htmlinfo = {},
                                       scrollblockinfo = { object="social" , navigate = "subscene"},
                                     },
                                  navigation = { composer = { id = "social",lua="scrollblocks" ,time=250, effect="slideLeft" ,effectback="slideRight", },},
                              },   

                       hhh = {title = "State Auto Web", 
                              pic="web.png",
                              text="State Auto Main Website",
                              backtext = "<",
                              forwardtext = ">",

                             sceneinfo = { 
                                  htmlinfo = {     url="http://www.stateauto.com/" , },
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

                            -- dtt= {title = "CNN Launch separate", 
                            --   pic="web.png",
                            --   text="Sample web page",
                            --   backtext = "<",
                            --   navigation = { systemurl = {
                            --        url="http://www.cnn.com/"
                            --     },},
                                      
                            --     },


                          -- eb44 = {title = "Nearby gas stations", pic="gas.png",text="Locate nearby gas stations" ,
                          --      navigation = { search = { q="Gas Station" },},
                                      
                          --         },
                         iii = {title = "Email State Auto", pic="email.png",text="Email State Auto your question", 
                               navigation = { popup = { type="mail", options= {to="webmaster@stateauto.com", subject="General Question"},},},
                                 },

                          jjj= {title = "Text", pic="sms.png",text="Text State Auto your question" ,
                               navigation = { popup = { type="sms",options= {to="614-464-5000"},},},
                                      
                                  },

                          kkk = {title = "Directions - State Auto", pic="map.png",text="Get Directions To The State Auto Home Office" ,
                               navigation = { directions = { address="518 E Broad St Columbus Ohio 43215" },},
                                      
                                  },
                     },   --items
            }
      
return contactus