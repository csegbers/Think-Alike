
-------------------------------------------------------
-- Store variables used across the entire app 
-------------------------------------------------------
local otherscenes = {  
            login = {
                        loggedin = false,
                        sceneinfo = { 
                                     htmlinfo = {},
                                     scrollblockinfo = { },

                                     edge = 15,
                                     height = 220,
                                     cornerradius = 2,
                                     groupbackground = { r=235/255, g=235/255, b=235/255, a=1 },
                                     strokecolor = { r=150/255, g=150/255, b=150/255, a=1 },
                                     strokewidth = 1,

                                     userlabel = "Email Address",
                                     pwdlabel = "Password",

                                     textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                                     textfontsize=18  ,
                                     btnshape= "rect", --roundedRect",

                                     btncanceldefcolor = { r=160/255, g=160/255, b=160/255, a=1 },  
                                     btncancelovcolor = { r=130/255, g=130/255, b=130/255, a=1 }, 
                                     btncanceldeflabelcolor = { r=255/255, g=255/255, b=255/255, a=1 }, 
                                     btncancelovlabelcolor = { r=100/255, g=100/255, b=100/255, a=1 },  
                                     btncanceltext = "Cancel",

                                     btnlogindefcolor = { r=0/255, g=100/255, b=0/255, a=1 },  
                                     btnloginovcolor = { r=0/255, g=150/255, b=0/255, a=1 }, 
                                     btnlogindeflabelcolor = { r=255/255, g=255/255, b=255/255, a=1 }, 
                                     btnloginovlabelcolor = { r=230/255, g=230/255, b=230/255, a=1 },  
                                     btnlogintext = "Login",        
                                     btnloginmessage = {
                                          errortitle = "Invalid Entries", 
                                          errormessage = "Must have a valid email address and password entered.",
                                          --successtitle= "Logged In !!",
                                          --successmessage= "An email verification has been re-sent. Please follow the link in the email, return back and Login again to continue.",
                                          failuretitle= "Error With Your Request",
                                          verifytitle= "Correct Login But No Email Verification",
                                          verifymessage= "An email verification has been re-sent. Please check your email in a few minutes, follow the link in the email, return back and Login again to continue.",

                                      },                                     

                                     btnfontsize = 16,
                                     btnheight = 30,
                                     btnwidth = 90,

                                     userfieldfontsize=14  , 
                                     userfieldheight = 25,
                                     userfieldcornerradius = 6,
                                     userfieldplaceholder = "",
                                     userfieldmessage = {
                                          errortitle = "xxxx", 
                                          errormessage = "yyyy",
                                      },

                                     pwdfieldfontsize=14  , 
                                     pwdfieldheight = 25,
                                     pwdfieldcornerradius = 6,
                                     pwdfieldplaceholder = "",
                                     pwdfieldmessage = {
                                          errortitle = "xxxx", 
                                          errormessage = "yyyy",
                                      },

                                      showpwdswitchstyle = "onOff",

                                      btnforgotlabel = "Forgot Password" ,
                                      btnforgotllabelcolor = { default={ 0, 100/255, 200/255 }, over={ 0, 0, 0, 0.5 } },
                                      btnforgotfontsize=13  , 
                                      btnforgotmessage = {
                                          errortitle = "Invalid Entries", 
                                          errormessage = "Must have a valid email address to reset password",
                                          successtitle= "Email Sent",
                                          successmessage= "An email has been sent. Please follow the link in the email to reset your password, return back and Login again to continue.",
                                          failuretitle= "Error With Your Request",

                                      },


                                      btncreatelabel = "Create An Account" ,
                                      btncreatellabelcolor = { default={ 0, 100/255, 200/255 }, over={ 0, 0, 0, 0.5 } },
                                      btncreatefontsize=13  , 
                                      btncreatemessage = {
                                          errortitle = "Invalid Entries", 
                                          errormessage = "Must have a valid email address and password entered.",
                                          successtitle= "Congratulations !!",
                                          successmessage= "An email verification has been sent. Please follow the link in the email, return back and Login again to continue.",
                                          failuretitle= "Error With Your Request",

                                      },



                                   },
                        navigation = { composer = {
                                   id = "login",
                                   isModal = true,
                                   lua="login",
                                   overlay=true,
                                   time=700, 
                                   effect= "slideDown",
                                   effectback="slideUp",
                                },},
                    },

          emergency = {  
                           sceneinfo = {   
                                       groupheader = { r=255/255, g=0/255, b=0/255, a=1 },
                                       groupheight = 140,
                                       edge=10,
                                       textfontsize=14   ,  
                                       groupwidth = 120,
                                       groupmaxwidth = 170,     -- we will allow to grow to fit better if there is extra edging. This would be max however
                                       groupstrokewidth = 1,
                                       groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
                                       groupheaderheight = 35,
                                       headerfontsize = 17, 
                                       headercolor = { r=255/255, g=255/255, b=255/255, a=1 },

                                      dialbutton = {
                                                      defaultFile="dial911.png",
                                                      overFile="dial911-down.png",
                                                      width = 75,    
                                                       height = 75,  
                                                       dial = { navigation = { systemurl = { url="tel:911"},},},
                                                      },
                                  
                                      approxtext = "Approximate Address:" ,  
                                      calctext = "Calculating Address...." ,  
                                      unabletext = "Unable To Determine Address" ,       
                                      textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                                      textfontsize=16   , 
                                      textbottomedge =12   ,  
                                      map = {
                                                latitudespan = .01,
                                                longitudespan = .01,
                                                type = "hybrid" ,
                                            },

                                  },

                           navigation = { composer = {
                                         id = "emergency911",
                                         lua="locateme",
                                         time=250, 
                                         effect="slideLeft",
                                         effectback="slideRight",
                                      },},
                        },

          whereami = {  
                           sceneinfo = {   
                                       groupheader = { r=0/255, g=100/255, b=0/255, a=1 },
                                       groupheight = 140,
                                       edge=10,
                                       textfontsize=14   ,  
                                       groupwidth = 120,
                                       groupmaxwidth = 170,     -- we will allow to grow to fit better if there is extra edging. This would be max however
                                       groupstrokewidth = 1,
                                       groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
                                       groupheaderheight = 35,
                                       headerfontsize = 17, 
                                       headercolor = { r=255/255, g=255/255, b=255/255, a=1 },

                                      -- dialbutton = {
                                      --                 defaultFile="dial911.png",
                                      --                 overFile="dial911-down.png",
                                      --                 width = 75,    
                                      --                  height = 75,  
                                      --                  dial = { navigation = { systemurl = { url="tel:911"},},},
                                      --                 },
                                  
                                      approxtext = "Approximate Address:" ,  
                                      calctext = "Calculating Address...." ,  
                                      unabletext = "Unable To Determine Address" ,       
                                      textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                                      textfontsize=16   , 
                                      textbottomedge =12   ,  
                                      map = {
                                                latitudespan = .01,
                                                longitudespan = .01,
                                                type = "hybrid" ,
                                            },

                                  },

                           navigation = { composer = {
                                         id = "whereami",
                                         lua="locateme",
                                         time=250, 
                                         effect="slideLeft",
                                         effectback="slideRight",
                                      },},
                        },
              myaccount = {

                            functionname = {
                                       getpolicies = "getpoliciesforuser",
                                         },
                            groupwidth = 240,
                            groupmaxwidth = 320,     -- we will allow to grow to fit better if there is extra edging. This would be max however
                            groupheight = 120,
                            groupheaderheight = 30,
                            groupbetween = 10,
                            groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
                            
                            iconwidth = 60,    -- can be overidden in item
                            iconheight = 60,   -- can be overidden in item
                            headercolor = { r=255/255, g=255/255, b=255/255, a=1 },   
                           -- groupheader = { r=15/255, g=50/255, b=170/255, a=1 },
                            groupheader = {
                                      type = 'gradient',
                                      color1 = { 189/255, 203/255, 220/255, 1 }, 
                                      color2 = { 89/255, 116/255, 152/255, 1 },
                                      direction = "down"
                               },
                            headerfontsize = 15,  
                            textbottomedge =12  ,


                            textalignx = 70, 


                            nametextcolor = { r=140/255, g=130/255, b=30/255, a=1 },   
                            nametextfontsize=16   ,

                            balancelabelcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                            balancelabelfontsize=12 ,       
                            balancelabellabel = "Balance",

                            balancetextcolor = { r=50/255, g=130/255, b=60/255, a=1 },   
                            balancetextfontsize=12  ,       

                            policytextcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                            policytextfontsize=12   ,       
                            policytextlabel = "Policy Number: ",

                            termtextcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                            termtextfontsize=12   ,       
 
                            termtextlabel = "Coverage From: ",


                            shape="roundedRect",
                            addpolicybtntext = "+ Add A Policy To Your Account",
                            btncolor = { r=100/255, g=140/255, b=160/255, a=1 },
                            btndefaultcoloralpha = 1,
                            btnovercoloralpha = 0.3,
                            btnheight = 35,


                        },
              myagent = {    
                                animation=false,
                                animationtime=300,
                                edge=10,
                                groupheight = 90,
                                groupbackground = { r=25/255, g=75/255, b=150/255, a=1 },

                                groupstrokewidth = 0,
                                cornerradius = 3,

                                textcolor = { r=255/255, g=255/255, b=255/255, a=1 },   
                                textfontsize=18  ,   
                                textbottomedge =5   ,
                                textfontsizeaddress=14  ,  
                                textcoloraddress = { r=200/255, g=200/255, b=200/255, a=1 },   

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

            policyadd = {
                       functionname = {
                                       addpolicy =   "addpolicyforuser",
                                         },
                        sceneinfo = { 
                                     htmlinfo = {},
                                     scrollblockinfo = { },

                                     edge = 15,
                                     height = 250,
                                     cornerradius = 2,
                                     groupbackground = { r=235/255, g=235/255, b=235/255, a=1 },
                                     strokecolor = { r=150/255, g=150/255, b=150/255, a=1 },
                                     strokewidth = 1,

                                     policylabel = "Policy Number",
                                     ziplabel = "Policy Zip Code",
                                     seclabel = "Security Code",

                                     textcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                                     textfontsize=18  ,
                                     btnshape= "rect", --roundedRect",

                                     btncanceldefcolor = { r=160/255, g=160/255, b=160/255, a=1 },  
                                     btncancelovcolor = { r=130/255, g=130/255, b=130/255, a=1 }, 
                                     btncanceldeflabelcolor = { r=255/255, g=255/255, b=255/255, a=1 }, 
                                     btncancelovlabelcolor = { r=100/255, g=100/255, b=100/255, a=1 },  
                                     btncanceltext = "Cancel",

                                     btnadddefcolor = { r=0/255, g=100/255, b=0/255, a=1 },  
                                     btnaddovcolor = { r=0/255, g=150/255, b=0/255, a=1 }, 
                                     btnadddeflabelcolor = { r=255/255, g=255/255, b=255/255, a=1 }, 
                                     btnaddovlabelcolor = { r=230/255, g=230/255, b=230/255, a=1 },  
                                     btnaddtext = "Add",        
                                     btnaddmessage = {
                                          errortitle = "Invalid Entries", 
                                          errormessage = "Must have a valid Policy Number, Zip Code and Security Code entered.",
                                          errortitleuser = "Not Valid User", 
                                          errormessageuser = "Must be a valid logged in and verified user.",
                                          --successtitle= "Logged In !!",
                                          --successmessage= "An email verification has been re-sent. Please follow the link in the email, return back and Login again to continue.",
                                          failuretitle= "Error With Your Request",
                                      },                                     

                                     btnfontsize = 16,
                                     btnheight = 30,
                                     btnwidth = 90,

                                     policyfieldfontsize=14  , 
                                     policyfieldheight = 25,
                                     policyfieldcornerradius = 6,
                                     policyfieldplaceholder = "",
                                     policyfieldmessage = {
                                          errortitle = "xxxx", 
                                          errormessage = "yyyy",
                                      },

                                     zipfieldfontsize=14  , 
                                     zipfieldheight = 25,
                                     zipfieldcornerradius = 6,
                                     zipfieldplaceholder = "",
                                     zipfieldmessage = {
                                          errortitle = "xxxx", 
                                          errormessage = "yyyy",
                                      },

                                     secfieldfontsize=14  , 
                                     secfieldheight = 25,
                                     secfieldcornerradius = 6,
                                     secfieldplaceholder = "",
                                     secfieldmessage = {
                                          errortitle = "xxxx", 
                                          errormessage = "yyyy",
                                      },


                                   },
                        navigation = { composer = {
                                   id = "policyadd",
                                   isModal = true,
                                   lua="policyadd",
                                   overlay=true,
                                   time=700, 
                                   effect= "slideDown",
                                   effectback="slideUp",
                                },},
                    },  

          policydetails = {  

                           functionname = {
                                       getdocuments= "getdocsforpolicy",
                                       getvehicles = "getvehsforpolicy",
                                         },

                            backtext = "<",
  
                            edge=10,



                            groupwidth = 240,
                            groupmaxwidth = 320,     -- we will allow to grow to fit better if there is extra edging. This would be max however
                            groupheight = 110,
                            groupheaderheight = 30,
                            groupbetween = 10,
                            groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
                            
                            iconwidth = 60,    -- can be overidden in item
                            iconheight = 60,   -- can be overidden in item
                            headercolor = { r=255/255, g=255/255, b=255/255, a=1 },   
                           -- groupheader = { r=15/255, g=50/255, b=170/255, a=1 },
                            groupheaderstyle = {
                                      type = 'gradient',
                                      color1 = { 189/255, 203/255, 220/255, 1 }, 
                                      color2 = { 89/255, 116/255, 152/255, 1 },
                                      direction = "down"
                               },
                            headerfontsize = 15,  
                            textbottomedge =12  ,
                            textalignx = 70, 

                            tableheight=280,
                            row={
                                       height=50,
                                       rowColor = { 1, 1, 1 },
                                       lineColor = { 220/255 },
                                       textfontsize = 12,
                                       indent = 50,
                                       textColor = 0,

                                       catheight = 30,
                                       catColor = { default={ 180/255, 180/255, 180/255 } }, --s
                                       catlineColor = { r=255/255, g=255/255, b=255/255, a=0 },
                                       cattextcolor = 255/255,
                                       cattextfontsize = 14,
                                       catindent = 10,

                                       iconwidth = 30,
                                       iconheight = 30,
                                       
 
                                    },

                            nametextcolor = { r=140/255, g=130/255, b=30/255, a=1 },   
                            nametextfontsize=16   ,

                            balancelabelcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                            balancelabelfontsize=12 ,       
                            balancelabellabel = "Balance",

                            balancetextcolor = { r=50/255, g=130/255, b=60/255, a=1 },   
                            balancetextfontsize=12  ,       

                            policytextcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                            policytextfontsize=12   ,       
                            policytextlabel = "Policy Number: ",

                            termtextcolor = { r=1/255, g=1/255, b=1/255, a=1 },   
                            termtextfontsize=12   ,       
 
                            termtextlabel = "Coverage From: ",

                            shape="roundedRect",
                            
                            claimsbtntext = "Claims >",
                            btncolor = { r=100/255, g=140/255, b=160/255, a=1 },
                            btndefaultcoloralpha = 1,
                            btnovercoloralpha = 0.3,
                            btnheight = 35,

                            makepaymentbtntext = "Make A Payment >",
                            makepaymentinfo = {title = "Make A Payment", 
                                              pic="web.png",
                                              text="Make A Payment",
                                              backtext = "<",
                                              forwardtext = ">",
                                             sceneinfo = { 
                                                               htmlinfo = {url="https://secure4.billerweb.com/sai/JustPayIt/jpt.do" ,},
                                                               scrollblockinfo = { },
                                                             },
                                              navigation = { composer = {
                                                   id = "makepayment",
                                                   lua="webview",
                                                   time=250, 
                                                   effect="slideLeft",
                                                   effectback="slideRight",
                                                },},
                                
                                },
                            displaydocument = {title = "Document", 
                                              pic="web.png",
                                              text="Document",
                                              backtext = "<",
                                              --forwardtext = ">",
                                              sceneinfo = { 
                                                               htmlinfo = {url="",},     --- must supply
                                                               scrollblockinfo = { },
                                                             },
                                              navigation = { composer = {
                                                   id = "Document",
                                                   lua="webview",
                                                   time=250, 
                                                   effect="slideLeft",
                                                   effectback="slideRight",
                                                },},
                                
                                },
                            displayautoid = {title = "Auto Id", 
                                              pic="vehauto.png",
                                              text="Auto Id",
                                              backtext = "<",
                                              --forwardtext = ">",
                                              objectId = nil,     -- must be set by launcher. Will be the unique veh id. Notthe vin
                                              sceneinfo = { 
                                                               htmlinfo = { },     --- must supply
                                                               scrollblockinfo = { },
                                                             },
                                              navigation = { composer = {
                                                   id = "autoid",
                                                   lua="autoid",
                                                   time=250, 
                                                   effect="slideLeft",
                                                   effectback="slideRight",
                                                },},
                                
                                },
                            navigation = { composer = {
                                         id = "poldetails",
                                         lua="policydetails",
                                         time=250, 
                                         effect="slideLeft",
                                         effectback="slideRight",
                                      },},
                        },     

          autoid = {  
                            groupicon = "sagroup.png",
                            inneredge=1,
                            edge=5,
                            headercolor = { r=1/255, g=1/255, b=1/255, a=1 }, 
                            headerfontsize = 15, 
                            headerfontsizelarge = 17, 
                            headerfontsizesmall = 9, 
                            autoidtext = "INSURANCE IDENTIFICATION CARD",
                            backtext = "<",
                            iconwidth = 50,    -- can be overidden in item
                            iconheight = 50,   -- can be overidden in item
                            groupbackground = { r=255/255, g=255/255, b=255/255, a=1 },
                            


                        },                 
               
   
          }
return otherscenes