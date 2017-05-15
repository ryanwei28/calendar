 
local scene = composer.newScene()
local sceneGroup
local pickerWheelGroup
local onRowRender
local onRowTouch
local date = os.date('*t')
local day = date.day
local month = date.month
local year = date.year
local week = tonumber( os.date("%w") )
local calculateMonth 
local onValueSelected
local weekCalculate
local getIntPart
local addJudgeDay
local requestCallback
local networkRequset
local netreqTableView
local onNetreqRowRender
local calculateNetworkReq
local decode_data = {}
local i = 0
local j = 0
local k = 0
local memo_date = year.."-"..string.format( "%02d", month  ).."-"..string.format( "%02d", day  )
local y = string.sub(year,3,4)
user_id = composer.getVariable( "user_id" )
local weekData = {
    "(日)" ,
    "(一)" ,
    "(二)" ,
    "(三)" ,
    "(四)" ,
    "(五)" ,
    "(六)" ,
    }
local rowBgData = {
    "images/sat.png" ,
    "images/mon.png" ,
    "images/mon.png" ,
    "images/mon.png" ,
    "images/mon.png" ,
    "images/mon.png" ,
    "images/sat.png" ,
    }
local month_Days = { 31, 28 , 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
local yearData = {2014,2015,2016,2017,2018,2019,2020}
local bg
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 init = function ( _parent )

    -- Set up the picker wheel columns
    bg = display.newImageRect( _parent, "images/memoBg.jpg", SCREEN.W , SCREEN.H )
    bg.x , bg.y = SCREEN.CX , SCREEN.CY
    local columnData = 
    { 
        { 
            align = "center",
            width = SCREEN.W * 0.3 ,
            labelPadding = 20,
            startIndex = 4,
            labels = { "2014","2015","2016","2017", "2018", "2019", "2020" }
        },
        {
            align = "center",
            width = SCREEN.W * 0.35,
            labelPadding = 10,
            startIndex = month,
            labels = { "一月", "二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月", }
        },
        {
            align = "center",
            width = SCREEN.W * 0.3,
            labelPadding = 10,
            startIndex = day,
            labels = { "1", "2", "3", "4", "5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31" }
        }
    }
     
    local fontColorSelected = { 1, 0.6, 0 }

    pickerWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = display.contentHeight - SCREEN.H * 0.12,
        columns = columnData,
        style = "resizable",
        width = display.contentWidth,
        height = SCREEN.H * 0.11 ,
        rowHeight = SCREEN.H * 0.05,
        fontColorSelected = fontColorSelected ,
        onValueSelected = onValueSelected ,
        fontSize = 40
    })
     

    -- createTableView()
    _parent:insert( pickerWheelGroup )
    pickerWheelGroup:insert( pickerWheel )

    native.setActivityIndicator( true )
    calculateNetworkReq()
end
 

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
weekCalculate = function (  )
    
    y = string.sub(year,3,4)  --年分
    c = string.sub(year,1,2)  --世紀
    m = month --月份 值為3~14 及1 2 月份為前一年之13 14月
    d = day  --日 

    if ( month == 1 ) then 
        m = 13 
        y = y - 1 
    elseif ( month == 2 ) then 
        m = 14 
        y = y - 1
    end

   --蔡勒公式  計算星期幾
    w = (y + getIntPart(y/4) + getIntPart(c/4) - 2 * c + getIntPart(26*(m+1)/10) + d - 1 ) % 7

    week = w

    memo_date = c..y.."-"..string.format( "%02d", m  ).."-"..string.format( "%02d", d  )
    if (m == 13) then
        memo_m = 1
        memo_y = y + 1
        memo_date = c..memo_y.."-"..string.format( "%02d", memo_m  ).."-"..string.format( "%02d", d  )
    elseif (m == 14) then
        memo_m = 2
        memo_y = y + 1
        memo_date = c..memo_y.."-"..string.format( "%02d", memo_m  ).."-"..string.format( "%02d", d  )
    end
    
    print(memo_date)
end

--Value Selected Listener 
onValueSelected = function ( e )
    native.setActivityIndicator( true )
    tableView:removeSelf( )
    if (e.column == 1) then
        year = yearData[e.row]
        weekCalculate()
    elseif (e.column == 2) then
        month = e.row
        weekCalculate()
    elseif (e.column == 3) then
        day = e.row
        weekCalculate()
    end

    calculateNetworkReq()
    -- createTableView()
    -- y = string.sub(year,3,4)
end

--建立tableView
createTableView = function (  )
    add_d = 0
    add_JudgeDay = 0
     tableView = widget.newTableView(
        {
            left = 0,
            top = SCREEN.CY * 0.16,
            height = SCREEN.H * 0.8 ,
            width = SCREEN.W,
            isLocked = true ,
            onRowRender = onRowRender,
            onRowTouch = onRowTouch,
            listener = scrollListener
        }
    )
 
    -- Insert 7 rows
    for i = 1, 7 do
        local rowHeight = SCREEN.H * 0.11
        local rowColor = { default={1,1,1}, over={1,0.5,0,0.2} }
        local lineColor = { 0.1, 0.5, 0.5 }
        -- Insert a row into the tableView
        tableView:insertRow(
            {
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor
            }
        )
    end

    sceneGroup:insert( tableView )
end

--跳月日期遞增
addDay = function ( )
   add_d = add_d + 1
end

addJudgeDay = function (  )
    add_JudgeDay = add_JudgeDay + 1
end

--networkRequset
networkRequset = function ( row )
    
    local host = "http://localhost:8080/fgd-api/"
    local func = "readData/"
    local user_id = user_id.."/"
    local date = year..string.format( "%02d" , cal_month_num)..string.format( "%02d" , cal_day_num)
    local URL = host..func..user_id..date

    network.request( URL, "GET", requestCallback  ) 
end

--requestCallback
requestCallback = function ( event )
      if ( event.isError ) then
        print( "Network error: ", event.response )
        native.showAlert( "網路錯誤", "請確定您的網路連線狀態", { "OK" })
    else
        local data = json.decode( event.response )
        
        i = i + 1

        if (data.content == nil) then
            data.content = "查無資料" 
        end
        decode_data[i] = data
        print( decode_data[i].content )

        calculateNetworkReq()
        if ( i == 7 ) then
            i = 0
            createTableView()
            native.setActivityIndicator( false )
        end
    end
end

--計算requsst 所需date
calculateNetworkReq = function (  )
     
    -- for j = 1 , 7 do 
    j = j + 1
        cal_day_num = day - 1 + j 
        cal_month_num = month
        

        if (year%4 == 0) then
            month_Days[2] = 29
        else 
            month_Days[2] = 28
        end

        if (cal_day_num) > month_Days[month]  then
            cal_month_num = cal_month_num + 1
            addDay()
            cal_day_num = add_d
        elseif (cal_day_num) < 1 then
            cal_month_num = cal_month_num - 1
            cal_day_num = month_Days[month] + cal_day_num
        end 

        if (cal_month_num > 12) then 
            cal_month_num = 1
        end

        print( cal_day_num..cal_month_num )

    if (j <= 7 )then
        networkRequset()
    else 
        j = 0
    end
        -- local re_date = display.newText( row, decode_data[row.index].content, 150 , 35, font , 20 )
        -- re_date:setFillColor( 0.4 )
    -- end
end

--tableView row render
onRowRender = function ( event )
  
    local row = event.row
   
    day_num = day - 1 + row.index 
    month_num = month
    print( month..row.index )

    if (year%4 == 0) then
        month_Days[2] = 29
    else 
        month_Days[2] = 28
    end

    if (day_num) > month_Days[month]  then
        month_num = month_num + 1
        addDay()
        day_num = add_d
    elseif (day_num) < 1 then
        month_num = month_num - 1
        day_num = month_Days[month] + day_num
    end 

    if (month_num > 12) then 
        month_num = 1
    end
--=======================================================================
    
    local week_num = week + row.index 
   
    if (week_num) > 7 then
        week_num = week + row.index -7
    end

    local rowBg = display.newImageRect( row , rowBgData[week_num], SCREEN.W , SCREEN.H * 0.138 )
    rowBg.x , rowBg.y = SCREEN.CX , SCREEN.CY * 0.1
    rowBg.alpha = 0.7
    local re_date = display.newText( row, decode_data[row.index].content, SCREEN.CX * 0.75 , SCREEN.CY *0.12 , SCREEN.W * 0.55  , SCREEN.H *0.07 , font , 35 )
    re_date:setFillColor( 0 )
    re_date.anchorX = 0 
   
    local calendar_date = display.newText( row, month_num.."/"..day_num, SCREEN.CX * 0.22 , SCREEN.CY * 0.12 ,  font , 60 )
    calendar_date:setFillColor( 0.4 )

    local calendar_week = display.newText( row, weekData[week_num], SCREEN.CX * 0.5 , SCREEN.CY * 0.12 , font , 45 )
    calendar_week:setFillColor( 0.45 )  

    k = k +1 

    if (k == 7 ) then
        k = 0
        table.remove( decode_data )
        decode_data = {}
    end
end

onRowTouch = function ( e )
    if (e.phase == "tap") then

            if (year%4 == 0) then
                month_Days[2] = 29
            else 
                month_Days[2] = 28
            end

            if (day_num) > month_Days[month]  then
                month_num = month_num + 1
                addDay()
                day_num = add_d
            elseif (day_num) < 1 then
                month_num = month_num - 1
                day_num = month_Days[month] + day_num
            end 

            if (month_num > 12) then 
                month_num = 1
            end

        judge_d = string.sub(memo_date , -2 , -1)
        judge_m = string.sub(memo_date , -5 , -4)
        judge_d = judge_d + e.row.index - 1

        if (judge_d) > month_Days[month] then 
            judge_m = judge_m + 1
            -- addJudgeDay()
            judge_d = judge_d - month_Days[month]
        end

        if (judge_m == 13) then 
            judge_m = 1
            memo_y = y + 1
            memo_date = c..memo_y.."-"..string.format( "%02d", judge_m  ).."-"..string.format( "%02d", d  )
            -- y = y + 1-- = memo_y + 1
        elseif (judge_m == 14) then
            judge_m = 2
            memo_y = y + 1
            memo_date = c..memo_y.."-"..string.format( "%02d", judge_m  ).."-"..string.format( "%02d", d  )
        end
        -- string.sub(memo_date , 1 , 4 )
        memo_date = string.sub(memo_date , 1 , 4 ).."-"..string.format("%02d" ,judge_m).."-"..string.format("%02d" ,judge_d )

        composer.setVariable( "num" , e.row.index )
        composer.setVariable( "memo_date", memo_date )
        composer.gotoScene( "memo" )
    end
end

 --取一个数的整数部分
getIntPart = function(x)
    if x <= 0 then
       return math.ceil(x);
    end

    if math.ceil(x) == x then
       x = math.ceil(x);
    else
       x = math.ceil(x) - 1;
    end
    return x;
end
--=============================================================================================================

-- create()
function scene:create( event )
 
    sceneGroup = self.view
    pickerWheelGroup = display.newGroup( )
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