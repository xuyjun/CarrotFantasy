SliderLayer = class("SliderLayer", function()
	return cc.Layer:create()
end)

SliderLayer._velocity = 0
SliderLayer._total = 0
SliderLayer._curIndex = 0
SliderLayer._distance = 0
SliderLayer._list = nil
SliderLayer._listSize = nil

SliderLayer._oldMouseX = 0
SliderLayer._curMouseX = 0
SliderLayer._deltaMouseX = 0

function SliderLayer:ctor()
	self._velocity = 2000
	self._total = 0
	self._curIndex = 0
	self._distance = 0
	self._listSize = nil

	self._oldMouseX = 0
	self._curMouseX = 0
	self._deltaMouseX = 0

	self:registerScriptHandler(function(tag)
        if tag == "enter" then
            self:onEnter()
        end
    end)
end

function SliderLayer:onEnter()
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(function(touch, event) return self:onTouchBegan(touch, event) end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function(touch, event) self:onTouchMoved(touch, event) end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function(touch, event) self:onTouchEnded(touch, event) end, cc.Handler.EVENT_TOUCH_ENDED)

	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function SliderLayer:initWithArray(array, distance)
	self._total = #array
	self._distance = distance
	self._listSize = array[1]:getContentSize()

	self._list = cc.Layer:create()
	for i, obj in ipairs(array) do
		local x, y = obj:getPosition()
        obj:setPosition(cc.p(x + distance * (i - 1), y))
        self._list:addChild(obj, 1, i - 1)
	end
	self:addChild(self._list)
end

function SliderLayer:moveList()
	local offset = self._distance * self._curIndex + self._list:getPositionX()
    self._list:stopAllActions()
    self._list:runAction(
        cc.MoveTo:create(math.abs(offset) / self._velocity,
            cc.p(-self._distance * self._curIndex, self._list:getPositionY()))
    )
end

function SliderLayer:slideToPre()
	self._curIndex = self._curIndex - 1
	self:moveList()
end

function SliderLayer:slideToNext()
	self._curIndex = self._curIndex + 1
	self:moveList()
end

function SliderLayer:slideToCur()
	self:moveList()
end

function SliderLayer:onTouchBegan(touch, event)
	if self:isVisible() then
		self._oldMouseX = touch:getLocation().x
		return true
	end
	return false
end

function SliderLayer:onTouchMoved(touch, event)
	self._deltaMouseX = touch:getDelta().x
	local x, y = self._list:getPosition()
	self._list:setPosition(cc.p(x + self._deltaMouseX, y))
end

function SliderLayer:onTouchEnded(touch, event)
	self._curMouseX = touch:getLocation().x
	local delta = self._curMouseX - self._oldMouseX
	if delta >= 50 and self._curIndex > 0 then
        self:slideToPre()
    elseif delta <= -50 and self._curIndex < self._total - 1 then
        self:slideToNext()
    elseif delta ~= 0 then
        self:slideToCur()
    end
end

SelectSlideLayer = class("SelectSlideLayer", function()
	return SliderLayer.new()
end)

SelectSlideLayer._rect = nil

function SelectSlideLayer:ctor()
	self._rect = nil
end

function SelectSlideLayer:initWithArray(array, distance)
	SliderLayer.initWithArray(self, array, distance)
	self._rect = cc.rect(center.x - self._listSize.width / 2,
				    center.y - self._listSize.height / 2,
				    self._listSize.width, self._listSize.height)
end

function SelectSlideLayer:onTouchEnded(touch, event)
	SliderLayer.onTouchEnded(self, touch, event)
	self._curMouseX = touch:getLocation().x
	local delta = self._curMouseX - self._oldMouseX
	if math.abs(delta) <= 30 and cc.rectContainsPoint(self._rect, touch:getLocation()) then
		self:onSelected()
	end
end
