app.scenes = app.scenes or {}
app.scenes.help = app.scenes.help or {}

function app.scenes.help:create()
    local scene = cc.Scene:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b);
    scene:addChild(bg, -1)

    local container = cc.Layer:create()
    scene:addChild(container)

    app.add_2048_title(scene)
    local starty = 0
    local intend_back = false
    local container_min_y = 0
    local function onTouchBegan(touch, event)
        local p = touch:getLocation()
        starty = container:getPositionY()
        intend_back = p.y > display.size.height - scene.max_diametre and p.x < scene.max_diametre
        return true
    end
    local function onTouchMoved(touch, event)
        local p = touch:getLocation()
        local y = starty + touch:getLocation().y - touch:getStartLocation().y
        if y >= 0 then y = 0
        elseif y <= container_min_y then y = container_min_y end
        container:setPositionY(y)
    end
    local function onTouchEnded(touch, event)
        local p = touch:getLocation()
        if intend_back and p.y > display.size.height - scene.max_diametre and p.x < scene.max_diametre then
            cc.Director:getInstance():popScene()
        end
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    scene:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, scene)

    local lbl_title = app.label('Help', 52, true)
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
      cc.MoveBy:create(0.1, cc.p(0, 30 * display.ratio)),
      cc.MoveBy:create(0.5, cc.p(0, -30 * display.ratio)),
      cc.DelayTime:create(0.5),
      cc.MoveBy:create(0.1, cc.p(30 * display.ratio, 0)),
      cc.MoveBy:create(0.5, cc.p(-30 * display.ratio, 0)),
      cc.DelayTime:create(0.5)
    )))
    -- the instructions
    local lbl_step1 = app.label('Hold your device top-down like this', 30, false, nil, display.size.width * 0.6)
    lbl_step1:setColor(app.res.colours.front_dark._3b)
    lbl_step1:setAnchorPoint(cc.p(0, 1))
    lbl_step1:setNormalizedPosition(cc.p(0.05, 0.9))
    main_img:addChild(lbl_step1)
    local lbl_step2 = app.label('And shake it like this', 30, false, nil, display.size.width * 0.4)
    lbl_step2:setColor(app.res.colours.front_dark._3b)
    lbl_step2:setAnchorPoint(cc.p(1, 0.55))
    lbl_step2:setNormalizedPosition(cc.p(0.95, 0.5))
    main_img:addChild(lbl_step2)
    local lbl_step3_1 = app.label('Don\'t know about 2048?', 30, true)
    lbl_step3_1:setColor(app.res.colours.front_dark._3b)
    lbl_step3_1:setNormalizedPosition(cc.p(0.5, 0.22))
    main_img:addChild(lbl_step3_1)
    local lbl_step3_2 = app.label('See http://git.io/2048 for help', 24)
    lbl_step3_2:setColor(app.res.colours.front_dark._3b)
    lbl_step3_2:setNormalizedPosition(cc.p(0.5, 0.16))
    main_img:addChild(lbl_step3_2)
    local lbl_addition = app.label(
      'This is only a game based on 2048, and copied some of its code,'
      .. ' but this is not its fork.'
      .. ' This is only a clone, not the official 2048.',
      20, false, nil, display.size.width * 0.9)
    lbl_addition:setColor(app.res.colours.front._3b)
    lbl_addition:setNormalizedPosition(cc.p(0.5, 0.06))
    main_img:addChild(lbl_addition)

    local biggest_size = main_img:getContentSize()
    biggest_size.width = biggest_size.width * main_img:getScale()
    biggest_size.height = biggest_size.height * main_img:getScale()
    container:setContentSize(biggest_size)
    container_min_y = display.size.height - container:getContentSize().height - scene.max_diametre
    container:setPositionY(container_min_y)

    return scene
end

--[[
    Soda2048
    Copyright (C) 2014  Pisces000221 (Shiqing Lyu)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]
