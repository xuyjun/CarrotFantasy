ThemeSelectLayer = class("ThemeSelectLayer", function()
    return SelectSlideLayer.new()
end)

function ThemeSelectLayer:ctor()
    self._velocity = 4000
    local array = {}
    for i = 1, 3 do
        local theme = cc.Sprite:createWithSpriteFrameName(string.format("theme_pack0%d.png", i))
        theme:setPosition(center)

        local themeCN = cc.Sprite:createWithSpriteFrameName(string.format("theme_pack0%d_CN.png", i))
        local size = theme:getContentSize()
        themeCN:setPosition(cc.p(size.width / 2, size.height / 2))
        themeCN:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
        theme:addChild(themeCN)

        local num = 0
        if i == 1 then
            num = CF.BOOKMARK.SKYLINE
        elseif i == 2 then
            num = CF.BOOKMARK.JUNGLE
        elseif i == 3 then
            num = CF.BOOKMARK.DESERT
        end

        if num > 0 then
            local bookmark = cc.Sprite:createWithSpriteFrameName(string.format("bookmark_%d-9.png", num))
            bookmark:setPosition(cc.p(600, 35))
            theme:addChild(bookmark)
         else
            local lock = cc.Sprite:createWithSpriteFrameName("theme_locked.png")
            lock:setPosition(cc.p(630, 106))
            theme:addChild(lock)
        end

        array[#array + 1] = theme
    end

	self:initWithArray(array, winSize.width)
end

function ThemeSelectLayer:onSelected()
    local index = self._curIndex + 1
    local theme = nil
    if index == 1 then
        theme = ThemeData.Skyline
    elseif index == 2 then
        theme = ThemeData.Jungle
    elseif index == 3 then
        theme = ThemeData.Desert
    end

    local scene = createStageSelectScene(theme)
    cc.Director:getInstance():pushScene(scene)    
end

function createThemeSelectScene()
	local scene = createSelectScene()

    local slideLayer = ThemeSelectLayer.new()
    scene:addChild(slideLayer, 10)

    local homeNormal = cc.Sprite:createWithSpriteFrameName("theme_home_normal.png")
    local homePress = cc.Sprite:createWithSpriteFrameName("theme_home_pressed.png")
    local homeBtn = cc.MenuItemSprite:create(homeNormal, homePress)
    homeBtn:setPosition(cc.p(-430, 290))

    local leftNormal = cc.Sprite:createWithSpriteFrameName("theme_pointleft_normal.png")
    local leftPress = cc.Sprite:createWithSpriteFrameName("theme_pointleft_pressed.png")
    local leftBtn = cc.MenuItemSprite:create(leftNormal, leftPress)
    leftBtn:setPosition(cc.p(-405, 0))

    local rightNormal = cc.Sprite:createWithSpriteFrameName("theme_pointright_normal.png")
    local rightPress = cc.Sprite:createWithSpriteFrameName("theme_pointright_pressed.png")
    local rightBtn = cc.MenuItemSprite:create(rightNormal, rightPress)
    rightBtn:setPosition(cc.p(405, 0))

    menu:addChild(homeBtn)
    menu:addChild(leftBtn)
    menu:addChild(rightBtn)

    function scene:updateLRBtn()
    	local index = slideLayer._curIndex
        local len = slideLayer._total
        if index <= 0 then
            leftBtn:setVisible(false)
            rightBtn:setVisible(true)
        elseif index >= len - 1 then
            leftBtn:setVisible(true)
            rightBtn:setVisible(false)
        else
            leftBtn:setVisible(true)
            rightBtn:setVisible(true)
        end
    end

    local function onHomeBtn()
    	local scene = cc.Scene:create()
		scene:addChild(createWelcomeLayer())
        cc.Director:getInstance():replaceScene(scene)
    end

    local function onLeftBtn()
    	slideLayer:slideToPre()
    	scene:updateLRBtn()
    end

    local function onRightBtn()
		slideLayer:slideToNext()
		scene:updateLRBtn()
    end

    homeBtn:registerScriptTapHandler(onHomeBtn)
    leftBtn:registerScriptTapHandler(onLeftBtn)
    rightBtn:registerScriptTapHandler(onRightBtn)

	local oldMouseX = 0
	local curMouseX = 0
	local function onTouchBegan(touch, event)
		oldMouseX = touch:getLocation().x
		return true
	end

	local function onTouchEnded(touch, event)
		curMouseX = touch:getLocation().x
		local delta = curMouseX - oldMouseX
		if math.abs(delta) >= 30 then
			scene:updateLRBtn()
		end
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

	local eventDispatcher = scene:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, scene)

	scene:updateLRBtn()
	return scene
end