require 'src/scenes/_soda_base'
require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.splash = app.scenes.splash or {}

function app.scenes.splash:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(cc.c4b(255, 255, 255, 255));
    scene:addChild(bg, -1)

    local logo = cc.Sprite:create('res/images/cocos2dx_portrait.png')
    logo:setOpacity(128)
    logo:setAnchorPoint(cc.p(0, 1))
    logo:setNormalizedPosition(cc.p(-0.1, 1.1))
    logo:setScale(display.size.height / logo:getContentSize().height)
    scene:addChild(logo)

    local lbl_1 = app.label('Powered by', 54, false)
    lbl_1:setColor(cc.c3b(0, 0, 0))
    lbl_1:setNormalizedPosition(cc.p(0.7, 0.3))
    scene:addChild(lbl_1)
    local lbl_2 = app.label('Cocos2d-x', 64, true)
    lbl_2:setColor(cc.c3b(0, 0, 0))
    lbl_2:setNormalizedPosition(cc.p(0.7, 0.18))
    scene:addChild(lbl_2)

    scene:setOnShakeCallback(function(self, direction)
        local s = { [1] = 'up', [2] = 'down', [3] = 'left', [4] = 'right' }
        lbl_2:setString(s[direction])
    end)

    return scene
end
