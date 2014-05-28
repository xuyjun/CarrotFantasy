--------------------
-- Shit
--------------------
Shit = class("Shit", function(level)
	return Tower.new(TowersType.Shit, level)
end)

Shit.__index = Shit
Shit._base = nil

function Shit:ctor(level)
	self._base = cc.Sprite:createWithSpriteFrameName("Shit-1" .. level .. ".png")
	self._base:setPosition(cc.p(40, 40))
	self:addChild(self._base, -1)

	self:initByLevel(TowersType.Shit, level)
end

function Shit:initByLevel(type, level)
	Tower.initByLevel(self, type, level)
	self._base:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("Shit-1" .. level .. ".png"))
end

--------------------
-- Bottle
--------------------
Bottle = class("Bottle", function(level)
	return Tower.new(TowersType.Bottle, level)
end)

Bottle.__index = Bottle
Bottle._base = nil

function Bottle:ctor(level)
	self._base = cc.Sprite:createWithSpriteFrameName("Bottle-11.png")
	self._base:setPosition(cc.p(40, 40))
	self:addChild(self._base, -1)

	self:initByLevel(TowersType.Bottle, level)
end

--------------------
-- Ball
--------------------
Ball = class("Ball", function(level)
	return Tower.new(TowersType.Ball, level)
end)

Ball.__index = Ball

function Ball:ctor(level)
	self:initByLevel(TowersType.Ball, level)
end

--------------------
-- Fan
--------------------
Fan = class("Fan", function(level)
	return Tower.new(TowersType.Fan, level)
end)

Fan.__index = Fan
Fan._base = nil

function Fan:ctor(level)
	self._base = cc.Sprite:createWithSpriteFrameName("Fan-1" .. level .. ".png")
	self._base:setPosition(cc.p(40, 40))
	self:addChild(self._base, -1)

	self:initByLevel(TowersType.Fan, level)
end

function Fan:initByLevel(type, level)
	Tower.initByLevel(self, type, level)
	self._base:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("Fan-1" .. level .. ".png"))
end

--------------------
-- Star
--------------------
Star = class("Star", function(level)
	return Tower.new(TowersType.Star, level)
end)

Star.__index = Star
Star._base = nil

function Star:ctor(level)
	self._base = cc.Sprite:createWithSpriteFrameName("Star-1" .. level .. ".png")
	self._base:setPosition(cc.p(40, 40))
	self:addChild(self._base, -1)

	self:initByLevel(TowersType.Star, level)
end

function Star:initByLevel(type, level)
	Tower.initByLevel(self, type, level)
	self._base:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("Star-1" .. level .. ".png"))
end


