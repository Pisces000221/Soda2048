app.widgets = app.widgets or {}
app.widgets.bubble = app.widgets.bubble or {}

-- create(number diametre, cc.c3b colour)
function app.widgets.bubble:create(diametre, colour)
    local sprite = cc.Sprite:create('res/images/circle.png')
    sprite:setScale(diametre / sprite:getContentSize().width)
    sprite:setColor(colour)
    return sprite
end
