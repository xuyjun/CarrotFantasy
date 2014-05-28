MenuIcon = class("MenuIcon", function()
	return cc.Node:create()
end)

MenuIcon.__index = MenuIcon
MenuIcon._enableSprite = nil
MenuIcon._disableSprite = nil
MenuIcon._canWork = false
MenuIcon._price = 100
MenuIcon._dataModel = nil

function MenuIcon:ctor()
	self._enableSprite = cc.Sprite:create()
	self._enableSprite:setPosition(cc.p(40, 40))
	self._enableSprite:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	self:addChild(self._enableSprite)

	self._disableSprite = cc.Sprite:create()
	self._disableSprite:setPosition(cc.p(40, 40))
	self._disableSprite:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	self:addChild(self._disableSprite)

	self:setContentSize(cc.size(80, 80))
	self:setAnchorPoint(cc.p(0.5, 0.5))
	
	self._dataModel = StageModel:getInstance()
	self._dataModel:addObserver(self)
end

function MenuIcon:canWork()
	return self._canWork
end

function MenuIcon:updateDataMsg(msg)
	if msg == "money" then
		self:updateUI()
	end
end

function MenuIcon:updateUI()
	if self._price > self._dataModel:getMoney() then
		if self._canWork then
			self._canWork = false
			self._enableSprite:setVisible(false)
			self._disableSprite:setVisible(true)
		end
	else
		if not self._canWork then
			self._canWork = true
			self._enableSprite:setVisible(true)
			self._disableSprite:setVisible(false)
		end
	end
end

UpgradeIcon = class("UpgradeIcon", function()
	return MenuIcon.new()
end)

UpgradeIcon.__index = UpgradeIcon

function UpgradeIcon:ctor(price)
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("upgrade_%d.png", price))
	self._enableSprite:setSpriteFrame(frame)
	frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("upgrade_-%d.png", price))
	self._disableSprite:setSpriteFrame(frame)
end

TowersIcon = class("TowersIcon", function()
	return MenuIcon.new()
end)

TowersIcon.__index = TowersIcon
TowersIcon._mark = nil

function TowersIcon:ctor(mark)
	local ttype = getTowerTypeByMark(mark)
	self._mark = mark

	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(ttype.NORMAL)
	self._enableSprite:setSpriteFrame(frame)
	frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(ttype.DISABLE)
	self._disableSprite:setSpriteFrame(frame)
end

function TowersIcon:getTower()
	local mark = self._mark
	if self:canWork() then
		self._dataModel:setMoney(self._dataModel:getMoney() - self._price)
		if     mark == "1T" then return Bottle.new(1)
    	elseif mark == "2T" then return Shit.new(1)
    	elseif mark == "3T" then return Fan.new(1)
    	elseif mark == "4T" then return Star.new(1)
    	elseif mark == "5T" then return Ball.new(1)
    	end
    end
    return nil
end