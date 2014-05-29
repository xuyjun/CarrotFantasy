HelpLayer = class("HelpLayer", function()
    return SliderLayer.new()
end)

HelpLayer._label = nil

function HelpLayer:ctor()
    local tipArray = {}
    for i = 1, 4 do
        local tip = cc.Sprite:createWithSpriteFrameName(string.format("tips_%d.png", i))
        tip:setPosition(cc.p(winSize.width / 2, 380))

        local tipText = cc.Sprite:createWithSpriteFrameName(string.format("tips_text_%d_CN.png", i))
        local width = tip:getContentSize().width
        tipText:setPosition(cc.p(width / 2, -50))
        tipText:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
        tip:addChild(tipText)

        tipArray[#tipArray + 1] = tip
    end  
    self:initWithArray(tipArray, winSize.width)

    local bottom = cc.Sprite:createWithSpriteFrameName("bottom.png")
    bottom:setPosition(cc.p(winSize.width / 2, 50))
    self:addChild(bottom)

    local label = cc.LabelAtlas:_create("1/4", s_bottom_num, 16, 30, string.byte("."))
    label:setPosition(cc.p(winSize.width / 2, 55))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    self:addChild(label)

    self._label = label
end

function HelpLayer:onTouchEnded(touch, event)
    SliderLayer.onTouchEnded(self, touch, event)
    local index = self._curIndex + 1
    local string = index .. "/4"
    self._label:setString(string)
end

TowerLayer = class("TowerLayer", function()
    return SliderLayer.new()
end)

TowerLayer._label = nil

function TowerLayer:ctor()
    local tipArray = {}
    for i = 1, 13 do
        local num = i > 9 and ("" .. i) or ("0" .. i)
        local tower = cc.Sprite:createWithSpriteFrameName(string.format("tower_%s.png", num))
        tower:setPosition(center)

        local towerText = cc.Sprite:createWithSpriteFrameName(string.format("tower_%s_CN.png", num))
        local size = tower:getContentSize()
        towerText:setPosition(cc.p(size.width / 2, size.height / 2))
        towerText:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
        tower:addChild(towerText)

        tipArray[#tipArray + 1] = tower
    end
    self:initWithArray(tipArray, winSize.width)

    local bottom = cc.Sprite:createWithSpriteFrameName("bottom.png")
    bottom:setPosition(cc.p(winSize.width / 2, 50))
    self:addChild(bottom)

    local label = cc.LabelAtlas:_create("1/13", s_bottom_num, 16, 30, string.byte("."))
    label:setPosition(cc.p(winSize.width / 2, 55))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    self:addChild(label)

    self._label = label
end

function TowerLayer:onTouchEnded(touch, event)
    SliderLayer.onTouchEnded(self, touch, event)
    local index = self._curIndex + 1
    local string = index .. "/13"
    self._label:setString(string)
end

local function createMonsterLayer()
	local layer = cc.Layer:create()

	local bg = cc.Sprite:createWithSpriteFrameName("help_monster.png")
    bg:setPosition(cc.p(winSize.width / 2, 280))
    layer:addChild(bg)

    local title = cc.Sprite:createWithSpriteFrameName("help_monster_CN.png")
    title:setPosition(cc.p(winSize.width / 2, 280))
    layer:addChild(title)

	return layer
end

function createHelpScene()
	local scene = cc.Scene:create()

	local bg = cc.Sprite:createWithSpriteFrameName("help_bg.png")
    bg:setPosition(center)
    scene:addChild(bg)
	
    local helpLayer = HelpLayer.new()
    scene:addChild(helpLayer)

    local monsterLayer = createMonsterLayer()
    monsterLayer:setVisible(false)
    scene:addChild(monsterLayer)

    local towerLayer = TowerLayer.new()
    towerLayer:setVisible(false)
    scene:addChild(towerLayer)

    local helpNormal = cc.Sprite:createWithSpriteFrameName("tips_normal_CN.png")
    helpNormal:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    local helpSelected = cc.Sprite:createWithSpriteFrameName("tips_selected_CN.png")
    local helpBtn = cc.MenuItemSprite:create(helpNormal, nil, helpSelected)
    helpBtn:setPosition(cc.p(-170, 0))
    helpBtn:setEnabled(false)

    local monsterNormal = cc.Sprite:createWithSpriteFrameName("monster_normal_CN.png")
    monsterNormal:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    local monsterSelected = cc.Sprite:createWithSpriteFrameName("monster_selected_CN.png")
    local monsterBtn = cc.MenuItemSprite:create(monsterNormal, nil, monsterSelected)
    monsterBtn:setPosition(cc.p(0, 0))

    local towerNormal = cc.Sprite:createWithSpriteFrameName("tower_normal_CN.png")
    towerNormal:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    local towerSelected = cc.Sprite:createWithSpriteFrameName("tower_selected_CN.png")
    local towerBtn = cc.MenuItemSprite:create(towerNormal, nil, towerSelected)
    towerBtn:setPosition(cc.p(172, 0))

    local homeNormal = cc.Sprite:createWithSpriteFrameName("help_home_normal.png")
    homeNormal:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    local homePress = cc.Sprite:createWithSpriteFrameName("help_home_pressed.png")
    homePress:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    local homeBtn = cc.MenuItemSprite:create(homeNormal, homePress)
    homeBtn:setPosition(cc.p(-410, -5))

    local menu = cc.Menu:create(helpBtn, monsterBtn, towerBtn, homeBtn)
    menu:setPosition(cc.p(winSize.width / 2, 590))
    scene:addChild(menu)

    local function onHelpBtn()
    	helpLayer:setVisible(true)
    	monsterLayer:setVisible(false)
    	towerLayer:setVisible(false)

    	helpBtn:setEnabled(false)
    	monsterBtn:setEnabled(true)
    	towerBtn:setEnabled(true)
	end

	local function onMonsterBtn()
    	helpLayer:setVisible(false)
    	monsterLayer:setVisible(true)
    	towerLayer:setVisible(false)

    	helpBtn:setEnabled(true)
    	monsterBtn:setEnabled(false)
    	towerBtn:setEnabled(true)
    end

    local function onTowerBtn()
    	helpLayer:setVisible(false)
    	monsterLayer:setVisible(false)
    	towerLayer:setVisible(true)

    	helpBtn:setEnabled(true)
    	monsterBtn:setEnabled(true)
    	towerBtn:setEnabled(false)
    end

    local function onHomeBtn()
    	local scene = cc.Scene:create()
		scene:addChild(createWelcomeLayer())
        cc.Director:getInstance():replaceScene(cc.TransitionSlideInB:create(0.2, scene))
    end

    helpBtn:registerScriptTapHandler(onHelpBtn)
    monsterBtn:registerScriptTapHandler(onMonsterBtn)
    towerBtn:registerScriptTapHandler(onTowerBtn)
    homeBtn:registerScriptTapHandler(onHomeBtn)

	return scene
end