Tower = class("Tower", function()
	return cc.Sprite:create()
end)

Tower.__index = Tower
Tower._type = nil
Tower._level = 1
Tower._range = 0
Tower._speed = 0
Tower._attack = 0

Tower._upPrice = 0
Tower._sellPrice = 0

Tower._target = nil
Tower._attackAction = nil
Tower._base = nil
Tower._showUpgrade = nil
Tower._bullet = nil
Tower._rangeImage = nil
Tower._upImage = nil
Tower._sellImage = nil
Tower._dataModel = nil

function Tower:ctor(type, level)
	self._type = type
	self._level = level

    self._showUpgrade = cc.Sprite:createWithSpriteFrameName("showupgrade01.png")
    self._showUpgrade:setPosition(cc.p(40, 100))
    self._showUpgrade:runAction(createUpgrade())
    self:addChild(self._showUpgrade, 1)

    self._dataModel = StageModel:getInstance()
    self._dataModel:addObserver(self)

	self:registerScriptHandler(function(tag)
		if tag == "enter" then
			self:onEnter()
		end
	end)
end

function Tower:onEnter()
    self:initMenu()
end

function Tower:showMenu(show)
	local action = nil
	if not show then
        action = cc.Sequence:create(
            cc.ScaleTo:create(0.1, 0.1),
            cc.Hide:create()
        )
    else

        action = cc.Sequence:create(
            cc.Show:create(),
            cc.ScaleTo:create(0.1, 1)
        )
    
        local posX, posY = self:getPosition()
        local offsetUp = cc.p(0, 80)
        local offsetSell = cc.p(0, -80)
        if posY == 520 then
            if posX >= 480 then
            	offsetUp = cc.p(-80, 0)
            else
            	offsetUp = cc.p(80, 0)
            end
        elseif posY == 40 then
            if posX >= 480 then
            	offsetSell = cc.p(-80, 0)
            else
            	offsetSell = cc.p(80, 0)
            end
        end

        self._rangeImage:setPosition(posX, posY)
    	self._upImage:setPosition(cc.pAdd(cc.p(posX, posY), offsetUp))
    	self._sellImage:setPosition(cc.pAdd(cc.p(posX, posY), offsetSell))
    end
    self._rangeImage:runAction(action)
    self._upImage:runAction(action:clone())
    self._sellImage:runAction(action:clone())
end

function Tower:dealMenuByPos(pos)
    if self._upPrice ~= -1 and self._upImage:canWork()
        and cc.rectContainsPoint(self._upImage:getBoundingBox(), pos) then
        self:levelUp()
    elseif cc.rectContainsPoint(self._sellImage:getBoundingBox(), pos) then
    	self:sell()
    end
end

Tower._attackHandler = nil
function Tower:update()
    if not self._target then
        self._target = self:searchMonsters()
        if self._target and self._target:isLive() then
            self:attack()
            self._attackHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
            	function() self:attack() end, self._speed, false)
        end
    end

    if self._target and not self._target:isLive() then
        self._target = nil
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._attackHandler)
    end
end

function Tower:updateDataMsg(msg)
    if msg == "money" then
        if self._dataModel:getMoney() >= self._upPrice and self._level ~= 3 then
            self._showUpgrade:setVisible(true)
        else
            self._showUpgrade:setVisible(false)
        end
    end
end

function Tower:attack()
	print("override me")
end

function Tower:levelUp()
    self._dataModel:setMoney(self._dataModel:getMoney() - self._upPrice)
    self._level = self._level + 1
    self:initByLevel(self._type, self._level)
    self:initMenu()

    local air = cc.Sprite:createWithSpriteFrameName("air31.png")
    air:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    air:runAction(cc.Sequence:create(
        createAir3(),
        cc.RemoveSelf:create(true))
    )
    air:setPosition(GRID_WIDTH / 2, GRID_WIDTH / 2)
    self:addChild(air, -2)

    if self._level == 3 then
        self._dataModel:removeObserver(self)
        self._showUpgrade:setVisible(false)
    end
end

function Tower:sell()
    self._dataModel:setMoney(self._dataModel:getMoney() + self._sellPrice)

    local parent = self:getParent()
    local air = cc.Sprite:create()
    air:runAction(cc.Sequence:create(
        createAir1(),
        cc.RemoveSelf:create(true))
    )
    air:setPosition(self:getPosition())
    parent:addChild(air, 9)

    local grid = posToGrid(cc.p(self:getPosition()))
    self._dataModel:setGridObject(grid, GRID_EMPTY)

    self:removeFromParent(true)
end

function Tower:searchMonsters()
    -- TODO
    if true then return nil end
    
    local monsters = nil
    for i, monster in pairs(monsters) do
        if monster and cc.pGetDistance(
        					cc.p(monster:getPosition()),
        					cc.p(self:getPosition())
        			   ) <= self._range then
            return monster
        end
    end
    return nil
end

local RANGE_TAG = 1000
local UP_TAG 	= 2000
local SELL_TAG 	= 3000
local TOP_TAG 	= -1
function Tower:initMenu()
    local parent = self:getParent()

    self._rangeImage = parent:getChildByTag(self._range + RANGE_TAG)
    if not self._rangeImage then
        self._rangeImage = cc.Sprite:createWithSpriteFrameName("range_" .. self._range .. ".png")
        self._rangeImage:setVisible(false)
        parent:addChild(self._rangeImage, 11, self._range + RANGE_TAG)
    end

    if self._upPrice ~= -1 then
        self._upImage = parent:getChildByTag(self._upPrice + UP_TAG)
        if not self._upImage then
            self._upImage = UpgradeIcon.new(self._upPrice)
            self._upImage:setVisible(false)
            parent:addChild(self._upImage, 12, self._upPrice + UP_TAG)
        end
    else
        self._upImage = parent:getChildByTag(TOP_TAG + UP_TAG)
        if not self._upImage then
            self._upImage = cc.Sprite:createWithSpriteFrameName("upgrade_0_CN.png")
            self._upImage:setVisible(false)
            parent:addChild(self._upImage, 12, TOP_TAG + UP_TAG)
        end
    end

    self._sellImage = parent:getChildByTag(self._sellPrice + SELL_TAG)
    if not self._sellImage then
        self._sellImage = cc.Sprite:createWithSpriteFrameName("sell_" .. self._sellPrice .. ".png")
        self._sellImage:setVisible(false)
        parent:addChild(self._sellImage, 12, self._sellPrice + SELL_TAG)
    end
    self:showMenu(false)
end

function Tower:initByLevel(type, level)
	local name = type.NAME .. level .. "1.png"
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(name)
    self:setSpriteFrame(frame)
    self._attackAction = createAttack(type.NAME, level, type.BULLET_FRAMES)

    --this._bullet = getBulletByName()

    self._range = type.RANGE[level]
    self._speed = type.SPEED[level]
    self._attack = type.ATTACK[level]

    self._upPrice = type.UP_PRICE[level]
    self._sellPrice = type.SELL_PRICE[level]
end
