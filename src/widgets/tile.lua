-- Hey, are you sure this is a 'tile'???
-- It's a circle!!! A bubble!!!
app.widgets = app.widgets or {}
app.widgets.tile = app.widgets.tile or {}
app.widgets.tile.label_tag = 147106

require 'src/widgets/bubble'

-- create(int num, number width): create a [num] tile
--  with a width/diametre of [width], num = 2, 4, 8, ..., 2^n (n E N+)
function app.widgets.tile:create(num, width)
    local bubble = app.widgets.bubble:create(width, app.res.colours.tile[num][1])
    local label = app.label('', width * 0.5 / display.ratio, true)
    label:setNormalizedPosition(cc.p(0.5, 0.5))
    bubble:addChild(label, 5, app.widgets.tile.label_tag)
    bubble.set_number = app.widgets.tile.set_number
    bubble:set_number(num)
    return bubble
end

function app.widgets.tile:set_number(num)
    -- 'setColor' is inherited from bubble<-sprite
    self:setColor(app.res.colours.tile[num][1])
    local label = self:getChildByTag(app.widgets.tile.label_tag)
    label:setString(tostring(num))
    label:setColor(app.res.colours.tile[num][2])
    label:setCascadeOpacityEnabled(true)
    if label:getContentSize().width > self:getContentSize().width * 0.8 then
        label:setScale(width * 0.8 / label:getContentSize().width)
    end
end
