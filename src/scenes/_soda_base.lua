app.scenes = app.scenes or {}
app.scenes._soda_base = app.scenes._soda_base or {}
app.scenes._soda_base.min_move_interval = 0.5
app.scenes._soda_base.min_move_acc = 0.6

function app.scenes._soda_base:create()
    local scene = cc.Scene:create()
    local c = cc.Layer:create()
    scene:addChild(c)

    -- direction: 1, 2, 3, 4 means up, down, left, right
    scene._onShake = function(self, direction) end
    scene.setOnShakeCallback = function(self, fun) self._onShake = fun end

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
    c:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, c)

    local function onNodeEvent(event)
        if event == 'enter' then
            c:setAccelerometerEnabled(true)
        elseif event == 'exit' then
            c:setAccelerometerEnabled(false)
        end
    end
    c:registerScriptHandler(onNodeEvent)

    return scene
end
