-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
composer = require( "composer" )
widget = require( "widget" )
json = require("json")
SCREEN = {
	W = display.contentWidth , 
	H = display.contentHeight ,
	CX = display.contentCenterX , 
	CY = display.contentCenterY
}
main = function (  )
	composer.gotoScene( "login" )

end


main()