app.scenes = app.scenes or {}
app.scenes._soda_base = app.scenes._soda_base or {}
app.scenes._soda_base.min_move_interval = 0.5

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
    local last_move_time = os.clock() - 1
    local function onAcceleration(event, x, y, z, timestamp)
        local cur = os.clock()
        -- sometimes os.clock() < 0 < last_move_time. maybe os.clock() is too big and 'jumped' to negative?
        -- just like (int32)32767 + 1 = (int32)-32768 ...?
        if cur > last_move_time + app.scenes._soda_base.min_move_interval or cur < last_move_time then
            if x > app.prefs.sensitivity then last_move_time = cur; scene:_onShake(3)
            elseif x < -app.prefs.sensitivity then last_move_time = cur; scene:_onShake(4)
            elseif y > app.prefs.sensitivity then last_move_time = cur; scene:_onShake(2)
            elseif y < -app.prefs.sensitivity then last_move_time = cur; scene:_onShake(1)
            end
        end
    end
    -- for debug use (on laptops)
    --scene:getScheduler():scheduleScriptFunc(function() onAcceleration(nil, 1, 0, 0, 0) end, 2, false)

    local listener = cc.EventListenerAcceleration:create(onAcceleration)
    emptylayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, emptylayer)
    emptylayer:setAccelerometerEnabled(true)

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
