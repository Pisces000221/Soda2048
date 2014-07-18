-- A Javascript-like array.
-- Since we copied some code in gabrielecirulli/2048 on GitHub,
--  this makes it easier for us to copy his code. Thanks gabrielecirulli :)

app.data = app.data or {}
app.data.js_array = {}

function app.data.js_array.new()
    local r = {}
    r.push = function(self, value) self[#self + 1] = value end
    r.reverse = function(self)
        local R = {}
        for i = 1, #self do R[#self - i + 1] = self[i] end
        return R
    end
    return r
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
