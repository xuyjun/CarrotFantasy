function createSliderLayer(array, distance)
	local layer = cc.Layer:create()
	velocity = 2000

	layer.total = table.getn(array)
	layer.curIndex = 0
	layer.listSize = array[1]:getContentSize()
	
	layer.list = cc.Layer:create()
	for i, obj in pairs(array) do
		local x, y = obj:getPosition()
        obj:setPosition(cc.p(x + distance * (i - 1), y))
        layer.list:addChild(obj, 1, i - 1)
	end
	layer:addChild(layer.list)

	local function moveList()
		local offset = distance * layer.curIndex + layer.list:getPositionX()
        layer.list:stopAllActions()
        layer.list:runAction(
            cc.MoveTo:create(math.abs(offset) / velocity,
                cc.p(-distance * layer.curIndex, layer.list:getPositionY()))
        )
	end

	function layer:slideToPre()
		self.curIndex = self.curIndex - 1
		moveList()
	end

	function layer:slideToNext()
		self.curIndex = self.curIndex + 1
		moveList()
	end

	function layer:slideToCur()
		moveList()
	end

	local oldMouseX = 0
	local curMouseX = 0
	local deltaMouseX = 0
	local function onTouchBegan(touch, event)
		if layer:isVisible() then
			oldMouseX = touch:getLocation().x
			return true
		end
		return false
	end

	local function onTouchMoved(touch, event)
		deltaMouseX = touch:getDelta().x
		local x, y = layer.list:getPosition()
		layer.list:setPosition(cc.p(x + deltaMouseX, y))
	end

	local function onTouchEnded(touch, event)
		curMouseX = touch:getLocation().x
		local delta = curMouseX - oldMouseX
		if delta >= 50 and layer.curIndex > 0 then
            layer:slideToPre()
        elseif delta <= -50 and layer.curIndex < layer.total - 1 then
            layer:slideToNext()
        elseif delta ~= 0 then
            layer:slideToCur()
        end
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

	local eventDispatcher = layer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

	return layer
end

function initSelectSlideLayer(layer, size)
	rect = cc.rect(center.x - size.width / 2,
				   center.y - size.height / 2,
				   size.width, size.height)

	local oldMouseX = 0
	local curMouseX = 0
	local function onTouchBegan(touch, event)
		oldMouseX = touch:getLocation().x
		return cc.rectContainsPoint(rect, touch:getLocation())
	end

	local function onTouchEnded(touch, event)
		curMouseX = touch:getLocation().x
		local delta = curMouseX - oldMouseX
		if math.abs(delta) <= 30 then
			onSelected()
		end
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

	local eventDispatcher = layer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
end