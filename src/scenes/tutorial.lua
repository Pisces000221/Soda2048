app.scenes = app.scenes or {}
app.scenes.tutorial = app.scenes.tutorial or {}

function app.scenes.tutorial:create()
    local scene = cc.Scene:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b);
    scene:addChild(bg, -1)

    local container = cc.Layer:create()
    scene:addChild(container)

    app.add_2048_title(scene)
    local starty = 0
    local function onTouchBegan(touch, event)
        local p = touch:getLocation()
        starty = container:getPositionY()
        return true
    end
    local function onTouchMoved(touch, event)
        local p = touch:getLocation()
        local y = starty + touch:getLocation().y - touch:getStartLocation().y
        if y >= 0 then y = 0
        elseif y <= display.size.height - container:getContentSize().height then
            y = display.size.height - container:getContentSize().height
        end
        container:setPositionY(y)
    end
    local function onTouchEnded(touch, event)
        local p = touch:getLocation()
        if p.y > display.size.height - scene.max_diametre and p.x < scene.max_diametre then
            cc.Director:getInstance():popScene()
        end
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    scene:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, scene)

    local lbl_title = app.label('Tutorial', 52, true)
    lbl_title:setColor(app.res.colours.front._3b)
    lbl_title:setAnchorPoint(cc.p(1, 1))
    lbl_title:setNormalizedPosition(cc.p(1, 1))
    scene:addChild(lbl_title)

    local main_img = cc.Sprite:create('res/images/tutorial.png')
    main_img:setAnchorPoint(cc.p(0, 0))
    main_img:setScale((display.size.width - 12) / main_img:getContentSize().width)
    container:addChild(main_img)
    -- the animation
    local hand_phone_img = cc.Sprite:create('res/images/hand-and-phone.png')
    hand_phone_img:setNormalizedPosition(cc.p(0.282, 0.47))
    hand_phone_img:setScale(display.size.width * 0.5 / hand_phone_img:getContentSize().width)
    main_img:addChild(hand_phone_img)
    hand_phone_img:runAction(cc.RepeatForever:create(cc.Sequence:create(
      cc.MoveBy:create(0.12, cc.p(0, 30 * display.ratio)),
      cc.DelayTime:create(0.2),
      cc.MoveBy:create(0.6, cc.p(0, -30 * display.ratio)),
      cc.DelayTime:create(0.5),
      cc.MoveBy:create(0.12, cc.p(30 * display.ratio, 0)),
      cc.DelayTime:create(0.2),
      cc.MoveBy:create(0.6, cc.p(-30 * display.ratio, 0)),
      cc.DelayTime:create(0.5)
    )))
    -- the instructions
    local lbl_step1 = app.label('Hold your device top-down like this', 32, false, nil, display.size.width * 0.6)
    lbl_step1:setColor(app.res.colours.front._3b)
    lbl_step1:setAnchorPoint(cc.p(0, 1))
    lbl_step1:setNormalizedPosition(cc.p(0.07, 0.9))
    main_img:addChild(lbl_step1)
    local lbl_step2 = app.label('And shake it like this', 32, false, nil, display.size.width * 0.4)
    lbl_step2:setColor(app.res.colours.front._3b)
    lbl_step2:setAnchorPoint(cc.p(1, 0.5))
    lbl_step2:setNormalizedPosition(cc.p(0.95, 0.5))
    main_img:addChild(lbl_step2)
    local lbl_step3_1 = app.label('Don\'t know about 2048?', 38, true)
    lbl_step3_1:setColor(app.res.colours.front._3b)
    lbl_step3_1:setNormalizedPosition(cc.p(0.5, 0.2))
    main_img:addChild(lbl_step3_1)
    local lbl_step3_2 = app.label('See http://git.io/2048 for help', 32)
    lbl_step3_2:setColor(app.res.colours.front._3b)
    lbl_step3_2:setNormalizedPosition(cc.p(0.5, 0.14))
    main_img:addChild(lbl_step3_2)
    local lbl_addition = app.label(
      'This is only a game based on 2048, and copied some of its code,'
      .. ' but this is not its fork.'
      .. ' This is only a clone, not the official 2048.',
      20, false, nil, display.size.width * 1.2)
    lbl_addition:setColor(app.res.colours.front._3b)
    lbl_addition:setNormalizedPosition(cc.p(0.5, 0.06))
    main_img:addChild(lbl_addition)

    local biggest_size = main_img:getContentSize()
    container:setContentSize(biggest_size)
    container:setPositionY(display.size.height - container:getContentSize().height)

    return scene
end
