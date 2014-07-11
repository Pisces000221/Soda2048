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
