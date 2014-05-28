function createWelcomeLayer()
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_mainscene1)

    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_setting1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_setting2)

    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_help1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_help2)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_help3)

    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_stages_bg)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme_scene1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme_scene2)

    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_stage_theme1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_stage_theme2)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_stage_theme3)

    local layer = cc.Layer:create()
    local winSize = cc.Director:getInstance():getWinSize()

    local smallCloud = cc.Sprite:createWithSpriteFrameName("cloud1.png")
    smallCloud:setPosition(cc.p(150, 470))
    smallCloud:setBlendFunc(gl.ONE_MINUS_DST_COLOR, gl.ONE)
    layer:addChild(smallCloud, 0)

    local bigCloud = cc.Sprite:createWithSpriteFrameName("cloud2.png")
    bigCloud:setPosition(cc.p(650, 530))
    bigCloud:setBlendFunc(gl.ONE_MINUS_DST_COLOR, gl.ONE)
    layer:addChild(bigCloud, 0)

    local bird = cc.Sprite:createWithSpriteFrameName("bird.png")
    bird:setPosition(cc.p(180, 450))
    bird:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    bird:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.MoveBy:create(2, cc.p(0, 30)),
        cc.MoveBy:create(2, cc.p(0, -30))
    )))
    layer:addChild(bird, 10)    

    local carrot = cc.Sprite:createWithSpriteFrameName("carrot.png")
    carrot:setPosition(cc.p(center.x, 270))
    carrot:setAnchorPoint(cc.p(0.5, 0))
    carrot:setScale(0.1)
    carrot:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.2),
        cc.ScaleTo:create(0.10, 1.1),
        cc.ScaleTo:create(0.05, 1)
    ))
    layer:addChild(carrot, 9)

    local leftLeaf = cc.Sprite:createWithSpriteFrameName("leaf-1.png")
    leftLeaf:setPosition(cc.p(45, 195))

    local centerLeaf = cc.Sprite:createWithSpriteFrameName("leaf-2.png")
    centerLeaf:setPosition(cc.p(110, 135))
    centerLeaf:setAnchorPoint(cc.p(0.5, 0))
    centerLeaf:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.DelayTime:create(5),
        cc.RotateBy:create(0.1, 10),
        cc.RotateBy:create(0.1, -10),
        cc.RotateBy:create(0.1, 10),
        cc.RotateBy:create(0.1, -10),
        cc.DelayTime:create(2)
    )))

    local rightLeaf = cc.Sprite:createWithSpriteFrameName("leaf-3.png")
    rightLeaf:setPosition(cc.p(120, 135))
    rightLeaf:setAnchorPoint(cc.p(0, 0))
    rightLeaf:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.DelayTime:create(7),
        cc.RotateBy:create(0.1, 13),
        cc.RotateBy:create(0.1, -13),
        cc.RotateBy:create(0.1, 13),
        cc.RotateBy:create(0.1, -13)
    )))

    carrot:addChild(leftLeaf, -2)
    carrot:addChild(centerLeaf, -1)
    carrot:addChild(rightLeaf, -2)

    local bg = cc.Sprite:createWithSpriteFrameName("mainbg.png")
    bg:setPosition(center)
    layer:addChild(bg, -1)

    local titleLabel = cc.Sprite:createWithSpriteFrameName("mainbg_CN.png")
    titleLabel:setPosition(center)
    layer:addChild(titleLabel, 10)

	local function onAdvBtn()
        cc.Director:getInstance():replaceScene(createThemeSelectScene());
	end

	local function onBossBtn()

	end

	local function onNestBtn()

	end

	local function onHelpBtn()
		cc.Director:getInstance():replaceScene(cc.TransitionSlideInT:create(0.2, createHelpScene()))
	end

	function onSettingBtn()
        cc.Director:getInstance():replaceScene(cc.TransitionSlideInB:create(0.2, createSettingScene()))
    end

    local advNormal = cc.Sprite:createWithSpriteFrameName("btn_adventure_normal_CN.png")
    local advPress = cc.Sprite:createWithSpriteFrameName("btn_adventure_pressed_CN.png")
    local advBtn = cc.MenuItemSprite:create(advNormal, advPress)
    advBtn:setPosition(cc.p(-300, -250))
    advBtn:registerScriptTapHandler(onAdvBtn)	   

    local bossNormal = cc.Sprite:createWithSpriteFrameName("btn_boss_normal_CN.png")
    local bossPress = cc.Sprite:createWithSpriteFrameName("btn_boss_pressed_CN.png")
    local bossBtn = cc.MenuItemSprite:create(bossNormal, bossPress)
    bossBtn:setPosition(cc.p(0, -250))
    bossBtn:registerScriptTapHandler(onBossBtn)	

    local nestNormal = cc.Sprite:createWithSpriteFrameName("btn_nest_normal_CN.png")
    local nestPress = cc.Sprite:createWithSpriteFrameName("btn_nest_pressed_CN.png")
    local nestBtn = cc.MenuItemSprite:create(nestNormal, nestPress)
    nestBtn:setPosition(cc.p(300, -250))
    nestBtn:registerScriptTapHandler(onNestBtn)	

    local lock = cc.Sprite:createWithSpriteFrameName("locked.png")
    lock:setPosition(cc.p(282.5, 60))
    nestBtn:addChild(lock, 100)

    local settingNormal = cc.Sprite:createWithSpriteFrameName("btn_setting_normal.png")
    local settingPress = cc.Sprite:createWithSpriteFrameName("btn_setting_pressed.png")
    local settingBtn = cc.MenuItemSprite:create(settingNormal, settingPress)
    settingBtn:setPosition(cc.p(-280, -90))
    settingBtn:registerScriptTapHandler(onSettingBtn)	

    local helpNormal = cc.Sprite:createWithSpriteFrameName("btn_help_normal.png")
    local helpPress = cc.Sprite:createWithSpriteFrameName("btn_help_pressed.png")
    local helpBtn = cc.MenuItemSprite:create(helpNormal, helpPress)
    helpBtn:setPosition(cc.p(290, -100))
    helpBtn:registerScriptTapHandler(onHelpBtn)	

    local menu = cc.Menu:create(advBtn, bossBtn, nestBtn, helpBtn, settingBtn)
    layer:addChild(menu)

    local function update()
    	local sPosX = smallCloud:getPositionX()
        if sPosX >= 1050 then
        	smallCloud:setPositionX(-150)
        else
        	smallCloud:setPositionX(sPosX + 1)
        end

        local bPosX = bigCloud:getPositionX()
        if bPosX >= 1100 then
        	bigCloud:setPositionX(-200)
        else
        	bigCloud:setPositionX(bPosX + 0.9)
        end
    end

    layer:scheduleUpdateWithPriorityLua(update, 0)

    return layer
end