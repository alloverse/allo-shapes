--- A cube that may be moved and resized
-- @classmod Resizeable ResizeableCube

local class = require('pl.class')
local tablex = require('pl.tablex')
local pretty = require('pl.pretty')
local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")

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

    self.frontSide = ui.Surface(bounds:copy():move(0,0, self.bounds.size.depth/2))
    self.frontSide:setColor({1, 1, 1, 0.3})
    self.frontSide:setPointable(true)
    self.frontSide.onTouchDown = function()
      print("Front surface is at ", self.frontSide.bounds.pose)
    end
    self.frontSide.onPointerEntered = function()
      self.frontSide:setColor({1, 0, 0, 0.3})
    end
    self.frontSide.onPointerExited = function()
      self.frontSide:setColor({1, 1, 1, 0.3})
    end
    self:addSubview(self.frontSide)

    self.backSide = ui.Surface(bounds:copy():move(0,0, -self.bounds.size.depth/2))
    self.backSide:setColor({1, 1, 1, 0.3})
    self.backSide:setPointable(true)
    self.backSide.onTouchDown = function()
      print("Back surface is at ", self.backSide.bounds.pose)
    end
    self.backSide.onPointerEntered = function()
      self.backSide:setColor({1, 0, 0, 0.3})
    end
    self.backSide.onPointerExited = function()
      self.backSide:setColor({1, 1, 1, 0.3})
    end
    self:addSubview(self.backSide)


    self.topSide = ui.Surface(bounds:copy():rotate(self.PI/2, 1, 0, 0):move(0, self.bounds.size.height/2, 0))
    self.topSide:setColor({1, 1, 1, 0.3})
    self.topSide:setPointable(true)
    self.topSide.onTouchDown = function()
      print("Top surface is at ", self.topSide.bounds.pose)
    end
    self.topSide.onPointerEntered = function()
      self.topSide:setColor({1, 0, 0, 0.3})
    end
    self.topSide.onPointerExited = function()
      self.topSide:setColor({1, 1, 1, 0.3})
    end
    self:addSubview(self.topSide)




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
