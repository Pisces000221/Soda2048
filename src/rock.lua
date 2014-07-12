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
