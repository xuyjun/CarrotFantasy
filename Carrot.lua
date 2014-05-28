Carrot = class("Carrot", function()
	return cc.Sprite:createWithSpriteFrameName("hlb21.png")
end)

Carrot.__index = Carrot
Carrot._scheduleID = nil
Carrot._posGrid = nil
Carrot._labelGrid = nil
Carrot._dataModel = nil
local scheduler = cc.Director:getInstance():getScheduler()

function Carrot:ctor()
	self._scheduleID = scheduler:scheduleScriptFunc(function() self:doAction() end, 10, false)
	self:setAnchorPoint(cc.p(0.4, 0))
	self:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	self._dataModel = StageModel:getInstance()
end

function Carrot:initGrid(posGrid, labelGrid)
	self._posGrid = posGrid
	self._labelGrid = labelGrid
	self._dataModel = StageModel:getInstance()
	self._dataModel:setGridObject(self._posGrid, self)
	self._dataModel:setGridObject(self._labelGrid, self)
end

function Carrot:recover()
	self:stopAllActions()
	self:setRotation(0)
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("hlb21.png")
	self:setSpriteFrame(frame)
end

function Carrot:activate()
	self:recover()
	self:runAction(createLBShake())
end

function Carrot:doAction()
	local random = math.random(3)
	local action = nil
	if random == 1 then
		action = createLBShake()
	elseif random == 2 then
		action = createLBBlink()
	elseif random == 3 then
		action = cc.Sequence:create(
			cc.RotateTo:create(0.3, -30),
			cc.RotateTo:create(0.3, 10),
			cc.RotateTo:create(0.3, -30),
			cc.RotateTo:create(0.3, 10),
			cc.RotateTo:create(0.3, -30),
			cc.RotateTo:create(0.3, 0)
		)
	end
	self:runAction(action)

	random = math.random(5, 10)
	scheduler:unscheduleScriptEntry(self._scheduleID)
	self._scheduleID = scheduler:scheduleScriptFunc(function() self:doAction() end, random, false)
end

function Carrot:setLife(life)
	if life < 10 and self._scheduleID then
		scheduler:unscheduleScriptEntry(self._scheduleID)
		self:recover()
		self._dataModel:setGridObject(self._posGrid, GRID_BAN)
		self._dataModel:setGridObject(self._labelGrid, GRID_BAN)
	end

	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("hlb" .. life .. ".png")
	self:setSpriteFrame(frame)
end