app = {}
app.res = { fonts = {} }
display = {}

require 'Cocos2d'
require 'src/scenes/splash'

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print('> COCOS-LUA: ' .. tostring(msg) .. '\n')
    print(debug.traceback())
    return msg
end

local function init_globalvars()
    app.res.fonts.bold = 'fonts/ClearSans-Bold-webfont.ttf'
    app.res.fonts.regular = 'fonts/ClearSans-Regular-webfont.ttf'
    display.size = cc.Director:getInstance():getVisibleSize()
end

local function main()
    -- avoid memory leak
    collectgarbage('collect')
    collectgarbage('setpause', 100)
    collectgarbage('setstepmul', 5000)
    math.randomseed(os.time())
    cc.FileUtils:getInstance():addSearchResolutionsOrder('src')
    cc.FileUtils:getInstance():addSearchResolutionsOrder('res')
    init_globalvars()

    -- support debugging
    local platform = cc.Application:getInstance():getTargetPlatform()
    if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD
      or platform == cc.PLATFORM_OS_ANDROID or platform == cc.PLATFORM_OS_WINDOWS
      or platform == cc.PLATFORM_OS_MAC then
        print('DEBUGGING ENABLED')
    else
        print('UNABLE TO DEBUG UNDER THIS PLATFORM...')
    end

    -- check if is running on a laptop
    app.on_laptop = platform == cc.PLATFORM_OS_LINUX
      or platform == cc.PLATFORM_OS_MAC or platform == cc.PLATFORM_OS_WINDOWS
    app.on_portable = not app.on_laptop

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
