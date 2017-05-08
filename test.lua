local scene = composer.newScene()
local sceneGroup
local init
local getIntPart
local onValueSelected
local pickerWheel
local modifyNetwork
local onTakePicButtonRelease
local onComplete
local networkListener
local modifyNetworkListener
local http = require("socket.http")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    
    defaultBox = native.newTextBox( 200, 200, 280, 140 )
    defaultBox.text = "This is line 1.\nAnd this is line2"
    defaultBox.isEditable = true
    defaultBox.size = 20

    -- local headers = {
    --     ["Content-Tpe"] = "application/x-www-form-urlencoded; charset=utf-8", 
    --     -- ["Content-Tpe"] = "multipart/form-data; charset=utf-8",
    --     ["Accept-Language"] = "en-US",
    -- }

    -- local params = {}
    -- params.headers = headers
    -- params.body = "var1=as"

    -- print( "params.body: "..params.body )

     local host = "http://localhost:8080/fgd-api/"
    local func = "add_data/"
    local user_id = 1
    local date = "2017-05-11"
    local content = "sssssssssssssss"
    local URL = host..func..user_id.."/"..date.."/"..content
    print( URL )
    network.request( URL , "GET", modifyNetworkListener)
end

modifyNetwork = function ( )
     
    local host = "http://localhost:8080/"
    local func = "fgd-api/"
    local user_id = 1
    local date = 2017-05-11
    local content = "sssssssssssssss"
    local URL = host..func..user_id.."/"..date.."/"..content

    network.request( URL , "GET", modifyNetworkListener)

end


modifyNetworkListener = function( event )
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        print ( "RESPONSE: " .. event.response )
    end
end
-- Selection completion listener
-- local function onComplete( event )
--     local photo = event.target
    
--     if photo then
--         print( "photo w,h = " .. photo.width .. "," .. photo.height )
--     end
-- end
 
-- local button = display.newRect( 120, 240, 80, 70 )
 
-- local function pickPhoto( event )
--     print( "pickPhoto" )
--     media.selectPhoto(
--     {
--         mediaSource = media.SavedPhotosAlbum,
--         listener = onComplete, 
--         origin = button.contentBounds, 
--         permittedArrowDirections = { "right" },
--         destination = { baseDir=system.TemporaryDirectory, filename="image.jpg" } 
--     })
-- end
 
-- button:addEventListener( "tap", pickPhoto )
-- -- -----------------------------------------------------------------------------------
--     takePicButton = widget.newButton
--         {
--             label = "Take a picture of your favorite dessert!",
--             id = "btnPic",
--             width=display.contentWidth,
--             height=20,
--             onRelease = onTakePicButtonRelease,
--             font = "GillSans"
 
--         }
--         takePicButton.x = display.contentWidth/2
--         takePicButton.y = 450
-- end
 
-- onTakePicButtonRelease = function(event)
--     media.show( media.Camera, onComplete )
-- end

-- onComplete = function(event)
--     local photo = event.target
 
--     local photoGroup = display.newGroup()  
--     photoGroup:insert(photo)
 
--     local tmpDirectory = system.TemporaryDirectory
--     display.save(photoGroup, "photo.jpg", tmpDirectory) 
 
--     --clear
--     cupcakeImage:removeSelf()
--     cupcakeImage = nil
--     cupcakeText:removeSelf()
--     cupcakeText = nil
--     saveButton:removeSelf()
--     saveButton = nil
--     takePicButton:removeSelf()
--     takePicButton = nil

--     photo.x = display.contentWidth/2
--     photo.y = display.contentWidth/2

--     local function onUploadButtonRelease(event)
--         --upload the pic
--         local function callbackFunction(event)
--             if event.phase == "ended" then
--                 local response = event.response
--                 print(response)
--                 print(event.status)
--                 if event.status == 201 then
--                     --alert thanks
--                     local alert = native.showAlert( "Thanks!", "Your picture will be added to our gallery!", {"OK"}, onComplete )

--                 end
--             end
--         end

--     headers = {}
--     headers["X-Parse-Application-Id"] = APPID
--     headers["X-Parse-REST-API-Key"] = RESTAPIKEY
--     headers["Content-Type"] = "image/jpeg"

--     local params = {}
--     params.headers = headers
--     params.bodyType = "binary"

--     network.upload("https://api.parse.com/1/files/photo.jpg","POST",callbackFunction,params,"photo.jpg",system.TemporaryDirectory,"image/jpeg")

--     end
-- end

-- onValueSelected = function ( e )
--    print( e.row.."ss" )
-- end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    init(sceneGroup)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene