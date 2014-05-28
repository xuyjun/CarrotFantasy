Monster = class("Monster", function(type, hp)
	return HurtableObject.new(hp, type.MONEY)
end)

Monster.__index = Monster
Monster._type = nil
Monster._speed = 0
Monster._attack = 0
Monster._pointIndex = 1

function Monster:ctor(type, hp)
	self._type = type
	self._speed = type.SPEED
	self._attack = type.ATTACK
    self._pointIndex = 1
	self:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(type.NAME .. "01.png"))
    self:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    self:runAction(createRepeatAnimate({type.NAME .. "01.png", type.NAME .. "02.png"}, 0.2))
end

function Monster:born()
	local mcm = cc.Sprite:createWithSpriteFrameName("mcm01.png")
    mcm:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    mcm:runAction(cc.ScaleTo:create(0.35, 1.4))
    mcm:runAction(cc.Sequence:create(
        createMcm(),
        cc.DelayTime:create(0.25),
        cc.RotateBy:create(0.15, 135),
        cc.RemoveSelf:create(true)
    ))
    local pos = cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2)
    mcm:setPosition(pos)
    self:addChild(mcm, 10)

    self:moveToNextPoint()
end

function Monster:die()
    self.super.die(self)

    local parent = self:getParent()
    local air = cc.Sprite:create()
    air:runAction(cc.Sequence:create(
        createAir0(),
        cc.RemoveSelf:create(true))
    )
    air:setPosition(self:getPosition())
    parent:addChild(air, 15)

    self._dataModel:decreaseMonster()
    self:removeFromParent(true)
end

function Monster:attackLB()
	self._dataModel:decreaseLife(self._attack)

    local parent = self:getParent()
    local air = cc.Sprite:create()
    air:runAction(cc.Sequence:create(
        createAir1(),
        cc.RemoveSelf:create(true))
    )
    air:setPosition(self:getPosition())
    parent:addChild(air, 15)

    self:removeFromParent(true)
end

function Monster:moveToNextPoint()
	self._pointIndex = self._pointIndex + 1
	local pathPoint = self._dataModel:getPathByIndex(self._pointIndex)
	local pos = cc.p(self:getPosition())
	local dis = cc.pGetDistance(pos, pathPoint)
	local time = dis / self._speed
    local offset = cc.p(GRID_WIDTH / 2, 0)
	self:runAction(cc.Sequence:create(
		cc.MoveTo:create(time, cc.pAdd(pathPoint, offset)),
		cc.CallFunc:create(function() self:checkPoint() end)
	))
end

function Monster:checkPoint()
	if self._pointIndex + 1 == self._dataModel:getPathLenght() then
		self:attackLB()
	else
		self:moveToNextPoint()
	end
end