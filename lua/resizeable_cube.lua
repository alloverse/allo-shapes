--- A cube that may be moved and resized
-- @classmod Resizeable ResizeableCube

local class = require('pl.class')
local tablex = require('pl.tablex')
local pretty = require('pl.pretty')
local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")
local CubeSurface = require("cube_surface")

class.ResizeableCube(ui.View)

---
--
--~~~ lua
-- resizeableCube = ResizeableCube(bounds)
--~~~
--
-- @tparam [Bounds](bounds) bounds The ResizeableCube's initial bounds.
function ResizeableCube:_init(bounds)
    self.PI = 3.141592


    self:super(bounds)
    self.color = {1.0, 1.0, 1.0, 1.0}
    self:setPointable(true)
    self:setGrabbable(true)
    self.hasTransparency = true
    self.onTouchDown = function()
      print("Cube is at ", self.bounds.pose)
    end


    self.frontSide = CubeSurface(Bounds(0, 0, 0, self.bounds.size.width, self.bounds.size.height, 0.001):move(0, 0, self.bounds.size.depth/2))
    self:addSubview(self.frontSide)

    self.backSide = CubeSurface(Bounds(0, 0, 0, self.bounds.size.width, self.bounds.size.height, 0.001):move(0, 0, -self.bounds.size.depth/2))
    self:addSubview(self.backSide)

    self.topSide = CubeSurface(Bounds(0, 0, 0, self.bounds.size.width, self.bounds.size.depth, 0.001):rotate(self.PI/2, 1, 0, 0):move(0, self.bounds.size.height/2, 0))
    self:addSubview(self.topSide)

    self.bottomSide = CubeSurface(Bounds(0, 0, 0, self.bounds.size.width, self.bounds.size.depth, 0.001):rotate(self.PI/2, 1, 0, 0):move(0, -self.bounds.size.height/2, 0))
    self:addSubview(self.bottomSide)

    self.leftSide = CubeSurface(Bounds(0, 0, 0, self.bounds.size.depth, self.bounds.size.height, 0.001):rotate(self.PI/2, 0, 1, 0):move(-self.bounds.size.width/2, 0, 0))
    self:addSubview(self.leftSide)

    self.rightSide = CubeSurface(Bounds(0, 0, 0, self.bounds.size.depth, self.bounds.size.height, 0.001):rotate(self.PI/2, 0, 1, 0):move(self.bounds.size.width/2, 0, 0))
    self:addSubview(self.rightSide)

end

function ResizeableCube:specification()
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

--- Sets the ResizeableCube's color
-- @tparam table rgba The r, g, b and a values of the text color, each defined between 0 and 1. For example, {1, 0.5, 0, 1}
function ResizeableCube:setColor(rgba)
    self.color = rgba
    if self:isAwake() then
      local mat = self:specification().material
      self:updateComponents({
          material= mat
      })
    end
end

function ResizeableCube:onTouchDown(pointer)
  print("on touch down!")
  self:resizeX(2)
end


function ResizeableCube:resizeX(delta)
  self.bounds.size.width = self.bounds.size.width + delta
  self:updateComponents(
    self:specification()
  )
end

return ResizeableCube
