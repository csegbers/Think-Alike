
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local social = { 

--------------------------------------------------------
-- note: physical order of items does not matter. 
-- Order is based on alphabetical based on key 
--------------------------------------------------------

            groupwidth = 120,
            groupmaxwidth = 170,     -- we will allow to grow to fit better if there is extra edging. This would be max however
            groupheight = 140,
            groupheaderheight = 30,
            groupbetween = 10,
            --groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
            groupheader = { r=90/255, g=50/255, b=90/255, a=1 },
            groupbackgroundstyle = {
                                      type = 'gradient',
                                      color1 = { 250/255, 225/255, 250/255, 1 }, 
                                      color2 = { 250/255, 250/255, 250/255, 1 },
                                      direction = "down"
                               },
            iconwidth = 60,    -- can be overidden in item
            iconheight = 60,   -- can be overidden in item
            headercolor = { r=255/255, g=255/255, b=255/255, a=1 },   
            headerfontsize = 16,  
            textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
            textfontsize=18   ,       
            textbottomedge =12   ,           
            items = { 

                          aaa= {title = "State Auto Twitter", 
                              pic="twitter.png",
                              text="State Auto Twitter Feed",
                              doublewide=true,
                              backtext = "<",
                             navigation = { app = {
                                    url="twitter://user?screen_name=StateAuto",
                                    urlfallback = "https://www.twitter.com/stateauto",
                                 },},
                                
                                },
                          bbb= {title = "State Auto Facebook", 
                              pic="facebook.png",
                              text="State Auto Facebook Page",
                              doublewide=true,
                              backtext = "<",
                            navigation = { app = {
                                    url="fb://profile/125377646434",
                                    urlfallback = "https://www.facebook.com/stateauto",
                                 },},
                                
                                },
                           ccc= {title = "State Auto Youtube", 
                              pic="youtube.png",
                              text="State Auto Youtube Channel",
                              doublewide=true,
                              backtext = "<",
                            navigation = { systemurl = {
                                    url="https://www.youtube.com/StateAutoInsurance",
                                 },},
                                
                                },
            },

            
          }
      
return social