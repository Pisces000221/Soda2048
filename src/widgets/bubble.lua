app.widgets = app.widgets or {}
app.widgets.bubble = app.widgets.bubble or {}

-- create(number diametre, cc.c3b colour)
function app.widgets.bubble:create(diametre, colour)
    local sprite
    if diametre >= 144 then sprite = cc.Sprite:create('res/images/circle_3x.png')
    elseif diametre >= 96 then sprite = cc.Sprite:create('res/images/circle_2x.png')
    elseif diametre >= 64 then sprite = cc.Sprite:create('res/images/circle_1.5x.png')
    else sprite = cc.Sprite:create('res/images/circle.png') end
    sprite:setScale(diametre / sprite:getContentSize().width)
    sprite:setColor(colour)
    return sprite
end
