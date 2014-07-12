require 'src/scenes/_soda_base'
require 'src/widgets/board'
require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.gameplay = app.scenes.gameplay or {}
app.scenes.gameplay.boardsize = 4

function app.scenes.gameplay:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b)
    scene:addChild(bg, -1)

    -- the big '2048' in the top-left corner
    local max_diametre = math.min(
      display.size.height - display.size.width,
      display.size.width / app.scenes.gameplay.boardsize * 2)
    local bbl_title = app.widgets.bubble:create(max_diametre - 12, app.res.colours.tile[2048][1])
    bbl_title:setAnchorPoint(cc.p(0, 1))
    bbl_title:setPosition(cc.p(6, display.size.height - 6))
    scene:addChild(bbl_title, 1)
    local lbl_title = app.label('2048', 72, true)
    lbl_title:setColor(app.res.colours.tile[2048][2])
    lbl_title:setPosition(cc.p(max_diametre * 0.5, display.size.height - max_diametre * 0.5))
    scene:addChild(lbl_title, 2)
    local lbl_goback = app.label('Tap to go back', 24, false)
    lbl_goback:setColor(app.res.colours.tile[2048][2])
    lbl_goback:setPosition(cc.pSub(cc.p(lbl_title:getPosition()), cc.p(0, lbl_title:getContentSize().height / 2)))
    scene:addChild(lbl_goback, 2)

    -- the 'go back' button
    local function onTouchBegan(touch, event)
        local p = touch:getLocation()
        return p.y > display.size.height - max_diametre and p.x < max_diametre
    end
    local function onTouchEnded(touch, event)
        local p = touch:getLocation()
        if p.y > display.size.height - max_diametre and p.x < max_diametre then
            print('go back')
            cc.Director:getInstance():popScene()
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
      (display.size.width + max_diametre) * 0.5, display.size.height - max_diametre * 0.2))
    scene:addChild(lbl_score)
    local score_disp = app.label('0', 45, true)
    score_disp:setColor(app.res.colours.front._3b)
    score_disp:setPosition(cc.p(
      (display.size.width + max_diametre) * 0.5, display.size.height - max_diametre * 0.4))
    scene:addChild(score_disp)
    -- high score
    local lbl_hiscore = app.label('BEST', 30, false)
    lbl_hiscore:setColor(app.res.colours.front._3b)
    lbl_hiscore:setPosition(cc.p(
      (display.size.width + max_diametre) * 0.5, display.size.height - max_diametre * 0.6))
    scene:addChild(lbl_hiscore)
    local hi_score = cc.UserDefault:getInstance():getIntegerForKey('high_score', 0)
    local hiscore_disp = app.label(tostring(hi_score), 45, true)
    hiscore_disp:setColor(app.res.colours.front._3b)
    hiscore_disp:setPosition(cc.p(
      (display.size.width + max_diametre) * 0.5, display.size.height - max_diametre * 0.8))
    scene:addChild(hiscore_disp)

    -- the board, or grid (in gabrielecirulli/2048)
    local board = app.widgets.board:create(app.scenes.gameplay.boardsize, display.size.width)
    board:setPositionY(display.size.height - display.size.width - max_diametre)
    scene:addChild(board)

    -- generate two random tiles
    board:gen_random()
    board:gen_random()

    -- handle shake events
    scene:setOnShakeCallback(function(self, direction)
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
              cc.UserDefault:getInstance():setIntegerForKey('high_score', hi_score)
              cc.UserDefault:getInstance():flush()
          end
      end
    end)

    return scene
end
