
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local M = { 

             locatepre = {    

                                edge=10,
                                groupheight = 130,
                                groupheaderheight = 40,
                                groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
                                groupstrokewidth = 1,
                                groupheader = { r=25/255, g=75/255, b=150/255, a=1 },
                                iconwidth = 60,    -- can be overidden in item
                                iconheight = 60,   -- can be overidden in item
                                headercolor = { r=255/255, g=255/255, b=255/255, a=1 },   
                                headerfontsize = 17,  
                                textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                                textfontsize=16  ,   
                                textbottomedge =2   ,  
                                shape="roundedRect",
                                curlocbtntext = "Use Current Location",
                                btndefaultcoloralpha = 0.7,
                                btnovercoloralpha = 0.3,
                                btnheight = 35,
                                milerange = {low=5,high=100},
                                lua="locate",
                                effect="slideLeft",
                                effectback="slideRight",

                                addresstextfontsize=14  , 
                                addressbtntext= "Use Location Entered Below",
                                addressfieldheight = 50,
                                addressfieldcornerradius = 6,
                                addressfieldplaceholder = "Enter zip, city/state or address",
                                addresslocate = {
                                       errortitle = "Location Not Entered", 
                                       errormessage = "Please Enter A Valid Location",
                                                },
                                 
                       },
             locate = {    
                                animation=true,
                                animationtime=300,
                                edge=10,
                                groupheight = 40,
                                groupbackground = { r=180/255, g=180/255, b=180/255, a=1 },
                                groupstrokewidth = 0,
                                cornerradius = 3,

                                textcolor = { r=255/255, g=255/255, b=255/255, a=1 },   
                                textfontsize=15  ,   
                                textbottomedge =2   ,

                                tableheight=180,  
                                row={
                                       height=60,
                                       rowColor = { 1, 1, 1 },
                                       lineColor = { 220/255 },
                                       nametextfontsize=16  , 
                                       nametexty = 15,
                                       nametextx = 10,
                                       nametextColor = 0,
                                       addresstextfontsize = 10,
                                       addresstexty= 40,
                                       addresstextx= 10,
                                       addressColor = 0.5,
                                       milestextfontsize = 13,
                                       milesColor = 0.5,
                                       milestexty = 45,
                                       milestextx = 210,
                                       arrowwidth = 40,
                                       arrowheight = 40,
                                    },
                                map = {
                                          latitudespan = .25,
                                          longitudespan = .25,
                                          type = "standard" ,
                                      },

                                 
                       },
             locatedetails = {    
                                animation=true,
                                animationtime=300,
                                edge=10,
                                groupheight = 90,
                                groupbackground = { r=220/255, g=220/255, b=220/255, a=1 },
                                groupstrokewidth = 0,
                                cornerradius = 3,

                                textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                                textfontsize=18  ,   
                                textbottomedge =5   ,
                                textfontsizeaddress=14  ,  
                                textcoloraddress = { r=130/255, g=130/255, b=130/255, a=1 },   

                                tableheight=180,  
                                row={
                                       height=60,
                                       rowColor = { 1, 1, 1 },
                                       lineColor = { 220/255 },
                                       titletextfontsize=16  , 
                                       titletexty = 20,
                                       titletextx = 60,
                                       titletextColor = 0,
                                       desctextfontsize=12  , 
                                       desctexty = 40,
                                       desctextx = 60,
                                       desctextColor = 0.5,

                                       iconwidth = 40,
                                       iconheight = 40,

                                       includedirections = true,

                                    },
                                map = {
                                          latitudespan = .1,
                                          longitudespan = .1,
                                          type = "standard" ,
                                      },

                                 
                       },

     }
                        
        
return M