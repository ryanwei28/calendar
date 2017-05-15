
 
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
local accountBg
local passwordBg
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 init = function ( _parent )
     
    --介面
    ------------------------------------------------------------------------------------------
    bg = display.newImageRect( _parent , "images/loginBg.jpg" , SCREEN.W , SCREEN.H )
    bg.x , bg.y = SCREEN.CX , SCREEN.CY
    bg:setFillColor( 0.9 )

    logo = display.newImageRect( _parent, "images/logo.png", SCREEN.W * 0.5 , SCREEN.W * 0.5 )
    logo.x , logo.y = SCREEN.CX , SCREEN.CY * 0.6

    login = display.newImageRect( _parent, "images/login.png", SCREEN.W * 0.73 , SCREEN.H * 0.16 )
    login.x , login.y =  SCREEN.CX , SCREEN.CY * 1.3 

    accountBg = display.newImageRect( _parent , "images/account.png",  SCREEN.W * 0.8 , SCREEN.H * 0.16 )
    accountBg.x , accountBg.y = SCREEN.CX  , SCREEN.CY

    -- passwordBg = display.newImageRect( _parent , "images/account.png",  SCREEN.W * 0.5 , SCREEN.H * 0.08 )
    -- passwordBg.x , passwordBg.y = SCREEN.CX * 1.1  , SCREEN.CY*1.4

    account_textField = native.newTextField( SCREEN.CX * 1.14  , SCREEN.CY *0.93 , SCREEN.W * 0.6 , SCREEN.H * 0.07 )
    account_textField.hasBackground = false

    password_textField = native.newTextField( SCREEN.CX * 1.14  , SCREEN.CY *1.07 , SCREEN.W * 0.6 , SCREEN.H * 0.07 )
    password_textField.hasBackground = false
    password_textField.isSecure = true

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
        -- native.showAlert( "網路錯誤", "請確定您的網路連線狀態", { "OK" })
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