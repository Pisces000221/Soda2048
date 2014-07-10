app.scenes = app.scenes or {}
app.scenes._soda_base = app.scenes._soda_base or {}
app.scenes._soda_base.min_move_interval = 0.5
app.scenes._soda_base.min_move_acc = 0.6

function app.scenes._soda_base:create()
    local scene = cc.Scene:create()
    -- add an empty layer to handle events
    -- all we need is its event dispatcher
    local emptylayer = cc.Layer:create()
    scene:addChild(emptylayer)

    -- direction: 1, 2, 3, 4 means up, down, left, right
    scene._onShake = function(self, direction) end
    scene.setOnShakeCallback = function(self, fun) self._onShake = fun end

if app.on_mobile then   -- #if IS_ON_MOBILE
    local last_move_time = -1
    local function onAcceleration(event, x, y, z, timestamp)
        print(os.clock())
        if os.clock() > last_move_time + app.scenes._soda_base.min_move_interval then
            if x > app.scenes._soda_base.min_move_acc then last_move_time = os.clock(); scene:_onShake(3);
            elseif x < -app.scenes._soda_base.min_move_acc then last_move_time = os.clock(); scene:_onShake(4);
            elseif y > app.scenes._soda_base.min_move_acc then last_move_time = os.clock(); scene:_onShake(2);
            elseif y < -app.scenes._soda_base.min_move_acc then last_move_time = os.clock(); scene:_onShake(1);
            end
        end
    end
    -- for debug use (on laptops)
    --scene:getScheduler():scheduleScriptFunc(function() onAcceleration(nil, 1, 0, 0, 0) end, 2, false)

    local listener = cc.EventListenerAcceleration:create(onAcceleration)
    emptylayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, emptylayer)

    local function onNodeEvent(event)
        if event == 'enter' then
            emptylayer:setAccelerometerEnabled(true)
        elseif event == 'exit' then
            emptylayer:setAccelerometerEnabled(false)
        end
    end
    emptylayer:registerScriptHandler(onNodeEvent)

else    -- #else
    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_UP_ARROW then scene:_onShake(1)
        elseif keyCode == cc.KeyCode.KEY_DOWN_ARROW then scene:_onShake(2)
        elseif keyCode == cc.KeyCode.KEY_LEFT_ARROW then scene:_onShake(3)
        elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW then scene:_onShake(4)
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    emptylayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, emptylayer)
end     -- #endif

    return scene
end
