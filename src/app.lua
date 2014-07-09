app = {}
app.res = { fonts = {} }
display = {}

function app.init_globalvars()
    app.res.fonts.bold = 'res/fonts/ClearSans-Bold-webfont.ttf'
    app.res.fonts.regular = 'res/fonts/ClearSans-Regular-webfont.ttf'
    display.size = cc.Director:getInstance():getVisibleSize()

    -- check if is running on a laptop
    app.on_laptop = platform == cc.PLATFORM_OS_LINUX
      or platform == cc.PLATFORM_OS_MAC or platform == cc.PLATFORM_OS_WINDOWS
    app.on_portable = not app.on_laptop
end

function app.label(text, size, isbold, alignment, linesize)
    isbold = isbold or false
    linesize = linesize or 0
    local ttfpath, _alignment
    if isbold then ttfpath = app.res.fonts.bold
    else ttfpath = app.res.fonts.regular end
    if alignment == 'right' then _alignment = cc.VERTICAL_TEXT_ALIGNMENT_RIGHT
    elseif alignment == 'left' then _alignment = cc.VERTICAL_TEXT_ALIGNMENT_LEFT
    else _alignment = cc.VERTICAL_TEXT_ALIGNMENT_CENTER end
    return cc.Label:createWithTTF(
      { fontFilePath = ttfpath, fontSize = size }, _alignment, linesize)
end
