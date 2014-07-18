app = {}
app.res = {}
display = {}

require 'Cocos2d'
require 'src/app'
require 'src/scenes/splash'
inspect = require('src/libs/inspect')

function logtable(t)
    print(inspect.inspect(t))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print('> COCOS-LUA: ' .. tostring(msg) .. '\n')
    print(debug.traceback())
    return msg
end

local function main()
    -- avoid memory leak
    collectgarbage('collect')
    collectgarbage('setpause', 100)
    collectgarbage('setstepmul', 5000)
    math.randomseed(os.time())
    cc.FileUtils:getInstance():addSearchResolutionsOrder('src')
    cc.FileUtils:getInstance():addSearchResolutionsOrder('res')
    app.init_globalvars()

    -- support debugging
    local platform = cc.Application:getInstance():getTargetPlatform()
    if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD
      or platform == cc.PLATFORM_OS_ANDROID or platform == cc.PLATFORM_OS_WINDOWS
      or platform == cc.PLATFORM_OS_MAC then
        print('DEBUGGING ENABLED')
        cc.Director:getInstance():getConsole():listenOnTCP(5678)
    else
        print('UNABLE TO DEBUG UNDER THIS PLATFORM...')
    end

    -- run
    local scene = app.scenes.splash:create()
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then error(msg) end

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
