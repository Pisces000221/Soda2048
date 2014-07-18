-- Hey, are you sure this is a 'tile'???
-- It's a circle!!! A bubble!!!
app.widgets = app.widgets or {}
app.widgets.tile = app.widgets.tile or {}
app.widgets.tile.label_tag = 147106

require 'src/widgets/bubble'

-- create(int value, number width): create a [value] tile
--  with a width/diametre of [width], value = 2, 4, 8, ..., 2^n (n E N+)
function app.widgets.tile:create(value, width)
    local bubble = app.widgets.bubble:create(width, cc.c3b(0, 0, 0))
    local label = app.label('', width * 0.5 / display.ratio, true)
    label:setNormalizedPosition(cc.p(0.5, 0.5))
    bubble:addChild(label, 5, app.widgets.tile.label_tag)
    bubble.set_value = app.widgets.tile.set_value
    bubble:set_value(value)
    return bubble
end

function app.widgets.tile:set_value(value)
    self.value = value
    -- 'setColor' is inherited from bubble<-sprite
    self:setColor(app.res.colours.tile[value][1])
    local label = self:getChildByTag(app.widgets.tile.label_tag)
    label:setString(tostring(value))
    label:setColor(app.res.colours.tile[value][2])
    label:setCascadeOpacityEnabled(true)
    if label:getContentSize().width > self:getContentSize().width * 0.8 then
        label:setScale(label:getContentSize().width * 0.8 / label:getContentSize().width)
    end
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
