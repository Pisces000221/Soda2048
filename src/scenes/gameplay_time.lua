require 'src/scenes/_soda_base'
require 'src/scenes/gameplay'

app.scenes = app.scenes or {}
app.scenes.gameplay_time = app.scenes.gameplay_time or {}

function app.scenes.gameplay_time:create()
    local scene = app.scenes.gameplay:create('timetrial_high_score')
    local score_disp = scene:getChildByTag(app.scenes.gameplay.score_disp_tag)
    local hiscore_disp = scene:getChildByTag(app.scenes.gameplay.hiscore_disp_tag)
    local board = scene:getChildByTag(app.scenes.gameplay.board_tag)

    -- schedule generating tiles
    local tilegen_schedule_entry = scene:getScheduler():scheduleScriptFunc(function()
        if scene.game_over then return end
        if board:game_over() then scene:end_game() end
        print('gen tile')
        board:gen_random()
    end, 0.5, false)
    -- this is called by scenes.gameplay
    scene.goback = function()
        scene:getScheduler():unscheduleScriptEntry(tilegen_schedule_entry)
    end

    -- board doesn't generate new tiles after a move
    board.generates_new_after_move = false
    board.lose_conditions = app.widgets.board.lose_conditions.grid_full

    return scene
end
