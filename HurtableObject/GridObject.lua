GridObject = class("GridObject", function(type)
	return HurtableObject.new(type.HP, type.MONEY)
end)

GridObject.__index = GridObject
GridObject._awardType = 0
GridObject._grids = {}

function GridObject:ctor(type)
	self._awardType = 0
	self._grids = {}
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(type.NAME)
    self:setSpriteFrame(frame)
    self:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
end

function GridObject:setGridRange(x, y, width, height)
	local row = height / GRID_WIDTH
	local col = width / GRID_WIDTH
	local originGrid = posToGrid(cc.p(x, y))

	for i = 1, row do
		for j = 1, col do
			local g = grid(originGrid.row + i - 1, originGrid.col + j - 1)
			self._grids[#self._grids + 1] = g
			self._dataModel:setGridObject(g, self)
		end
	end
end

function GridObject:setAwardType(type)
	self._awardType = type
end

function GridObject:die()
	self.super.die(self)

	if self._awardType ~= 0 then

	else
		for i, grid in pairs(self._grids) do
			self._dataModel:setGridObject(grid, GRID_EMPTY)
		end
	end
	self._dataModel:decreaseObject()
	self:removeFromParent(true)
end
