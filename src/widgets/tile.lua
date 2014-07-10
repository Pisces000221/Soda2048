-- Hey, are you sure this is a 'tile'???
-- It's a circle!!! A bubble!!!
app.widgets = app.widgets or {}
app.widgets.tile = app.widgets.tile or {}

require 'src/widgets/bubble'

-- create(int num, number width): create a [num] tile
--  with a width/diametre of [width], num = 2, 4, 8, ..., 2^n (n E N+)
function app.widgets.tile:create(num, width)
    local bubble = app.widgets.bubble:create(width, app.res.colours.tile[num][1])
    local label = app.label('' .. num, width * 0.5 / display.ratio, true)
    label:setColor(app.res.colours.tile[num][2])
    label:setNormalizedPosition(cc.p(0.5, 0.5))
    label:setCascadeOpacityEnabled(true)
    if label:getContentSize().width > width * 0.8 then
        label:setScale(width * 0.8 / label:getContentSize().width)
    end
    bubble:addChild(label, 5)
    return bubble
end
