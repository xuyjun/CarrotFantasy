local function createOptionLayer()
	local layer = cc.Layer:create()

	local function onMusicBtn()

	end

	local function onEffectBtn()

	end

	local function onResetBtn()
		print("重置游戏")
	end

	local bg = cc.Sprite:createWithSpriteFrameName("setting_bg.png")
    bg:setPosition(center)
    layer:addChild(bg)

    local title = cc.Sprite:createWithSpriteFrameName("setting_bg_CN.png")
    title:setPosition(cc.p(winSize.width / 2, 320))
    title:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    layer:addChild(title)

    local musicOn = cc.MenuItemSprite:create(cc.Sprite:createWithSpriteFrameName("bgmusic_on_CN.png"), nil)
    local musicOff = cc.MenuItemSprite:create(cc.Sprite:createWithSpriteFrameName("bgmusic_off_CN.png"), nil)
    local musicBtn = cc.MenuItemToggle:create(musicOn, musicOff)
    musicBtn:registerScriptTapHandler(onMusicBtn)
    if CF.SOUND_MUSIC then
		musicBtn:setSelectedIndex(0)
    else
		musicBtn:setSelectedIndex(1)
    end  
    musicBtn:setPosition(cc.p(-100, 80))

    local effectOn = cc.MenuItemSprite:create(cc.Sprite:createWithSpriteFrameName("soundfx_on_CN.png"), nil)
    local effectOff = cc.MenuItemSprite:create(cc.Sprite:createWithSpriteFrameName("soundfx_off_CN.png"), nil)
    local effectBtn = cc.MenuItemToggle:create(effectOn, effectOff)
    effectBtn:registerScriptTapHandler(onEffectBtn)
    if CF.SOUND_EFFECT then
		effectBtn:setSelectedIndex(0)
    else
		effectBtn:setSelectedIndex(1)
    end  
    effectBtn:setPosition(cc.p(100, 80))

    local resetNormal = cc.Sprite:createWithSpriteFrameName("resetgame_normal_CN.png")
    local resetPress = cc.Sprite:createWithSpriteFrameName("resetgame_pressed_CN.png")
    local resetBtn = cc.MenuItemSprite:create(resetNormal, resetPress)
    resetBtn:registerScriptTapHandler(onResetBtn)
    resetBtn:setPosition(cc.p(0, -220))

    local menu = cc.Menu:create(musicBtn, effectBtn, resetBtn)
    menu:setPosition(center)
    layer:addChild(menu)

    return layer
end

local function createStaLayer()
	local layer = cc.Layer:create()

	local bg = cc.Sprite:createWithSpriteFrameName("statistics_bg.png")
    bg:setPosition(center)
    layer:addChild(bg)

    local title = cc.Sprite:createWithSpriteFrameName("statistics_bg_CN.png")
    title:setPosition(center)
    title:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    layer:addChild(title)

    local sta = CF.GAME_STATISTICS
    local advMap = cc.LabelAtlas:_create(sta.ADV_MAP, s_white_num, 20, 40, string.byte("."))
    advMap:setAnchorPoint(cc.p(1, 0.5))
    advMap:setPosition(cc.p(720, 430))
    layer:addChild(advMap)

    local hideMap = cc.LabelAtlas:_create(sta.HIDDEN_MAP, s_white_num, 20, 40, string.byte("."))
    hideMap:setAnchorPoint(cc.p(1, 0.5))
    hideMap:setPosition(cc.p(720, 375))
    layer:addChild(hideMap)

    local bossMap = cc.LabelAtlas:_create(sta.BOSS_MAP, s_white_num, 20, 40, string.byte("."))
    bossMap:setAnchorPoint(cc.p(1, 0.5))
    bossMap:setPosition(cc.p(720, 320))
    layer:addChild(bossMap)

    local money = cc.LabelAtlas:_create(sta.TOTAL_MONEY, s_white_num, 20, 40, string.byte("."))
    money:setAnchorPoint(cc.p(1, 0.5))
    money:setPosition(cc.p(800, 265))
    layer:addChild(money)

    local monster = cc.LabelAtlas:_create(sta.TOTAL_MONSTER, s_white_num, 20, 40, string.byte("."))
    monster:setAnchorPoint(cc.p(1, 0.5))
    monster:setPosition(cc.p(800, 210))
    layer:addChild(monster)

    local boss = cc.LabelAtlas:_create(sta.TOTAL_BOSS, s_white_num, 20, 40, string.byte("."))
    boss:setAnchorPoint(cc.p(1, 0.5))
    boss:setPosition(cc.p(800, 150))
    layer:addChild(boss)

    local item = cc.LabelAtlas:_create(sta.TOTAL_ITEM, s_white_num, 20, 40, string.byte("."))
    item:setAnchorPoint(cc.p(1, 0.5))
    item:setPosition(cc.p(800, 90))
    layer:addChild(item)

	return layer
end

local function createCreditsLayer()
	local layer = cc.Layer:create()

    local bg = cc.Sprite:createWithSpriteFrameName("credits_bg.png")
    bg:setPosition(center)
    layer:addChild(bg)

	return layer
end

function createSettingScene()
	local scene = cc.Scene:create()

	local optionLayer = createOptionLayer()
	scene:addChild(optionLayer)

	local staLayer = createStaLayer()
	staLayer:setVisible(false)
	scene:addChild(staLayer)

	local creditsLayer = createCreditsLayer()
	creditsLayer:setVisible(false)
	scene:addChild(creditsLayer)

    local optionNormal = cc.Sprite:createWithSpriteFrameName("options_normal_CN.png")
    local optionSelected = cc.Sprite:createWithSpriteFrameName("options_selected_CN.png")
    local optionBtn = cc.MenuItemSprite:create(optionNormal, nil, optionSelected)
    optionBtn:setPosition(cc.p(-200, 0))
    optionBtn:setEnabled(false)

    local staNormal = cc.Sprite:createWithSpriteFrameName("statistics_normal_CN.png")
    local staSelected = cc.Sprite:createWithSpriteFrameName("statistics_selected_CN.png")
    local staBtn = cc.MenuItemSprite:create(staNormal, nil, staSelected)
    staBtn:setPosition(cc.p(0, 0))

    local creditsNormal = cc.Sprite:createWithSpriteFrameName("credits_normal_CN.png")
    local creditsSelected = cc.Sprite:createWithSpriteFrameName("credits_selected_CN.png")
    local creditsBtn = cc.MenuItemSprite:create(creditsNormal, nil, creditsSelected)
    creditsBtn:setPosition(cc.p(200, 0))

    local homeNormal = cc.Sprite:createWithSpriteFrameName("setting_home_normal.png")
    local homePress = cc.Sprite:createWithSpriteFrameName("setting_home_pressed.png")
    local homeBtn = cc.MenuItemSprite:create(homeNormal, homePress)
    homeBtn:setPosition(cc.p(-410, -5))

    local menu = cc.Menu:create(optionBtn, staBtn, creditsBtn, homeBtn)
    menu:setPosition(cc.p(winSize.width / 2, 595))
    scene:addChild(menu)

    local function onOptionBtn()
		optionBtn:setEnabled(false);
        staBtn:setEnabled(true);
        creditsBtn:setEnabled(true);

        optionLayer:setVisible(true);
        staLayer:setVisible(false);
        creditsLayer:setVisible(false);
	end

	local function onStaBtn()
		optionBtn:setEnabled(true);
        staBtn:setEnabled(false);
        creditsBtn:setEnabled(true);

        optionLayer:setVisible(false);
        staLayer:setVisible(true);
        creditsLayer:setVisible(false);
	end

	local function onCreditsBtn()
		optionBtn:setEnabled(true);
        staBtn:setEnabled(true);
        creditsBtn:setEnabled(false);

        optionLayer:setVisible(false);
        staLayer:setVisible(false);
        creditsLayer:setVisible(true);
	end

	local function onHomeBtn()
		local scene = cc.Scene:create()
		scene:addChild(createWelcomeLayer())
		cc.Director:getInstance():replaceScene(cc.TransitionSlideInT:create(0.2, scene));
	end

	optionBtn:registerScriptTapHandler(onOptionBtn)
    staBtn:registerScriptTapHandler(onStaBtn)
    creditsBtn:registerScriptTapHandler(onCreditsBtn)
    homeBtn:registerScriptTapHandler(onHomeBtn)

	return scene
end