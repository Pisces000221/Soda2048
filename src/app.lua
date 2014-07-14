app = {}
app.res = { fonts = {}, colours = {} }
app.prefs = {}
display = {}

function app.init_globalvars()
    app.res.fonts.bold = 'res/fonts/ClearSans-Bold-webfont.ttf'
    app.res.fonts.regular = 'res/fonts/ClearSans-Regular-webfont.ttf'
    app.res.colours.background = { _4b = cc.c4b(0xfa, 0xf8, 0xef, 0xff), _3b = cc.c3b(0xfa, 0xf8, 0xef) }
    app.res.colours.front = { _4b = cc.c4b(0x77, 0x6e, 0x65, 0xff), _3b = cc.c3b(0x77, 0x6e, 0x65) }
    app.res.colours.front_dark = { _4b = cc.c4b(0x47, 0x3e, 0x35, 0xff), _3b = cc.c3b(0x47, 0x3e, 0x35) }
    app.res.colours.soda = { _4b = cc.c4b(0xff, 0xdf, 0x00, 0xff), _3b = cc.c3b(0xff, 0xdf, 0x00) }
    app.res.colours.tile = {
       [2] = { cc.c3b(0xee, 0xe4, 0xda), app.res.colours.front._3b },
       [4] = { cc.c3b(0xed, 0xe0, 0xc8), app.res.colours.front._3b },
       [8] = { cc.c3b(0xf2, 0xb1, 0x79), cc.c3b(0xf9, 0xf6, 0xf2) },
      [16] = { cc.c3b(0xf5, 0x95, 0x63), cc.c3b(0xf9, 0xf6, 0xf2) },
      [32] = { cc.c3b(0xf6, 0x7c, 0x5f), cc.c3b(0xf9, 0xf6, 0xf2) },
      [64] = { cc.c3b(0xf6, 0x5e, 0x3b), cc.c3b(0xf9, 0xf6, 0xf2) },
     [128] = { cc.c3b(0xed, 0xcf, 0x72), cc.c3b(0xf9, 0xf6, 0xf2) },
     [256] = { cc.c3b(0xed, 0xcc, 0x61), cc.c3b(0xf9, 0xf6, 0xf2) },
     [512] = { cc.c3b(0xed, 0xc8, 0x50), cc.c3b(0xf9, 0xf6, 0xf2) },
    [1024] = { cc.c3b(0xed, 0xc5, 0x3f), cc.c3b(0xf9, 0xf6, 0xf2) },
    [2048] = { cc.c3b(0xed, 0xc2, 0x2e), cc.c3b(0xf9, 0xf6, 0xf2) },
    [4096] = { cc.c3b(0x3c, 0x3a, 0x32), cc.c3b(0xf9, 0xf6, 0xf2) }
    }
    app.res.colours.cell = { _4b = cc.c4b(238, 228, 218, 0.35 * 255), _3b = cc.c3b(238, 228, 218) }
    app.res.colours.game_container = { _4b = cc.c4b(0xbb, 0xad, 0xa0, 255), _3b = cc.c3b(0xbb, 0xad, 0xa0) }
    display.size = cc.Director:getInstance():getVisibleSize()
    display.ratio = display.size.width / 400    -- 400 is used for debugging on laptops

    -- check if is running on a laptop
    local platform = cc.Application:getInstance():getTargetPlatform()
    app.on_laptop = platform == cc.PLATFORM_OS_LINUX
      or platform == cc.PLATFORM_OS_MAC or platform == cc.PLATFORM_OS_WINDOWS
    app.on_mobile = not app.on_laptop
    print('I see a platform numbered ' .. platform)
    if app.on_mobile then print('Mm-hm. I think I\'m running on a mobile device.')
    else print('Huh? Am I on a laptop?') end

    -- read config
    app.prefs.sensitivity_default = 0.6
    app.prefs.sensitivity = cc.UserDefault:getInstance():getFloatForKey('acc_sensitivity', app.prefs.sensitivity_default)
end

function app.label(text, size, isbold, alignment, linesize)
    size = size * display.ratio
    isbold = isbold or false
    linesize = linesize or 0
    local ttfpath, _alignment
    if isbold then ttfpath = app.res.fonts.bold
    else ttfpath = app.res.fonts.regular end
    if alignment == 'right' then _alignment = cc.VERTICAL_TEXT_ALIGNMENT_RIGHT
    elseif alignment == 'left' then _alignment = cc.VERTICAL_TEXT_ALIGNMENT_LEFT
    else _alignment = cc.VERTICAL_TEXT_ALIGNMENT_CENTER end
    return cc.Label:createWithTTF(
      { fontFilePath = ttfpath, fontSize = size }, text, _alignment, linesize)
end

-- creates a label on the side of the screen.
-- int side = 1, 2, 3, 4 means up, down, left or right
local sidelabel_pos = { [1] = cc.p(0.5, 1), [2] = cc.p(0.5, 0), [3] = cc.p(0, 0.5), [4] = cc.p(1, 0.5) }
function app.sidelabel(side, text, size, isbold, alignment, linesize)
    local label = app.label(text, size, isbold, alignment, linesize)
    -- labels 3 & 4 need rotation round point (0.5, 1)
    if side == 2 then label:setAnchorPoint(cc.p(0.5, 0))
    else label:setAnchorPoint(cc.p(0.5, 1)) end
    if side > 2 then label:setRotation((side - 3.5) * 180) end
    -- set the position (normalized)
    label:setNormalizedPosition(sidelabel_pos[side])
    return label
end

function app.add_2048_title(scene)
    local max_diametre = math.min(
      display.size.height - display.size.width,
      display.size.width / app.scenes.gameplay.boardsize * 2)
    scene.max_diametre = max_diametre
    local bbl_title = app.widgets.bubble:create(max_diametre - 12, app.res.colours.tile[2048][1])
    bbl_title:setOpacity(108)
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
end

function display.normalize(x, y)
    return cc.p(x * display.size.width, y * display.size.height)
end
