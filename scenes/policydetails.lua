---------------------------------------------------------------------------------------
-- policy details scene
---------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myApp = require( "myapp" ) 

local parse = require( myApp.utilsfld .. "mod_parse" ) 
local common = require( myApp.utilsfld .. "common" )

local currScene = (composer.getSceneName( "current" ) or "unknown")
print ("Inxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " .. currScene .. " Scene")

local sceneparams
local sceneid
local sceneinfo

local runit  
local justcreated  

local container
local myList

local myName
local myAddress
local itemGrp

local polcurrentterm
local polgroup

------------------------------------------------------
-- Row is rendered
------------------------------------------------------
local  onRowRender = function ( event )

         --Set up the localized variables to be passed via the event table

         local row = event.row
         local id = row.index
         local params = row.params
         local textline1
         local textline2

         if ( event.row.params ) then    
               print ("in the row " .. (params.title or ""))

               if row.isCategory then 
                   row.nameText = display.newText( (params.title or ""), 0, 0, myApp.fontBold, sceneinfo.row.cattextfontsize )
                   row.nameText.anchorX = 0
                   row.nameText.anchorY = 0.5
               
                   row.nameText.y = row.height / 2
                   row.nameText.x = sceneinfo.row.catindent
                   row.nameText:setFillColor( sceneinfo.row.cattextcolor )
                   row:insert( row.nameText )
 
               else
                   if params.rowtype == "docimages" then
                       textline1 = (common.dateDisplayFromIso(params.docdate ) or "")
                       textline2 = (params.docdescription or "")
                   elseif params.rowtype == "vehinfo"  then
                       textline1 = ((params.vehyear or "").. "  " .. (params.vehmake or "") ..  " " .. (params.vehmodel or ""))
                       textline2 = "Vin: " .. params.vehvin
                   else
                       textline1 = "Unknown"
                       textline2 = "Unknown"
                   end

                    
                   row.nameText = display.newText( textline1, 0, 0, myApp.fontBold, sceneinfo.row.textfontsize )
                   row.nameText.anchorX = 0
                   row.nameText.anchorY = 0.5
               
                   row.nameText.y = row.height / 2 - row.nameText.height/2
                   row.nameText.x = sceneinfo.row.indent
                   row.nameText:setFillColor( sceneinfo.row.textcolor  )
                   row:insert( row.nameText )



                   row.nameText2 = display.newText( textline2, 0, 0, myApp.fontBold, sceneinfo.row.textfontsize )
                   row.nameText2.anchorX = 0
                   row.nameText2.anchorY = 0.5
               
                   row.nameText2.y = row.height / 2 + row.nameText.height/2
                   row.nameText2.x = sceneinfo.row.indent
                   row.nameText2:setFillColor( sceneinfo.row.textcolor  )
                   row:insert( row.nameText2 )

                    -- -------------------------------------------------
                    --    image of the object ?
                    --  -------------------------------------------------
                    local rowimage  =  myApp[params.rowtype][string.lower( (params.rowobject or "default") )].image
                    if rowimage == nil then
                        rowimage  =  myApp[params.rowtype].default.image
                    end
                    if rowimage then
                         row.myIcon = display.newImageRect(myApp.imgfld .. rowimage,  sceneinfo.row.iconwidth , sceneinfo.row.iconheight )
                         common.fitImage( row.myIcon,  sceneinfo.row.iconwidth   )
                         row.myIcon.y = sceneinfo.row.height / 2 
                         row.myIcon.x = sceneinfo.row.iconwidth/2 + sceneinfo.edge
                         row:insert( row.myIcon )
                    end

               end

               
 

         end
         return true
end
 
------------------------------------------------------
-- what launch object ?
------------------------------------------------------
local onRowTouch = function( event )
        local row = event.row
        local params = row.params

        
        if event.phase == "press"  then     

        elseif event.phase == "tap" then
              
        elseif event.phase == "swipeLeft" then

        elseif event.phase == "swipeRight" then
 
        elseif event.phase == "release" then

          
              local parentinfo =  sceneparams 
              if params.rowtype == "docimages" then
                  print ("doc file " .. params.docfileurl)
                  local doclaunch =  myApp.otherscenes.policydetails.displaydocument
                  doclaunch.navigation.composer.id =  sceneid .. params.id       --- keeps uniuq. If log out / in will ensure thius screen is refreshed since the sceneid is carried forward from a rando sequence
                  doclaunch.sceneinfo.htmlinfo.url =  params.docfileurl 
                  doclaunch.title =  (params.docdescription or "")
                  doclaunch.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
                  myApp.showSubScreen({instructions=doclaunch}) 
              elseif   params.rowtype == "vehinfo" then
                  ----------------------------
                  -- does the vehicle type support autoids ?
                  ----------------------------
                  local vehtypetable =  myApp[params.rowtype][string.lower( (params.rowobject or "default") )]  
                  local doautoids = false
                  if vehtypetable then
                      doautoids = (vehtypetable.autoids or false)
                  else
                      doautoids = (myApp[params.rowtype].default.autoids or false)
                  end
                  if doautoids then
                      print ("veh file " .. params.vehvin)
                      local vehlaunch =  myApp.otherscenes.policydetails.displayautoid
                      vehlaunch.navigation.composer.id =  sceneid .. params.id      --- this is the actual object id. WIll be different for each veh and same veh different per term so truly uniqe
                      vehlaunch.objectId = params.id 
                      vehlaunch.title =  ((params.vehyear or "").. "  " .. (params.vehmake or "") ..  " " .. (params.vehmodel or ""))
                      vehlaunch.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
                      myApp.showSubScreen({instructions=vehlaunch}) 
                  end

              end

        end
    return true
end

------------------------------------------------------
-- Called first time. May not be called again if we dont recyle
------------------------------------------------------
function scene:create(event)
 
    print ("Create  " .. currScene)
    justcreated = true
    sceneparams = event.params            
     
end

function scene:show( event )

    local group = self.view
    local phase = event.phase

    print ("Show:" .. phase.. " " .. currScene)

    ----------------------------------
    -- Will Show
    ----------------------------------
    if ( phase == "will" ) then   
        ----------------------------
        -- sceneparams at this point contains prior
        -- KEEP IT THAT WAY !!!!!
        --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ------------------------------
        -- Called when the scene is still off screen (but is about to come on screen).
        runit = true
        if sceneparams and justcreated == false then
          if  sceneparams.navigation.composer then
             --if sceneparams.navigation.composer.id == event.params.navigation.composer.id then
             if sceneid == event.params.navigation.composer.id then
               runit = false
             end
          end
        end

        ----------------------------
        -- now go ahead
        --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ------------------------------
        sceneparams = event.params  
        sceneid = sceneparams.navigation.composer.id       --- new field otherwise it is a refernce and some calls here send a reference so comparing id's is useless         
        sceneinfo = myApp.otherscenes.policydetails 

        ------------------------------------------------
        -- clear thing out for this luanhc
        ------------------------------------------------
        if (runit or justcreated) then 

             display.remove( container )           -- wont exist initially no biggie
             container = nil

             display.remove( myList )           -- wont exist initially no biggie
             myList = nil

             container  = common.SceneContainer()
             group:insert(container )

             ---------------------------------------------
             -- Header group
             -- text gets set in Show evvent
             ---------------------------------------------

             itemGrp = display.newGroup(  )
             local startX = 0

             -----------------------------------------
             -- polgroup will point to the primary policy info in the global cache for this policy
             -----------------------------------------
             polgroup = myApp.authentication.policies[sceneparams.policynumber]
       
             -----------------------------
             -- should have atleast that 1 term
             -----------------------------
             if #polgroup.policyTerms > 0 then
                 local col = 1
                 local row = 1
                 polcurrentterm = polgroup.policyTerms[1]    -- should be the current term as the rest service sorrted and we instered in order
                
                 print ("policy" .. sceneparams.policynumber .. polcurrentterm.policyinsuredname)
                --groupsPerRow   -- not really used on this screen

                 local groupheight = sceneinfo.groupheight
                 local groupwidth = sceneinfo.groupwidth                                -- starting width of the selection box
                 local workingScreenWidth = myApp.sceneWidth - sceneinfo.groupbetween   -- screen widh - the left edge (since each box would have 1 right edge)
                 local workingGroupWidth = groupwidth + sceneinfo.groupbetween          -- group width plus the right edge
                 local groupsPerRow = math.floor(workingScreenWidth / workingGroupWidth )    -- how many across can we fit
                 local leftWidth = myApp.sceneWidth - (workingGroupWidth*groupsPerRow )      -- width of the left edige
                 local leftY = (leftWidth) / 2 + (sceneinfo.groupbetween / 2 )          -- starting point of left box
                 local dumText = display.newText( {text="X",font= myApp.fontBold, fontSize=sceneinfo.textfontsize})
                 local textHeightSingleLine = dumText.height
                 display.remove( dumText )
                 dumText=nil

                 -------------------------------------------
                 -- lots of extra edging ? edging > space in between ?
                 -- expand the boxes but not beyond their max size
                 -------------------------------------------
                 if leftWidth > sceneinfo.groupbetween then
                    local origgroupwidth = groupwidth
                    groupwidth = groupwidth + ((leftWidth - sceneinfo.groupbetween) / groupsPerRow)   -- calcualte new group width
                    if groupwidth > sceneinfo.groupmaxwidth then                                      -- gone too far ? push back
                        groupwidth = sceneinfo.groupmaxwidth 
                        if groupwidth < origgroupwidth then groupwidth = origgroupwidth end                -- just incase someone puts the max > than original
                    end
                    workingGroupWidth = groupwidth +  sceneinfo.groupbetween                          -- calcualt enew total group width _ spacing
                    leftWidth = myApp.sceneWidth - (workingGroupWidth*groupsPerRow )                       -- recalce leftwdith and left starting point
                    leftY = (leftWidth) / 2 + (sceneinfo.groupbetween / 2 )
                 end


                 local  cellworkingGroupWidth = workingGroupWidth
                 local  cellgroupwidth = groupwidth 

                 ---------------------------------------------
                 -- lets create the group for the general info
                 ---------------------------------------------
                 local itemGrp = display.newGroup(  )
                 itemGrp.id = k
                 local startX =  0 
                 local startY =  0  - myApp.sceneHeight / 2  + groupheight / 2 + sceneinfo.groupbetween 


                 local textwidth = cellgroupwidth  - sceneinfo.textalignx  + 5
                 local textalignx = sceneinfo.textalignx * -1 - sceneinfo.groupbetween * 2
                 
                 -------------------------------------------------
                 -- Background
                 -------------------------------------------------
                 local myRoundedRect = display.newRoundedRect(startX, startY ,cellgroupwidth,  groupheight, 1 )
                 myRoundedRect:setFillColor(sceneinfo.groupbackground.r,sceneinfo.groupbackground.g,sceneinfo.groupbackground.b,sceneinfo.groupbackground.a )
                 itemGrp:insert(myRoundedRect)

                 -------------------------------------------------
                 -- Header Background
                 -------------------------------------------------
                 local startYother = startY- groupheight/2 + sceneinfo.groupbetween
                 local myRoundedTop = display.newRoundedRect(startX, startYother ,cellgroupwidth, sceneinfo.groupheaderheight, 1 )
                 --local headcolor = sceneinfo.groupheader
                 --myRoundedTop:setFillColor(headcolor.r,headcolor.g,headcolor.b,headcolor.a )
                 myRoundedTop:setFillColor(sceneinfo.groupheaderstyle)
                 itemGrp:insert(myRoundedTop)
                 
                 -------------------------------------------------
                 -- Header text
                 -------------------------------------------------
                 local myText = display.newText( sceneinfo.policytextlabel .. (polcurrentterm.policynumber or ""), 0, startYother,  myApp.fontBold, sceneinfo.headerfontsize )
                 myText:setFillColor( sceneinfo.headercolor.r,sceneinfo.headercolor.g,sceneinfo.headercolor.b,sceneinfo.headercolor.a )
                 myText.anchorX = 0
                 myText.x= textalignx
                 itemGrp:insert(myText)

                 -------------------------------------------------
                 -- Lob image ?
                 -------------------------------------------------

                 local lob = string.lower( (polcurrentterm.policylob or "default") )
                 local lobimage = nil
                 if myApp.lobinfo[lob]  then
                    lobimage = myApp.lobinfo[lob].image
                 else
                    lobimage = myApp.lobinfo["default"].image
                 end
                 if lobimage == nil then lobimage  =  myApp.lobinfo["default"].image end

                 if lobimage then
                     local myIcon = display.newImageRect(myApp.imgfld .. lobimage,  sceneinfo.iconwidth , sceneinfo.iconheight )
                     common.fitImage( myIcon,   sceneinfo.iconwidth   )
                     myIcon.x = startX - cellgroupwidth/2 + myIcon.width/2  
                     myIcon.y = startYother  + myIcon.height/2  - sceneinfo.groupheaderheight / 2
                     itemGrp:insert(myIcon)
                 end

                 -------------------------------------------------
                 -- Insured Name
                 -------------------------------------------------
                 local myName = display.newText( {text=(polcurrentterm.policyinsuredname or ""), x=0, y=0, height=0,width=textwidth,font= myApp.fontBold, fontSize=sceneinfo.nametextfontsize,align="left" })
                 myName:setFillColor( sceneinfo.nametextcolor.r,sceneinfo.nametextcolor.g,sceneinfo.nametextcolor.b,sceneinfo.nametextcolor.a )
                 myName.anchorX = 0
                 myName.anchorY = 0
                 myName.x= textalignx
                 myName.y=startYother + sceneinfo.groupheaderheight 
                 itemGrp:insert(myName)


                 -------------------------------------------------
                 -- Balance label
                 -------------------------------------------------       
                 local myBalanceLabel = display.newText( {text=sceneinfo.balancelabellabel  , x=0, y=0, height=0,font= myApp.fontBold, fontSize=sceneinfo.balancelabelfontsize })
                 myBalanceLabel:setFillColor( sceneinfo.balancelabelcolor.r,sceneinfo.balancelabelcolor.g,sceneinfo.balancelabelcolor.b,sceneinfo.balancelabelcolor.a )
                 myBalanceLabel.x=startX - cellgroupwidth/2 + sceneinfo.iconwidth /2  
                 myBalanceLabel.y=myName.y + 20
                 itemGrp:insert(myBalanceLabel)

                 -------------------------------------------------
                 -- Balance
                 -------------------------------------------------
                 local myBalanceText = display.newText( {text=string.format("%6.2f",(polcurrentterm.policydue or "") ) , x=0, y=0, height=0,font= myApp.fontBold, fontSize=sceneinfo.balancetextfontsize })
                 myBalanceText:setFillColor( sceneinfo.balancetextcolor.r,sceneinfo.balancetextcolor.g,sceneinfo.balancetextcolor.b,sceneinfo.balancetextcolor.a )
                 myBalanceText.x=myBalanceLabel.x
                 myBalanceText.y=myBalanceLabel.y + myBalanceLabel.height  
                 itemGrp:insert(myBalanceText)

                 -- -------------------------------------------------
                 -- -- POlicy Number 
                 -- -------------------------------------------------
                 
                 -- local myPolicy = display.newText( {text=sceneinfo.policytextlabel .. (polcurrentterm.policynumber or ""), x=0, y=0, height=0,width=textwidth,font= myApp.fontBold, fontSize=sceneinfo.policytextfontsize,align="left" })
                 -- myPolicy:setFillColor( sceneinfo.policytextcolor.r,sceneinfo.policytextcolor.g,sceneinfo.policytextcolor.b,sceneinfo.policytextcolor.a )
                 -- myPolicy.anchorX = 0
                 -- myPolicy.anchorY = 0.5
                 -- myPolicy.x= textalignx
                 -- myPolicy.y=myName.y + myName.height  + 10
                 -- itemGrp:insert(myPolicy)


                 -------------------------------------------------
                 -- Terms
                 -------------------------------------------------
                 local effdate = common.dateDisplayFromIso(polcurrentterm.effdate )
                 local expdate = common.dateDisplayFromIso(polcurrentterm.expdate )
                 
                 local myTerm = display.newText( {text=sceneinfo.termtextlabel .. (effdate or "") .. " To " .. (expdate or "") , x=0, y=0, height=0,width=textwidth,font= myApp.fontBold, fontSize=sceneinfo.termtextfontsize,align="left" })
                 myTerm:setFillColor( sceneinfo.termtextcolor.r,sceneinfo.termtextcolor.g,sceneinfo.termtextcolor.b,sceneinfo.termtextcolor.a )
                 myTerm.anchorX = 0
                 myTerm.anchorY = 0.5
                 myTerm.x= textalignx
                 myTerm.y=myName.y + myName.height  + 10
                 itemGrp:insert(myTerm)

                 -------------------------------------------------
                 -- Make a payment button
                 -------------------------------------------------
                 makepaymentButton = widget.newButton {
                        shape=sceneinfo.shape,
                        fillColor = { default={ sceneinfo.btncolor.r, sceneinfo.btncolor.g, sceneinfo.btncolor.b , sceneinfo.btndefaultcoloralpha}, over={ sceneinfo.btncolor.r, sceneinfo.btncolor.g, sceneinfo.btncolor.b, sceneinfo.btnovercoloralpha } },
                        label = sceneinfo.makepaymentbtntext,
                        labelColor = { default={ sceneinfo.headercolor.r,sceneinfo.headercolor.g,sceneinfo.headercolor.b }, over={ sceneinfo.headercolor.r,sceneinfo.headercolor.g,sceneinfo.headercolor.b, sceneinfo.btnovercoloralpha } },
                        fontSize = sceneinfo.headerfontsize,
                        font = myApp.fontBold,
                        width = cellgroupwidth / 2 - sceneinfo.groupbetween ,
                        height = sceneinfo.btnheight,
                        x = 0,
                        y = startY + groupheight/2 + sceneinfo.btnheight/2 + sceneinfo.groupbetween,

                        onRelease = function() 
                                      local parentinfo =  sceneparams 
                                      local paylaunch =  myApp.otherscenes.policydetails.makepaymentinfo
                                      paylaunch.navigation.composer.id = (polcurrentterm.policynumber or "")
                                      paylaunch.title = "Pay: " .. (polcurrentterm.policynumber or "")
                                      paylaunch.callBack = function() myApp.showSubScreen({instructions=parentinfo,effectback="slideRight"}) end
                                      myApp.showSubScreen({instructions=paylaunch}) 

                                     end,
                      }
                 makepaymentButton.x = 0 - makepaymentButton.width/2 - sceneinfo.groupbetween
                 container:insert(makepaymentButton)

                 -------------------------------------------------
                 -- Claims info
                 -------------------------------------------------
                 claimsButton = widget.newButton {
                        shape=sceneinfo.shape,
                        fillColor = { default={ sceneinfo.btncolor.r, sceneinfo.btncolor.g, sceneinfo.btncolor.b , sceneinfo.btndefaultcoloralpha}, over={ sceneinfo.btncolor.r, sceneinfo.btncolor.g, sceneinfo.btncolor.b, sceneinfo.btnovercoloralpha } },
                        label = sceneinfo.claimsbtntext,
                        labelColor = { default={ sceneinfo.headercolor.r,sceneinfo.headercolor.g,sceneinfo.headercolor.b }, over={ sceneinfo.headercolor.r,sceneinfo.headercolor.g,sceneinfo.headercolor.b, sceneinfo.btnovercoloralpha } },
                        fontSize = sceneinfo.headerfontsize,
                        font = myApp.fontBold,
                        width = cellgroupwidth / 2 - sceneinfo.groupbetween ,
                        height = sceneinfo.btnheight,
                        x = 0,
                        y = makepaymentButton.y,
                        onRelease = function() 
                                      

                                     end,
                      }
                 claimsButton.x = 0 + claimsButton.width/2  + sceneinfo.groupbetween
                 container:insert(claimsButton)

                 -------------------------------------------------
                 -- insert the primary policy info group
                 -------------------------------------------------
 
                 container:insert(itemGrp)

                 ------------------------------------------------------
                 -- Table View - used for docs
                 ------------------------------------------------------
                 myList = widget.newTableView {
                           x=0,
                           y= 0 + sceneinfo.groupheight/2 +  sceneinfo.btnheight/2 + sceneinfo.groupbetween , --myApp.cH/2 -  sceneinfo.tableheight/2 - myApp.tabs.tabBarHeight-sceneinfo.edge, 
                           width = cellgroupwidth , 
                           height = myApp.sceneHeight - sceneinfo.groupheight - sceneinfo.btnheight - sceneinfo.groupbetween*4,
                           onRowRender = onRowRender,
                           onRowTouch = onRowTouch,
 
                        }
                 container:insert(myList)

                 local BuildTheDocList = function ( )
                        local a = {}
                        for n in pairs(polgroup.policyDocs) do table.insert(a, n) end
                        table.sort(a)
                        for i,k in ipairs(a) do  

                        --for i = 1, #e.response.result do
                            ---------------------------------------------
                            -- insert the term as a aheader. The same header will be used for vehicles as well
                            ---------------------------------------------
                            local termgroupdoc = polgroup.policyDocs[k]
                            print("policy docs stuff " ..   " - " .. termgroupdoc["policymod"])
                           

                            local effdate = common.dateDisplayFromIso(termgroupdoc["effdate"] )
                            local expdate = common.dateDisplayFromIso(termgroupdoc["expdate"] )


                            myList:insertRow{
                                rowHeight =  sceneinfo.row.catheight,
                                isCategory = true,
                                rowColor = sceneinfo.row.catColor,
                                lineColor = sceneinfo.row.catlineColor,

                                params = {   id = termgroupdoc["policymod"],
                                             title = "Term: " .. (effdate or "") .. " To " .. (expdate or "") ,
                                          }  -- params
                                }   --myList:insertRow

                            ---------------------------------------------
                            -- insert the documents for the term
                            ---------------------------------------------
                            if #termgroupdoc.documents > 0 then

                                 for pt = 1, #termgroupdoc.documents  do
                                    local docgroup = termgroupdoc.documents[pt]
                                    print ("doc group " .. (docgroup.docdescription or ""))
                                    
                                    myList:insertRow{
                                        rowHeight = sceneinfo.row.height,
                                        isCategory = false,
                                        rowColor = sceneinfo.row.rowColor,
                                        lineColor = sceneinfo.row.lineColor,

                                        params = {
                                                     id = docgroup.objectId,
                                                     rowtype = "docimages",
                                                     rowobject = docgroup.doctype ,
                                                     docdate = docgroup.docdate  ,
                                                     docdescription =  (docgroup.docdescription or "") ,
                                                     title =  (docgroup.docdescription or "") ,
                                                     
                                                     docfileurl = docgroup.docfileurl,
                                                     docfilename = docgroup.docfilename,
                                                     docfiletype = docgroup.docfiletype,
                                                  }  -- params
                                        }   --myList:insertRow
                                     end    -- for pt = 1, #termgroupdoc.documents  do
                            end    -- #termgroupdoc.documents > 0
                            ------------------------------------------------
                            -- any vehicles ?
                            -- no need to sort since we loop thru everything looking for matching mod. veh order doesnt matter
                            -- the key oon the group is just a sequence loke docs
                            ------------------------------------------------
                            --print ("looking at policy vehs")
                            --print (#polgroup.policyVehs)
                            for kv,iv in pairs(polgroup.policyVehs) do
                           -- for iv,kv in ipairs(polgroup.policyVehs) do  
 
                                 local termgroupveh = polgroup.policyVehs[kv]
                                 if termgroupveh  then
                                    --print ("looking at policy vehs 2.5" .. kv .. " " .. termgroupveh["policymod"] .. " " .. termgroupdoc["policymod"])
                                     if #termgroupveh.vehicles > 0 and termgroupveh["policymod"] == termgroupdoc["policymod"] then
 
                                         for ptv = 1, #termgroupveh.vehicles  do
                                            local vehgroup = termgroupveh.vehicles[ptv]
                                            print ("veh group " .. (vehgroup.vehvin or ""))

                                            
                                            myList:insertRow{
                                                rowHeight = sceneinfo.row.height,
                                                isCategory = false,
                                                rowColor = sceneinfo.row.rowColor,
                                                lineColor = sceneinfo.row.lineColor,

                                                params = {
                                                             id = vehgroup.objectId,
                                                             rowtype = "vehinfo",
                                                             rowobject = vehgroup.vehtype ,

                                                             vehvin = (vehgroup.vehvin or "") ,
                                                             vehyear = (vehgroup.vehyear or "") ,
                                                             vehmake = (vehgroup.vehmake or "") ,
                                                             vehmodel = (vehgroup.vehmodel or "") ,


                                                          }  -- params
                                                }    
                                            
                                        end    -- for ptv = 1, #termgroupveh.vehicles  do

                                     end   -- if #termgroupveh.vehicles > 0 then
                                 end   -- if termgroupveh then
                            end
                            myList:scrollToIndex( 1 ) 
                        end  -- for i,k in ipairs(a) do 

 
                  end
 

                 ----------------------------------
                 -- do we have docs or atleast attempted to get them for this policy  ?
                 --
                 -- polgroup actually is a reference to myApp.authentication.policies[sceneparams.policynumber]
                 ----------------------------------
                 if polgroup.policyDocs and polgroup.policyVehs then 
                    BuildTheDocList()
                 else
                    polgroup.policyDocs = {} 
                    polgroup.policyVehs = {} 
                    print ("Getting docs")
                    if common.testNetworkConnection()  then
                         native.setActivityIndicator( true ) 
                         parse:run(myApp.otherscenes.policydetails.functionname.getdocuments,
                            {
                             ["policyNumber"] = (polcurrentterm.policynumber or ""),
                             },
                             ------------------------------------------------------------
                             -- Callback inline function
                             ------------------------------------------------------------
                             function(e) 
                                
                                --debugpopup ("here from get policies")
                                if (e.response.error or "" ) == "" then  
                                                 
                                    -----------------------------------
                                    -- results will come back with policyterm as aheader group
                                    -- they will be in effdate desc order
                                    -----------------------------------
                                    for i = 1, #e.response.result do
                                            local resgroup = e.response.result[i][1]
                                            ----------------------------------
                                            -- the key is only used for sorting otherwise does not do anything
                                            ----------------------------------
                                            local termkey = tostring(i)
                                            polgroup.policyDocs[termkey] = {}   -- so we can sort
                                            
                                            local termdocgroup = polgroup.policyDocs[termkey]      -- so we can sort
                                            myApp.fncCopyPolicyTerm (resgroup,termdocgroup)
                                            -- termdocgroup.policynumber = resgroup.policyNumber
                                            -- termdocgroup.policymod = resgroup.policyMod
                                            -- termdocgroup.effdate = resgroup.effDate.iso
                                            -- termdocgroup.expdate = resgroup.expDate.iso
                                            termdocgroup.documents = {}     -- will contain collection of docs for this term

                                            -------------------------------------
                                            -- now go grab the actuakl docs
                                            -------------------------------------

                                            if #resgroup.policyDocs[1] > 0 then
                                                     for pt = 1, #resgroup.policyDocs[1]  do
                                                        local docresgroup = {}
                                                        docresgroup.doctype = resgroup.policyDocs[1][pt].docType
                                                        docresgroup.docdate = resgroup.policyDocs[1][pt].docDate.iso
                                                        docresgroup.docfiletype = resgroup.policyDocs[1][pt].docFile.__type
                                                        docresgroup.docfilename = resgroup.policyDocs[1][pt].docFile.name
                                                        docresgroup.docfileurl = resgroup.policyDocs[1][pt].docFile.url
                                                        docresgroup.docdescription = resgroup.policyDocs[1][pt].docDescription
                                                        docresgroup.objectId = resgroup.policyDocs[1][pt].objectId
                                                        print ("doc group " .. (docresgroup.docdescription or ""))
                                                  
                                                        table.insert (termdocgroup.documents, pt, docresgroup)
                                                     end
                                            end  
                                       end    -- end for loop
                                       ------------------------------------
                                       -- get vehicles ?
                                       ------------------------------------
                                       local getvehs = false
                                       local infotbl = myApp.lobinfo[string.lower( (polcurrentterm.policylob or "default") )]
                                       if infotbl then getvehs = (infotbl.vehicles or false) end
                                       if getvehs then
                                             print ("getting vehicles ")
                                             parse:run(myApp.otherscenes.policydetails.functionname.getvehicles,
                                                    {
                                                     ["policyNumber"] = (polcurrentterm.policynumber or ""),
                                                     },
                                                     ------------------------------------------------------------
                                                     -- Callback inline function
                                                     ------------------------------------------------------------
                                                     function(e) 
                                                        if (e.response.error or "" ) == "" then 

                                                                for i = 1, #e.response.result do
                                                                        local resgroup = e.response.result[i][1]
                                                                        ----------------------------------
                                                                        -- the key is only used for sorting otherwise does not do anything
                                                                        ----------------------------------
                                                                        local termkey = tostring(i)
                                                                        polgroup.policyVehs[termkey] = {}   -- so we can sort
                                                                        
                                                                        local termvehgroup = polgroup.policyVehs[termkey]      -- so we can sort
                                                                        myApp.fncCopyPolicyTerm (resgroup,termvehgroup)
                                                                        -- termvehgroup.policynumber = resgroup.policyNumber
                                                                        -- termvehgroup.policymod = resgroup.policyMod
                                                                        -- termvehgroup.effdate = resgroup.effDate.iso
                                                                        -- termvehgroup.expdate = resgroup.expDate.iso
                                                                        -- termvehgroup.objectId = resgroup.objectId
                                                                        -- termvehgroup.policyaddress = resgroup.policyAddress
                                                                        -- termvehgroup.policycity = resgroup.policyCity
                                                                        -- termvehgroup.policycompanycame = resgroup.policyCompanyName
                                                                        -- termvehgroup.policyinsurancegroup = resgroup.policyInsuranceGroup
                                                                        -- termvehgroup.policyinsuredname = resgroup.policyInsuredName
                                                                        -- termvehgroup.policylob = resgroup.policyLOB
                                                                        -- termvehgroup.policynaic = resgroup.policyNaic
                                                                        -- termvehgroup.policypostalcode = resgroup.policyPostalCode
                                                                        -- termvehgroup.policystate = resgroup.policyState
                                                                        -- termvehgroup.policystatename = resgroup.policyStateName
                                                                        -- termvehgroup.policytype = resgroup.policyType
                                                                        -- termvehgroup.policydue = resgroup.policyDue
                                                                        -- termvehgroup.agencycode = resgroup.agencyCode
                                                                        termvehgroup.vehicles = {}     -- will contain collection of docs for this term
                                                                        --print (termvehgroup.policynumber)

                                                                        -------------------------------------
                                                                        -- now go grab the actuakl docs
                                                                        -------------------------------------

                                                                        if #resgroup.policyVehs[1] > 0 then
                                                                                 for pt = 1, #resgroup.policyVehs[1]  do
                                                                                    local vehresgroup = {}
                                                                                    vehresgroup.vehtype = resgroup.policyVehs[1][pt].vehType
                                                                                    vehresgroup.vehvin = resgroup.policyVehs[1][pt].vehVin
                                                                                    vehresgroup.vehyear = resgroup.policyVehs[1][pt].vehYear
                                                                                    vehresgroup.vehmake = resgroup.policyVehs[1][pt].vehMake
                                                                                    vehresgroup.vehmodel = resgroup.policyVehs[1][pt].vehModel
                                                                                    vehresgroup.objectId = resgroup.policyVehs[1][pt].objectId
                                                                                    print ("veh group " .. (vehresgroup.vehvin or ""))
                                                                              
                                                                                    table.insert (termvehgroup.vehicles, pt, vehresgroup)
                                                                                 end
                                                                        end  
                                                                   end    -- end for loop

                                                        else      -- else of error check
                                                        end       -- end of error check
                                                        native.setActivityIndicator( false ) 
                                                        BuildTheDocList()
                                                     end    -- end of function return parse
                                                 )
                                       else
                                           native.setActivityIndicator( false ) 
                                           BuildTheDocList()
                                       end              -- end of getvehs check

                                else    -- on get policies rturn error check    error on the getpolicies
                                    native.setActivityIndicator( false ) 
                                    BuildTheDocList()
                                end  -- end of error check for docs callback
                             end )  -- end of policies parse call anf callback
                     end    -- end of network connection check                    
                 end  


 
 
            end    -- end check for policyterms
 
        end

    ----------------------------------
    -- Did Show
    ----------------------------------
    elseif ( phase == "did" ) then
        parse:logEvent( "Scene", { ["name"] = currScene} )
 

        justcreated = false
    end   -- phase check
	

end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then

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

function scene:overlay( parms )
     print ("overlay happening on top of " .. currScene .. " " .. parms.type .. " " .. parms.phase)
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