require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.splash = app.scenes.splash or {}
app.scenes.splash.bubcolours = {
    [1] = cc.c3b(255, 128, 128),
    [2] = cc.c3b(128, 255, 128),
    [3] = cc.c3b(128, 128, 255)
}

function app.scenes.splash:create()
    local scene = cc.Scene:create()
    local bg = cc.LayerColor:create(cc.c4b(255, 255, 255, 255));
    scene:addChild(bg, -1)

    local bubbles = {}
    for i = 1, 3 do
        bubbles[i] = app.widgets.bubble:create(60, app.scenes.splash.bubcolours[i])
        bubbles[i]:setPositionX(display.size.width * i * 0.25)
        scene:addChild(bubbles[i], i)
    end
    local liner = cc.DrawNode:create()
    liner:drawSegment(
      cc.p(0, display.size.height / 2),
      cc.p(display.size.width, display.size.height / 2),
      1, cc.c4f(0, 0, 0, 1))
    liner:drawSegment(
      cc.p(0, display.size.height / 4),
      cc.p(display.size.width, display.size.height / 4),
      1, cc.c4f(1, 1, 0, 1))
    liner:drawSegment(
      cc.p(0, display.size.height * 3 / 4),
      cc.p(display.size.width, display.size.height * 3 / 4),
      1, cc.c4f(1, 1, 0, 1))
    scene:addChild(liner, 4)

    local label = app.label('None', 48, true)
    label:setColor(cc.c3b(0, 0, 0))
    label:setOpacity(128)
    label:setNormalizedPosition(cc.p(0.5, 0.5))
    scene:addChild(label, 5)

    local last_move_time = -1
    local function onAcceleration(event, x, y, z, timestamp)
        bubbles[1]:setPositionY(display.size.height * (0.5 + x * 0.25))
        bubbles[2]:setPositionY(display.size.height * (0.5 + y * 0.25))
        bubbles[3]:setPositionY(display.size.height * (0.5 + z * 0.25))
        if os.clock() > last_move_time + 0.5 then
            if x > 0.6 then label:setString('Left'); last_move_time = os.clock(); print(last_move_time)
            elseif x < -0.6 then label:setString('Right'); last_move_time = os.clock(); print(last_move_time)
            elseif y > 0.6 then label:setString('Down'); last_move_time = os.clock(); print(last_move_time)
            elseif y < -0.6 then label:setString('Up'); last_move_time = os.clock(); print(last_move_time)
            end
        end
    end

    local listener = cc.EventListenerAcceleration:create(onAcceleration)
    bg:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, bg)
    onAcceleration(nil, 0, 0, 0, 0)

    local function onNodeEvent(event)
        if event == 'enter' then
            bg:setAccelerometerEnabled(true)
        elseif event == 'exit' then
            bg:setAccelerometerEnabled(false)
        end
    end
    bg:registerScriptHandler(onNodeEvent)

    return scene
end
