local myApp = require( "myapp" )
local socket = require( "socket" )
local json = require("json")
-------------------------------------------------------
-- common functions used in any app
-------------------------------------------------------
local M = { }

-------------------------------------------------------
-- wont work for functions and other types in the table
-------------------------------------------------------
-- function M.DeepCopy(t)
--    local t2 = {};
--    if type(t) == "table" then
--       t2 = json.decode(json.encode(t))
--    end
--    return t2
-- end
function M.appCondition(parms)
    local appcnd =   true
    local intable = parms or {}
    if (intable.showonlyindebugMode and myApp.debugMode == false) then appcnd = false end
    if (intable.showonlyinloggedin and myApp.authentication.loggedin == false) then appcnd = false  end
    if (intable.showonlyinloggedout and myApp.authentication.loggedin == true) then appcnd = false  end
    return appcnd
end

function M.phoneformat(str)
   local digitsonly = (string.gsub( str, "[^0-9]", "" )  or "")
   local disphone = ("(" .. string.sub(digitsonly, 1,3) .. ") " .. string.sub(digitsonly, 4,6) .. "-" .. string.sub(digitsonly, 7) )
   if string.len( digitsonly) ~= 10 then  disphone = digitsonly end
   return disphone
end

function M.dateDisplayFromIso(isoString)
    --then = makeTimeStamp("2013-01-01T00:00:00Z")
   --                       2015-12-08T10:08:00.000Z
 -- print ("iso date " .. isoString)
 --    local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%p])(%d%d)%:?(%d%d)"
 --    local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin =
 --      isoString:match( pattern )
 --      print ("iso date day " .. day)
 --    local convertedTimestamp = os.time({year = year, month = month, 
 --        day = day, hour = hour, min = minute, sec = seconds})
 
     local pattern = "(%d+)%-(%d+)%-(%d+)"
     local year, month, day  = isoString:match( pattern )
     local convertedTimestamp = os.time({year = year, month = month, day = day })
     return os.date("%m/%d/%Y",convertedTimestamp)
end

function M.urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end

function M.SceneBackground(colortbl)
    local colortable = colortbl or myApp.sceneBackgroundcolor
    local background = display.newRect(0,0,myApp.cW, myApp.cH)
    --background:setFillColor(235/myApp.colorDivisor, 235/myApp.colorDivisor, 225/myApp.colorDivisor, 255/myApp.colorDivisor)
    background:setFillColor(colortable.r,colortable.g,colortable.b,colortable.a)
    background.x = myApp.cW / 2
    background.y = myApp.cH / 2
    return background
end

function M.SceneContainer()
    local container = display.newContainer(myApp.sceneWidth,myApp.sceneHeight)
    container:insert(M.SceneBackground(myApp.sceneBackgroundcolor))
    container.y = myApp.sceneHeight  /2 + myApp.sceneStartTop
    container.x = myApp.sceneWidth / 2  
    return container
end

function M.testNetworkConnection()
    local netConn = socket.connect('www.google.com', 80)
    if netConn == nil then
         return false
    end
    netConn:close()
    return true
end

function M.fitImage( displayObject, fitWidth, enlarge )
    --
    -- first determine which edge is out of bounds
    --
    local scaleFactor = fitWidth / displayObject.width 
    displayObject:scale( scaleFactor, scaleFactor )
end

function M.newTextField(options)
    local customOptions = options or {}
    local opt = {}

    --
    -- Core parameters
    --
    opt.left = customOptions.left or 0
    opt.top = customOptions.top or 0
    opt.x = customOptions.x or 0
    opt.y = customOptions.y or 0
    opt.width = customOptions.width or (display.contentWidth * 0.75)
    opt.height = customOptions.height or 20
    opt.id = customOptions.id
    opt.listener = customOptions.listener or nil
    opt.text = customOptions.text or nil
    opt.inputType = customOptions.inputType or "default"
    --Possible string values are:
--"default" — the default keyboard, supporting general text, numbers and punctuation.
--"--number" — a numeric keypad.
--"decimal" — a keypad for entering decimal values.
--"phone" — a keypad for entering phone numbers.
--"url" — a keyboard for entering website URLs.
--"email" — a keyboard for entering email addresses.
    opt.font = customOptions.font or native.systemFont
    opt.fontSize = customOptions.fontSize or opt.height * 0.67
    opt.placeholder = customOptions.placeholder or nil
    opt.isSecure = customOptions.isSecure  or false 

    -- Vector options
    opt.strokeWidth = customOptions.strokeWidth or 2
    opt.cornerRadius = customOptions.cornerRadius or opt.height * 0.33 or 10
    opt.strokeColor = customOptions.strokeColor or {0, 0, 0}
    opt.backgroundColor = customOptions.backgroundColor or {1, 1, 1}
 
    --
    -- Create the display portion of the widget and position it.
    --

    local field = display.newGroup()

    local background = display.newRoundedRect( 0, 0, opt.width, opt.height, opt.cornerRadius )
    background:setFillColor(unpack(opt.backgroundColor))
    background.strokeWidth = opt.strokeWidth
    background.stroke = opt.strokeColor
    field:insert(background)

    if opt.x then
        field.x = opt.x
    elseif opt.left then
        field.x = opt.left + opt.width * 0.5
    end
    if opt.y then
        field.y = opt.y
    elseif opt.top then
        field.y = opt.top + opt.height * 0.5
    end

    -- create the native.newTextField to handle the input

    field.textField = native.newTextField(0, 0, opt.width - opt.cornerRadius, opt.height - opt.strokeWidth * 2)
    field.textField.x = field.x
    field.textField.y = field.y
    field.textField.hasBackground = false
    field.textField.inputType = opt.inputType
    field.textField.text = opt.text
    field.textField.placeholder = opt.placeholder
    field.textField.isSecure = opt.isSecure

    if opt.listener and type(opt.listener) == "function" then
        field.textField:addEventListener("userInput", opt.listener)
    end

    --
    -- Handle setting the text parameters for the native field.
    --

   -- local deviceScale = (display.pixelWidth / display.contentWidth) * 0.5
    
   -- field.textField.font = native.newFont( opt.font )
    --field.textField.size = opt.fontSize * deviceScale
    field.textField:resizeFontToFitHeight()

    --
    -- Sync the position of the native object and the display object.
    -- A 60 fps app will make this smoother than a 30 fps app
    -- 
    -- You could add in things to handle other properties like alpha, .isVisible etc.
    -- that both objects support.
    --

    local function syncFields(event)
        field.textField.x = field.x
        field.textField.y = field.y
    end
    Runtime:addEventListener( "enterFrame", syncFields )

    --
    -- Handle cleaning up the native object when the display object is destroyed.
    --
    function field:finalize( event )
        event.target.textField:removeSelf()
    end

    field:addEventListener( "finalize" )

    return field
end 

return M