require 'src/scenes/_soda_base'

app.scenes = app.scenes or {}
app.scenes.options = app.scenes.options or {}

function app.scenes.options:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b);
    scene:addChild(bg, -1)

    app.add_2048_title(scene)
    local startx, cursen = 0, app.prefs.sensitivity
    local intend_back = false
    local function onTouchBegan(touch, event)
        local p = touch:getLocation()
        startx = p.x
        intend_back = p.y > display.size.height - scene.max_diametre and p.x < scene.max_diametre
        return true
    end
    local function onTouchMoved(touch, event)
        local p = touch:getLocation()
        local p1 = touch:getStartLocation()
        if intend_back then return end
        cursen = app.prefs.sensitivity + (p.x - startx) / (display.size.width * 2)
        if cursen >= 1 then cursen = 1
        elseif cursen <= 0.05 then cursen = 0.05 end
        scene:refresh_disp(cursen)
    end
    local function onTouchEnded(touch, event)
        local p = touch:getLocation()
        local p1 = touch:getStartLocation()
        if intend_back and p.y > display.size.height - scene.max_diametre and p.x < scene.max_diametre then
            cc.Director:getInstance():popScene()
        end
        app.prefs.sensitivity = cursen
        cc.UserDefault:getInstance():setFloatForKey('acc_sensitivity', cursen)
        cc.UserDefault:getInstance():flush()
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    scene:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, scene)

    local lbl_title = app.label('Options', 52, true)
    lbl_title:setColor(app.res.colours.front._3b)
    lbl_title:setAnchorPoint(cc.p(1, 1))
    lbl_title:setNormalizedPosition(cc.p(1, 1))
    scene:addChild(lbl_title)

    local lbl_desc = app.label(
      'Tap anywhere & swipe left and right to adjust shake sensitivity', 28,
      false, nil, display.size.width)
    lbl_desc:setColor(app.res.colours.front._3b)
    lbl_desc:setNormalizedPosition(cc.p(0.5, 0.618))
    scene:addChild(lbl_desc)
    local lbl_sen_disp = app.label(string.format('%.3f', app.prefs.sensitivity), 56, true)
    lbl_sen_disp:setColor(app.res.colours.front._3b)
    lbl_sen_disp:setAnchorPoint(cc.p(0.5, 1))
    lbl_sen_disp:setNormalizedPosition(cc.p(0.5, 0.5))
    scene:addChild(lbl_sen_disp)
    local lbl_hint_l = app.label('<<  shake slowly', 22)
    lbl_hint_l:setColor(app.res.colours.front._3b)
    lbl_hint_l:setOpacity(128)
    lbl_hint_l:setAnchorPoint(cc.p(0, 0.5))
    lbl_hint_l:setNormalizedPosition(cc.p(0, 0.52))
    scene:addChild(lbl_hint_l)
    local lbl_hint_r = app.label('shake rapidly  >>', 22)
    lbl_hint_r:setColor(app.res.colours.front._3b)
    lbl_hint_r:setOpacity(128)
    lbl_hint_r:setAnchorPoint(cc.p(1, 0.5))
    lbl_hint_r:setNormalizedPosition(cc.p(1, 0.52))
    scene:addChild(lbl_hint_r)
    local lbl_reset_sen = app.label('Reset to default', 36, true)
    lbl_reset_sen:setColor(app.res.colours.front._3b)
    local itm_reset_sen = cc.MenuItemLabel:create(lbl_reset_sen)
    itm_reset_sen:setNormalizedPosition(cc.p(0.5, 0.32))
    itm_reset_sen:registerScriptTapHandler(function()
        app.prefs.sensitivity = app.prefs.sensitivity_default
        scene:refresh_disp(app.prefs.sensitivity)
        cc.UserDefault:getInstance():setFloatForKey('acc_sensitivity', app.prefs.sensitivity)
        cc.UserDefault:getInstance():flush()
    end)
    local reset_scr_tapct = 5
    local lbl_reset_scr = app.label('Reset all high scores\n(tap 5 times)', 30, true)
    lbl_reset_scr:setColor(cc.c3b(192, 0, 0))
    local itm_reset_scr = cc.MenuItemLabel:create(lbl_reset_scr)
    itm_reset_scr:setNormalizedPosition(cc.p(0.5, 0.2))
    itm_reset_scr:registerScriptTapHandler(function()
        reset_scr_tapct = reset_scr_tapct - 1
        local s = 's'; if reset_scr_tapct == 1 then s = '' end
        if reset_scr_tapct == 0 then
            cc.UserDefault:getInstance():setIntegerForKey('classical_high_score', 0)
            cc.UserDefault:getInstance():setIntegerForKey('timetrial_high_score', 0)
            cc.UserDefault:getInstance():flush()
        elseif reset_scr_tapct < 0 then reset_scr_tapct = 0
        end
        local s1
        if reset_scr_tapct == 0 then s1 = 'All high scores reset'
        else s1 = string.format('Reset all high scores\n(tap %d time%s)', reset_scr_tapct, s) end
        lbl_reset_scr:setString(s1)
    end)
    local menu = cc.Menu:create(itm_reset_sen, itm_reset_scr)
    menu:setPosition(cc.p(0, 0))
    scene:addChild(menu)

    function scene:refresh_disp(val)
        lbl_sen_disp:setString(string.format('%.3f', val))
    end

    return scene
end
