app.scenes = app.scenes or {}
app.scenes.splash = app.scenes.splash or {}

function app.scenes.splash:create()
    local scene = cc.Scene:create()
    local bg = cc.LayerColor:create(cc.c4b(255, 255, 255, 255));
    scene:addChild(bg, -1)

    local label = app.label('', 48, true)
    label:setColor(cc.c3b(0, 0, 0))
    label:setNormalizedPosition(cc.p(0.5, 0.5))
    scene:addChild(label)

    local function onAcceleration(event, x, y, z, timestamp)
        label:setString(string.format('%.2f, %.2f, %.2f', x, y, z))
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
