
 
local scene = composer.newScene()
local init
local sceneGroup
local bg
local logo
local login
local logo_text
local login_text
local account 
local password 
local account_textField
local password_textField
local networkListener
local removeTextField
local admin
local fgdpass
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 init = function ( _parent )
     
    --介面
    ------------------------------------------------------------------------------------------
    bg = display.newRect( _parent , 160 , 320 , 320 , 640 )
    bg:setFillColor( 0.9 )

    logo = display.newCircle( _parent , 120 , 100 , 80 )
    logo:setFillColor( 0.5 )
    logo.x , logo.y = 160 , 140

    logo_text = display.newText( _parent , "公司LOGO" , 160 , 140, font , 30 )

    login = display.newRect( _parent , 160 , 460 , 100 , 40 )
    login:setFillColor( 0.6 )

    login_text = display.newText( _parent , "登入", 160 , 460 , font , 20 )

    account = display.newText( _parent , "帳號", 50 , 280 , font , 25 )
    account:setFillColor( 0.8 , 0.5 , 0 )

    password = display.newText( _parent , "密碼", 50 , 340 , font , 25 )
    password:setFillColor( 0.8 , 0.5 , 0 )

    account_textField = native.newTextField( 180 , 280 , 160 , 50 )
    password_textField = native.newTextField( 180 , 340 , 160 , 50 )
    password_textField.isSecure = true
    password_textField.size = 20


    login:addEventListener( "tap", function (  )
        admin = account_textField.text 
        fgdpass = password_textField.text
        if (admin) == "" and (fgdpass) == "" then 
            native.showAlert( "Error", "請輸入帳號及密碼", { "OK" })
        elseif (fgdpass) == "" then
            native.showAlert( "Error", "請輸入密碼", { "OK" })
        elseif (admin) == "" then
            native.showAlert( "Error", "請輸入帳號", { "OK" })
        else
            network.request( "http://localhost:8080/fgd-api/doLogin/"..admin.."/"..fgdpass, "GET", networkListener )
        end
        -- network.request( "http://localhost:8080/fgd-api/doLogin/admin/fgdpass", "GET", networkListener )
        -- network.request( "http://localhost:8080/fgd-api/doLogin/"..admin.."/"..fgdpass, "GET", networkListener )
        
    end )

    ----------------------------------------------------------------------------------------------------------

 end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
networkListener = function ( e )
     if ( e.isError ) then
        print( "Network error: ", e.response )
    else
        print ( "RESPONSE: " .. e.response )
        data = json.decode( e.response ) 
        print( data.user_id )
        if (data.user_id) then
            composer.setVariable( "user_id", data.user_id )
            composer.gotoScene( "calendar" )
        else
            native.showAlert( "Error", "帳號或密碼錯誤", { "OK" })
        end
    end
end


removeTextField = function (  )
    account_textField:removeSelf( )
    password_textField:removeSelf( )
end
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
 
    sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    init(sceneGroup)
end
 
 
-- show()
function scene:show( event )
 
    sceneGroup = self.view
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
        removeTextField()
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