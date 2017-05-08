 
local scene = composer.newScene()
local sceneGroup
local num = composer.getVariable( "num" )
local memo_date = composer.getVariable( "memo_date" )
local bg 
local inputData
local added 
local clear 
local back 
local textListener 
local readData
local saveData 
local inputDataFun
local memoText
local scrollView
local backListener
local clearListener
local addedListener
local addText
local memoTextY = 250
local addTextY = 230
local networkListener
local networkRequset
local submitted
local submittedText 
local modifyNetworkListener
local modify 
local modifyListener
local clearNetwork
local clearNetworkListener
local readDataCallback
local contentText
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
init = function ( _parent )
    print( memo_date )
    bg = display.newRect( _parent , 160 , 180, 320, 380 )
    bg:setFillColor( 0.7 , 0.82 , 0.9 )
    added = display.newCircle( _parent , 60, 450, 40 )
    clear = display.newCircle( _parent , 160 , 450 , 40 )
    back = display.newCircle( _parent, 260, 450, 40 )
    submitted = display.newCircle( _parent, 280 , 50 , 20 )
    modify = display.newCircle( _parent , 100 , 450 , 20 )

    addedText = display.newText( _parent, "新增", 60, 450, font , 25)
    addedText:setFillColor( 0.3 )
    clearText = display.newText( _parent, "清除", 160, 450, font , 25)
    clearText:setFillColor( 0.3 )
    baclText = display.newText( _parent, "返回", 260, 450, font , 25)
    baclText:setFillColor( 0.3 )
    submittedText = display.newText( _parent , "提交", 280 , 50 , font , 20 )
    submittedText:setFillColor( 0.3 )
    contentText = display.newText(  _parent , "" , 40 , 100 ,250 , 600 , font , 20 )
    contentText:setFillColor( 0.2 )
    contentText.anchorX = 0
    contentText.anchorY = 0

    numText = display.newText( _parent, memo_date, 100, 50 , font , 30 )
    numText:setFillColor( 0.2 )

    added:addEventListener( "tap", addedListener )
    back:addEventListener( "tap", backListener )
    clear:addEventListener( "tap", function (  )
        native.showAlert( "確認", "確定要刪除"..memo_date.."的資料嗎?", { "取消" , "確定" } , clearListener)
    end )
    modify:addEventListener( "tap", modifyListener )
    -- submitted:addEventListener( "tap", submittedListener )

    -- Create image sheet for custom scroll bar
    local scrollBarOpt = {
        width = 20,
        height = 20,
        numFrames = 3,
        sheetContentWidth = 20,
        sheetContentHeight = 60
    }
    -- local scrollBarSheet = graphics.newImageSheet( "scrollBar.png", scrollBarOpt )
     
    -- Create the widget
    scrollView = widget.newScrollView(
        {
            top = 0,
            left = 0,
            width = 320,
            height = 380,
            scrollWidth = 600,
            scrollHeight = 800,
            listener = scrollListener,
            horizontalScrollDisabled = true ,
            scrollBarOptions = {
                sheet = scrollBarSheet,
                topFrame = 1,
                middleFrame = 2,
                bottomFrame = 3
            }
        }
    )
    
    _parent:insert( scrollView )
    -- Create a image and insert it into the scroll view
    scrollView:insert( bg )
    scrollView:insert( numText )
    scrollView:insert( submitted )
    scrollView:insert( submittedText )
    scrollView:insert( contentText )

    readData()
--===============================================================================================

end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
--新增資料 network request
networkRequset = function (  )
    
    local headers = {
        ["Content-Tpe"] = "application/x-www-form-urlencoded; charset=utf-8", 
        -- ["Content-Tpe"] = "multipart/form-data; charset=utf-8",
        ["Accept-Language"] = "en-US",
    }

    local jsonData = {}
    jsonData['user_id'] = user_id
    jsonData['content'] = content
    jsonData['date'] = memo_date
    local encodeData = json.encode( jsonData )

    local params = {}
    params.headers = headers
    params.body = "body="..encodeData

    print( "params.body: "..encodeData )

    network.request( "http://localhost:8080/fgd-api/create", "POST", networkListener,params)

end

--新增資料 network callback
networkListener = function( event )
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        readData()
        native.showAlert( "success", "上傳成功！" , {"確定"} )
        print ( "RESPONSE: " .. event.response )
    end
end

--修改資料 modify network 
modifyNetwork = function ( )
    local host = "http://localhost:8080/fgd-api/"
    local func = "add_data/"
    local user_id = user_id.."/"
    local date = memo_date.."/"
    local content = content
    local URL = host..func..user_id..date..content
    print( URL )
    network.request( URL , "GET", modifyNetworkListener)
end

--修改資料 modify callbacl
modifyNetworkListener = function( event )
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        readData()
        native.showAlert( "success", "修改成功！" , {"確定"} )
        print ( "RESPONSE: " .. event.response )
    end
end

--刪除資料 network
clearNetwork = function (  )
    local host = "http://localhost:8080/fgd-api/"
    local func = "delete_data/"
    local user_id = user_id.."/"
    local date = memo_date
    local URL = host..func..user_id..date
    print( URL )
    network.request( URL , "GET", clearNetworkListener)
end

--刪除資料 callback
clearNetworkListener = function ( event )
     if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        native.showAlert( "success", "刪除成功！" , {"確定"} )
        print ( "RESPONSE: " .. event.response )
    end
end

--將資料存至本機
saveData = function (  )
    -- Path for the file to read
    local path = system.pathForFile( num..".txt", system.DocumentsDirectory )
 
    -- Open the file handle
    local file, errorString = io.open( path, "a" )
    
   
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Output lines
        file:write( inputData.."\n" )
        -- Close the file handle
        io.close( file )
    end
    
    file = nil
end

--讀取資料庫資料
readData = function (  )
    
    local host = "http://localhost:8080/fgd-api/"
    local func = "read_Data/"
    local user_id = user_id.."/"
    local date = memo_date
    -- local content = content
    local URL = host..func..user_id..date

    network.request( URL, "GET", readDataCallback ) 
  
end

readDataCallback = function ( event )
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        local data = json.decode( event.response )
        if (data.content) then
            contentText.text = data.content 
        end
        print ( "RESPONSE: " .. event.response )
    end
end
--modifyListener
modifyListener = function (  )
    if (contentText.text == "") then
        native.showAlert( "Error", "請先新增資料" , {"確定"} )
    else
        inputDataFun()
        inputType = "modify"
        contentText.text = content
    end
end

--addedListener
addedListener = function (  )
    if (contentText.text == "") then
        inputDataFun()
        inputType = "add"
    else
        native.showAlert( "Error", "每天只能新增一筆資料" , {"確定"} )
    end
end



--新增資料
inputDataFun = function (  )
    newTextBox = native.newTextBox( 160 , 290 , 300 , 420 )
    newTextBox.size = 20
    newTextBox.isEditable = true
    newTextBox:addEventListener( "userInput", textListener  )
    submitted:addEventListener( "tap", submittedListener )
end

--清除資料
clearListener = function ( e )
  
     if ( e.action == "clicked" ) then
        local i = e.index
        if ( i == 1 ) then
            -- Do nothing; dialog will simply dismiss
        elseif ( i == 2 ) then
            contentText.text = ""
            clearNetwork()
        end
    end
end

submittedListener = function ( ... )
    print( "submitted" )
    print( newTextBox.text )
    inputData = newTextBox.text
    newTextBox:removeSelf( )
    content = inputData

    if (inputType == "add") then
      networkRequset()
    elseif (inputType == "modify") then
        modifyNetwork()
    end

    submitted:removeEventListener( "tap", submittedListener )
end

--返回至萬年曆
backListener = function (  )
    composer.gotoScene( "calendar" )
end

--文字提交
textListener = function ( e )

    if ( e.phase == "began" ) then
        -- User begins editing "defaultField"
    elseif ( e.phase == "ended" or e.phase == "submitted" ) then
      
    elseif ( e.phase == "editing" ) then
        
    end
end

  
-- ScrollView listener
scrollListener = function ( event )
 
    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )

    elseif ( phase == "moved" ) then print( "Scroll view was moved" )

    elseif ( phase == "ended" ) then print( "Scroll view was released" )

    end
 
    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )

        elseif ( event.direction == "down" ) then print( "Reached top limit" )

        elseif ( event.direction == "left" ) then print( "Reached right limit" )

        elseif ( event.direction == "right" ) then print( "Reached left limit" )

        end
    end
 
    return true
end
 
--================================================================================================================
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
        composer.recycleOnSceneChange = true
        num = nil
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