require 'src/scenes/_soda_base'
require 'src/widgets/board'
require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.gameplay = app.scenes.gameplay or {}
app.scenes.gameplay.boardsize = 4
app.scenes.gameplay.score_disp_tag = 492357816
app.scenes.gameplay.hiscore_disp_tag = 438951276
app.scenes.gameplay.board_tag = 400000006
app.scenes.gameplay.game_over_cover_tag = 1875329

function app.scenes.gameplay:create(highscore_key)
    local scene = app.scenes._soda_base:create()
    highscore_key = highscore_key or 'classical_high_score'
    scene.highscore_key = highscore_key
    local bg = cc.LayerColor:create(app.res.colours.background._4b)
    scene:addChild(bg, -1)

    -- used locally
    scene.game_over = false
    -- used in classes that derive this class
    scene.goback = function() end
    scene.restart_game = function(self)
        self.game_over = false
        self:getChildByTag(app.scenes.gameplay.game_over_cover_tag):removeFromParent()
        self:getChildByTag(app.scenes.gameplay.board_tag):clear_and_restart()
        self:getChildByTag(app.scenes.gameplay.score_disp_tag):setString('0')
    end
    scene.end_game = function(self)
        self.game_over = true
        local cover = cc.LayerColor:create(cc.c4b(237, 194, 46, 192),
          display.size.width, display.size.width)
        cover:setPositionY(display.size.height - display.size.width - self.max_diametre)
        self:addChild(cover, 100, app.scenes.gameplay.game_over_cover_tag)
        local lbl_game_over = app.label('Game Over!', 44, true)
        lbl_game_over:setColor(app.res.colours.front._3b)
        lbl_game_over:setOpacity(0)
        lbl_game_over:setPosition(display.normalize(0.5, 0.35))
        lbl_game_over:runAction(cc.Sequence:create(
          cc.FadeIn:create(0.5),
          cc.EaseSineInOut:create(cc.MoveTo:create(0.5, display.normalize(0.5, 0.45)))
        ))
        cover:addChild(lbl_game_over)
        local lbl_final_score = app.label('Final score: '
          .. self:getChildByTag(app.scenes.gameplay.board_tag).score
          .. '\nTap to restart', 36)
        lbl_final_score:setColor(app.res.colours.front._3b)
        lbl_final_score:setOpacity(0)
        lbl_final_score:setNormalizedPosition(cc.p(0.5, 0.4))
        lbl_final_score:runAction(cc.Sequence:create(
          cc.DelayTime:create(0.5), cc.FadeIn:create(0.5)
        ))
        cover:addChild(lbl_final_score)
    end

    -- the big '2048' in the top-left corner
    app.add_2048_title(scene)

    -- the 'go back' button
    local intend_back, intend_restart = false, false
    local function onTouchBegan(touch, event)
        local p = touch:getLocation()
        intend_back = p.y > display.size.height - scene.max_diametre and p.x < scene.max_diametre
        intend_restart = scene.game_over and
           p.y >= display.size.height - display.size.width - scene.max_diametre and
           p.y <= display.size.height - scene.max_diametre
        return intend_back or intend_restart
    end
    local function onTouchEnded(touch, event)
        local p = touch:getLocation()
        local p1 = touch:getStartLocation()
        if intend_back and p.y > display.size.height - scene.max_diametre and p.x < scene.max_diametre then
            scene.goback()
            cc.Director:getInstance():popScene()
        elseif intend_restart and
          p.y >= display.size.height - display.size.width - scene.max_diametre and
          p.y <= display.size.height - scene.max_diametre then
            scene:restart_game()
        end
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    scene:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, scene)

    -- the score board
    -- current score
    local lbl_score = app.label('SCORE', 30, false)
    lbl_score:setColor(app.res.colours.front._3b)
    lbl_score:setPosition(cc.p(
      (display.size.width + scene.max_diametre) * 0.5, display.size.height - scene.max_diametre * 0.2))
    scene:addChild(lbl_score)
    local score_disp = app.label('0', 45, true)
    score_disp:setColor(app.res.colours.front._3b)
    score_disp:setPosition(cc.p(
      (display.size.width + scene.max_diametre) * 0.5, display.size.height - scene.max_diametre * 0.4))
    scene:addChild(score_disp, 0, app.scenes.gameplay.score_disp_tag)
    -- high score
    local lbl_hiscore = app.label('BEST', 30, false)
    lbl_hiscore:setColor(app.res.colours.front._3b)
    lbl_hiscore:setPosition(cc.p(
      (display.size.width + scene.max_diametre) * 0.5, display.size.height - scene.max_diametre * 0.6))
    scene:addChild(lbl_hiscore)
    local hi_score = cc.UserDefault:getInstance():getIntegerForKey(scene.highscore_key, 0)
    local hiscore_disp = app.label(tostring(hi_score), 45, true)
    hiscore_disp:setColor(app.res.colours.front._3b)
    hiscore_disp:setPosition(cc.p(
      (display.size.width + scene.max_diametre) * 0.5, display.size.height - scene.max_diametre * 0.8))
    scene:addChild(hiscore_disp, 0, app.scenes.gameplay.hiscore_disp_tag)

    -- the board, or grid (in gabrielecirulli/2048)
    local board = app.widgets.board:create(app.scenes.gameplay.boardsize, display.size.width)
    board:setPositionY(display.size.height - display.size.width - scene.max_diametre)
    scene:addChild(board, 0, app.scenes.gameplay.board_tag)

    -- board settings (default)
    board.generates_new_after_move = true
    board.lose_conditions = app.widgets.board.lose_conditions.no_moves_available

    -- handle shake events
    scene:setOnShakeCallback(function(self, direction)
      if self.game_over then return end
      local prev_score = board.score
      board:move(direction)
      if prev_score ~= board.score then
          score_disp:setString(tostring(board.score))
          local hint = app.label('+' .. board.score - prev_score, 32)
          hint:setColor(score_disp:getColor())
          hint:setPosition(cc.pAdd(cc.p(score_disp:getPosition()), cc.p(-10, 0)))
          hint:runAction(cc.Sequence:create(
            cc.Spawn:create(cc.FadeOut:create(0.75), cc.MoveBy:create(0.75, cc.p(0, 40))),
            cc.RemoveSelf:create()
          ))
          scene:addChild(hint)
          if hi_score < board.score then
              hi_score = board.score
              hiscore_disp:setString(tostring(hi_score))
              cc.UserDefault:getInstance():setIntegerForKey(scene.highscore_key, hi_score)
              cc.UserDefault:getInstance():flush()
          end
      end
      if board:game_over() then self:end_game() end
    end)

    return scene
end
