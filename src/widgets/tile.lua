-- Hey, are you sure this is a 'tile'???
-- It's a circle!!! A bubble!!!
app.widgets = app.widgets or {}
app.widgets.tile = app.widgets.tile or {}

require 'src/widgets/bubble'

-- create(int num, number width): create a [num] tile
--  with a width/diametre of [width], num = 2, 4, 8, ..., 2^n (n E N+)
function app.widgets.tile:create(num, width)
    local bubble = app.widgets.bubble:create(width, app.res.colours.tile[num][1])
    local label = app.label('' .. num, width * 0.5, true)
    label:setColor(app.res.colours.tile[num][2])
    label:setNormalizedPosition(cc.p(0.5, 0.5))
    label:setCascadeOpacityEnabled(true)
    bubble:addChild(label, 5)
    return bubble
end
