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

--[[
    Soda2048
    Copyright (C) 2014  Pisces000221 (Shiqing Lyu)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]
