--- A surface of a resizeable cube
-- @classmod Resizeable CubeSurface


local class = require('pl.class')
local tablex = require('pl.tablex')
local pretty = require('pl.pretty')
local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")

class.CubeSurface(ui.View)

---
--
--~~~ lua
-- CubeSurface = CubeSurface(bounds)
--~~~
--
-- @tparam [Bounds](bounds) bounds The CubeSurface's initial bounds.
function CubeSurface:_init(bounds)
    self:super(bounds)
    self.color = {1.0, 1.0, 1.0, 0.3}
    self:setPointable(true)
    self.hasTransparency = true
end

function CubeSurface:specification()
    local s = self.bounds.size
    local w2 = s.width / 2.0
    local h2 = s.height / 2.0
    local d2 = s.depth / 2.0
    local mySpec = tablex.union(ui.View.specification(self), {
        geometry = {
            type = "inline",
                  --   #fbl                #fbr               #ftl                #ftr             #rbl                  #rbr                 #rtl                  #rtr
            vertices= {{-w2, -h2, d2},     {w2, -h2, d2},     {-w2, h2, d2},      {w2, h2, d2},    {-w2, -h2, -d2},      {w2, -h2, -d2},      {-w2, h2, -d2},       {w2, h2, -d2}},
            uvs=      {{0.0, 0.0},         {1.0, 0.0},        {0.0, 1.0},         {1.0, 1.0},      {0.0, 0.0},           {1.0, 0.0},          {0.0, 1.0},           {1.0, 1.0}   },
            triangles= {
              {0, 1, 2}, {1, 3, 2}, -- front
              {2, 3, 6}, {3, 7, 6}, -- top
              {1, 7, 3}, {5, 7, 1}, -- right
              {5, 1, 0}, {4, 5, 0}, -- bottom
              {4, 0, 2}, {4, 2, 6}, -- left
              {4, 6, 5}, {5, 6, 7}, -- read
            },
        },
        material = {
            color = self.color
        },
    })

    return mySpec
end


function CubeSurface:onPointerEntered()
  self.color = {0.0, 1.0, 0.0, 0.3}
end

function CubeSurface:onPointerExited()
  self.color = {1.0, 1.0, 1.0, 0.3}
end

function CubeSurface:onTouchDown(pointer)
  print("CubeSurface touch down!")
end

return CubeSurface