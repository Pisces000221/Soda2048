require 'src/scenes/_soda_base'
require 'src/widgets/board'
require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.gameplay = app.scenes.gameplay or {}

function app.scenes.gameplay:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b)
    scene:addChild(bg, -1)

    -- the big '2048' in the top-left corner
    local max_diametre = display.size.height - display.size.width
    local bbl_title = app.widgets.bubble:create(max_diametre - 12, app.res.colours.tile[2048][1])
    bbl_title:setAnchorPoint(cc.p(0, 1))
    bbl_title:setPosition(cc.p(6, display.size.height - 6))
    scene:addChild(bbl_title, 1)
    local lbl_title = app.label('2048', 72, true)
    lbl_title:setColor(app.res.colours.tile[2048][2])
    lbl_title:setPosition(cc.p(max_diametre * 0.5, display.size.height - max_diametre * 0.5))
    scene:addChild(lbl_title, 2)

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
    local hiscore_disp = app.label('0', 45, true)
    hiscore_disp:setColor(app.res.colours.front._3b)
    hiscore_disp:setPosition(cc.p(
      (display.size.width + max_diametre) * 0.5, display.size.height - max_diametre * 0.8))
    scene:addChild(hiscore_disp)

    -- the board, or grid (in gabrielecirulli/2048)
    local board = app.widgets.board:create(4, display.size.width)
    scene:addChild(board)

    -- generate two random tiles
    board:gen_random()
    board:gen_random()

    -- handle shake events
    scene:setOnShakeCallback(function(self, direction)
      if direction == 1 then board:gen_random() end
    end)

    return scene
end
