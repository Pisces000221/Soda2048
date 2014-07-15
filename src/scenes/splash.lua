require 'src/scenes/_soda_base'
require 'src/scenes/startup'
require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.splash = app.scenes.splash or {}

function app.scenes.splash:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(cc.c4b(255, 255, 255, 255));
    scene:addChild(bg, -1)

    local logo = cc.Sprite:create('res/images/cocos2dx_portrait.png')
    logo:setOpacity(108)
    logo:setAnchorPoint(cc.p(0, 1))
    logo:setNormalizedPosition(cc.p(-0.1, 1.1))
    logo:setScale(display.size.height / logo:getContentSize().height)
    scene:addChild(logo)

    local lbl_1 = app.label('Powered by', 44, false)
    lbl_1:setColor(cc.c3b(0, 0, 0))
    lbl_1:setNormalizedPosition(cc.p(0.618, 0.2))
    scene:addChild(lbl_1)
    local lbl_2 = app.label('Cocos2d-x', 54, true)
    lbl_2:setColor(cc.c3b(0, 0, 0))
    lbl_2:setNormalizedPosition(cc.p(0.618, 0.12))
    scene:addChild(lbl_2)

    scene:setOnShakeCallback(function(self, direction)
        local s = { [1] = 'up', [2] = 'down', [3] = 'left', [4] = 'right' }
        lbl_2:setString(s[direction])
    end)

    local schid = 0
    schid = scene:getScheduler():scheduleScriptFunc(function()
      local next_scene = app.scenes.startup:create()
      local c = app.res.colours.background._3b
      c.r = (0xff + c.r) * 0.5
      c.g = (0xff + c.g) * 0.5
      c.b = (0xff + c.b) * 0.5
      cc.Director:getInstance():replaceScene(cc.TransitionFade:create(0.5, next_scene, c))
      scene:getScheduler():unscheduleScriptEntry(schid)
    end, 2, false)

    return scene
end
