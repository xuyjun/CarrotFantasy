function createStageSelectLayer(theme)

    cc.SpriteFrameCache:getInstance():addSpriteFrames(theme.SELECT_PLIST)

    local disableColor = cc.c3b(70, 70, 70)
    local enableColor = cc.c3b(255, 255, 255)

    local array = {}
    for i = 1, 12 do
        local num = i > 9 and ("" .. i) or ("0" .. i)

        local stage = cc.Sprite:createWithSpriteFrameName(string.format("ss_map%s.png", num))
        stage:setPosition(center)
        stage:setCascadeColorEnabled(true)

        if theme.UNLOCK_STAGE[i] == 0 then
            local str = "ss_locked_icon.png"
            local lock = cc.Sprite:createWithSpriteFrameName(str)
            lock:setPosition(cc.p(395, 70))
            stage:addChild(lock)
        end
        stage:setColor(disableColor)

        array[#array + 1] = stage
    end

	local layer = createSliderLayer(array, 515)

	function onSelected()

	end

	initSelectSlideLayer(layer, layer.listSize)
	velocity = 3000

    local waveLabel = cc.Sprite:create()
    waveLabel:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    waveLabel:setPosition(cc.p(480, 545))
    layer:addChild(waveLabel)

    layer.list:getChildByTag(0):setColor(enableColor)
    layer.list:setPosition(cc.p(0, 40))

    local towersSprite = cc.Sprite:create()
    towersSprite:setPosition(cc.p(center.x, 150))
    layer:addChild(towersSprite)

    local cloud = cc.Sprite:createWithSpriteFrameName("ss_cloud.png")
    cloud:setPosition(center)
    layer:addChild(cloud)

    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    local function changeWaveLabel()
        local stage = "Stage" .. (layer.curIndex + 1)
        local count = theme.STAGE_DATA[stage].TOTAL_WAVE
        local str = "ss_waves_" .. count .. ".png"
        waveLabel:setSpriteFrame(spriteFrameCache:getSpriteFrame(str))
    end

    local function changeTowers()
        local i = layer.curIndex + 1
        local num = i > 9 and ("" .. i) or ("0" .. i)
        towersSprite:setSpriteFrame(spriteFrameCache:getSpriteFrame(string.format("ss_towers_%s.png", num)))
    end

    local function changePlayBtn()
        local parent = layer:getParent()
        if theme.UNLOCK_STAGE[layer.curIndex + 1] >= 1 then
            parent.playBtn:setEnabled(true)
        else
            parent.playBtn:setEnabled(false)
        end
    end

    local oldMouseX = 0
    local curMouseX = 0
    local function onTouchBegan(touch, event)
        oldMouseX = touch:getLocation().x
        return true
    end

    local leftRect = cc.rect(0, rect.y, rect.x, rect.height)
    local rightRect = cc.rect(rect.x + rect.width, rect.y, rect.x, rect.height)
    local function onTouchEndedBefore(touch, evnet)
        layer.list:getChildByTag(layer.curIndex):setColor(disableColor)
    end

    local function onTouchEndedAfter(touch, evnet)
        local point = touch:getLocation()
        curMouseX = point.x
        if curMouseX == oldMouseX then
            if cc.rectContainsPoint(leftRect, point)
                and layer.curIndex > 0 then
                layer:slideToPre()
            elseif cc.rectContainsPoint(rightRect, point)
                and layer.curIndex < layer.total - 1 then
                layer:slideToNext()
            end
        end
        layer.list:getChildByTag(layer.curIndex):setColor(enableColor)

        changeTowers()
        changePlayBtn()
        changeWaveLabel()
    end

    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener1:registerScriptHandler(onTouchEndedBefore, cc.Handler.EVENT_TOUCH_ENDED)
    local listener2 = cc.EventListenerTouchOneByOne:create()
    listener2:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener2:registerScriptHandler(onTouchEndedAfter, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener1, -10)
    eventDispatcher:addEventListenerWithFixedPriority(listener2, 10)

    changeTowers()
    changeWaveLabel()
	return layer
end

function createStageSelectScene()
	local scene = createSelectScene()

    local backNormal = cc.Sprite:createWithSpriteFrameName("ss_back_normal.png")
    local backPress = cc.Sprite:createWithSpriteFrameName("ss_back_pressed.png")
    local backBtn = cc.MenuItemSprite:create(backNormal, backPress)
    backBtn:setPosition(cc.p(-430, 290))

    local playNoraml = cc.Sprite:createWithSpriteFrameName("ss_play_normal_CN.png")
    local playPress = cc.Sprite:createWithSpriteFrameName("ss_play_pressed_CN.png")
    local playDisable = cc.Sprite:createWithSpriteFrameName("ss_locked_CN.png")
    scene.playBtn = cc.MenuItemSprite:create(playNoraml, playPress, playDisable)
    scene.playBtn:setPosition(cc.p(0, -250))

    menu:addChild(backBtn)
    menu:addChild(scene.playBtn)

    local function onBackBtn()
        cc.Director:getInstance():popScene()
    end

    local function onPlayBtn()
        print("开始游戏")
    end

    local function onHelpBtn()
        cc.Director:getInstance():popScene()
        cc.Director:getInstance():replaceScene(createHelpScene())
    end

    backBtn:registerScriptTapHandler(onBackBtn)
    scene.playBtn:registerScriptTapHandler(onPlayBtn)
    helpBtn:registerScriptTapHandler(onHelpBtn)

	return scene
end