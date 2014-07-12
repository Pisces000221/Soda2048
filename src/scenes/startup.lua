require 'src/scenes/_soda_base'
require 'src/scenes/gameplay'
require 'src/scenes/gameplay_time'
require 'src/scenes/options'

app.scenes = app.scenes or {}
app.scenes.startup = app.scenes.startup or {}

function app.scenes.startup:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b);
    scene:addChild(bg, -1)

    -- show '2048' and 'Soda'
    local lbl_title = app.label('2048', 72, true)
    lbl_title:setColor(app.res.colours.front._3b)
    lbl_title:setPosition(display.normalize(0.5, 1.2))
    lbl_title:runAction(cc.Sequence:create(
      cc.DelayTime:create(1),
      cc.EaseSineOut:create(cc.MoveTo:create(1, display.normalize(0.5, 0.5))),
      cc.DelayTime:create(0.25),
      cc.EaseSineOut:create(cc.MoveTo:create(1, display.normalize(0.5, 0.42)))
    ))
    scene:addChild(lbl_title)

    local lbl_soda = app.label('Soda', 88, true)
    lbl_soda:setColor(app.res.colours.soda._3b)
    lbl_soda:setPosition(display.normalize(0.5, 0.62))
    lbl_soda:setScale(0)
    lbl_soda:runAction(cc.Sequence:create(
      cc.DelayTime:create(2.9),
      cc.EaseElasticOut:create(cc.ScaleTo:create(1, 1), 0.8),
      cc.Repeat:create(cc.Sequence:create(
      cc.MoveBy:create(0.05, cc.p(0, 10)),
      cc.MoveBy:create(0.05, cc.p(0, -10))), 4)
    ))
    scene:addChild(lbl_soda)

    local menus = { [1] = 'Classic Game', [2] = 'Time Trial', [3] = 'Tutorial', [4] = 'Options' }
    for i = 1, 4 do
        local label = app.sidelabel(i, menus[i], 36)
        label:setColor(app.res.colours.front._3b)
        label:setOpacity(0)
        label:runAction(cc.Sequence:create(
          cc.DelayTime:create(4.5),
          cc.FadeIn:create(0.5)
        ))
        scene:addChild(label)
    end

    scene:setOnShakeCallback(function(self, direction)
      if direction == 1 then
          local next_scene = app.scenes.gameplay:create()
          cc.Director:getInstance():pushScene(cc.TransitionSlideInT:create(0.5, next_scene))
      elseif direction == 2 then
          local next_scene = app.scenes.gameplay_time:create()
          cc.Director:getInstance():pushScene(cc.TransitionSlideInB:create(0.5, next_scene))
      elseif direction == 4 then
          local next_scene = app.scenes.options:create()
          cc.Director:getInstance():pushScene(cc.TransitionSlideInR:create(0.5, next_scene))
      end
    end)

    return scene
end
