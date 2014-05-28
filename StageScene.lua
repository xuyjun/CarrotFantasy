local function createStageMenu()
	local layer = cc.Layer:create()

    local darkBg = cc.Sprite:createWithSpriteFrameName("darkbg.png")
    darkBg:setPosition(center)
    layer:addChild(darkBg)

    local menuBg = cc.Sprite:createWithSpriteFrameName("menu_bg.png")
    menuBg:setPosition(center)
    layer:addChild(menuBg)

    local shareBg = cc.Sprite:createWithSpriteFrameName("share_bg.png")
    shareBg:setAnchorPoint(cc.p(0.5, 0))
    shareBg:setPosition(cc.p(center.x, 0))
    layer:addChild(shareBg)

    local shareCN = cc.Sprite:createWithSpriteFrameName("share_bg_CN.png")
    shareCN:setAnchorPoint(cc.p(0.5, 0))
    shareCN:setPosition(cc.p(center.x, 0))
    layer:addChild(shareCN)

    local resumeNormal = cc.Sprite:createWithSpriteFrameName("menu_resume_normal_CN.png")
    local resumePress = cc.Sprite:createWithSpriteFrameName("menu_resume_pressed_CN.png")
    local resumeBtn = cc.MenuItemSprite:create(resumeNormal, resumePress)
    resumeBtn:setPosition(cc.p(0, 96))

    local restartNormal = cc.Sprite:createWithSpriteFrameName("menu_restart_normal_CN.png")
    local restartPress = cc.Sprite:createWithSpriteFrameName("menu_restart_pressed_CN.png")
    local restartBtn = cc.MenuItemSprite:create(restartNormal, restartPress)
    restartBtn:setPosition(cc.p(0, 2))

    local quitNormal = cc.Sprite:createWithSpriteFrameName("menu_quit_normal_CN.png")
    local quitPress = cc.Sprite:createWithSpriteFrameName("menu_quit_pressed_CN.png")
    local quitBtn = cc.MenuItemSprite:create(quitNormal, quitPress)
    quitBtn:setPosition(cc.p(0, -93))

    local weiboNormal = cc.Sprite:createWithSpriteFrameName("share_weibo_normal.png")
    local weiboPress = cc.Sprite:createWithSpriteFrameName("share_weibo_press.png")
    local weiboBtn = cc.MenuItemSprite:create(weiboNormal, weiboPress)
    weiboBtn:setPosition(cc.p(-140, -290))

    local wechatNormal = cc.Sprite:createWithSpriteFrameName("share_wechat_normal.png")
    local wechatPress = cc.Sprite:createWithSpriteFrameName("share_wechat_press.png")
    local wechatDisable = cc.Sprite:createWithSpriteFrameName("share_wechat_disable.png")
    local wechatBtn = cc.MenuItemSprite:create(wechatNormal, wechatPress, wechatDisable)
    wechatBtn:setPosition(cc.p(0, -290))

    local tweiboNormal = cc.Sprite:createWithSpriteFrameName("share_tweibo_normal.png")
    local tweiboPress = cc.Sprite:createWithSpriteFrameName("share_tweibo_press.png")
    local tweiboBtn = cc.MenuItemSprite:create(tweiboNormal, tweiboPress)
    tweiboBtn:setPosition(cc.p(140, -290))

    local menu = cc.Menu:create(resumeBtn, restartBtn, quitBtn, weiboBtn, tweiboBtn, wechatBtn)
    layer:addChild(menu)

    function onResumeBtn() 
        layer:setVisible(false)
        layer:getParent()._gameMenu:setEnabled(true)
    end

    function onRestartBtn() 
        cc.Director:getInstance():replaceScene(createTestScene())
    end

    resumeBtn:registerScriptTapHandler(onResumeBtn)
    restartBtn:registerScriptTapHandler(onRestartBtn)

	return layer
end

StageScene = class("StageScene", function()
    return cc.Scene:create()
end)

StageScene.__index = StageScene
StageScene._moneyLabel = nil
StageScene._curWave = nil
StageScene._totalWave = nil
StageScene._gameMenu = nil
StageScene._dataModel = nil

function StageScene:ctor()
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_item00)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_item01)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_item02)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_game_menu)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_weibo)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_dark_bg)

    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_TBottle)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_TShit)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_TBall)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_TFan)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_TStar)

    self._dataModel = StageModel:getInstance()
    self._dataModel:addObserver(self)

	local menuBG = cc.Sprite:createWithSpriteFrameName("MenuBG.png")
    menuBG:setPosition(cc.p(center.x, winSize.height))
    menuBG:setAnchorPoint(cc.p(0.5, 1))
    self:addChild(menuBG, 10)

    local waveLabel = cc.Sprite:createWithSpriteFrameName("MenuCenter_01_CN.png")
    waveLabel:setPosition(cc.p(center.x, winSize.height))
    waveLabel:setAnchorPoint(cc.p(0.5, 1))
    self:addChild(waveLabel, 10)

    local moneyLabel = cc.LabelAtlas:_create(0, s_white_num, 20, 40, string.byte("."))
    moneyLabel:setAnchorPoint(cc.p(0, 0.5))
    moneyLabel:setPosition(cc.p(100, 610))
    self:addChild(moneyLabel, 10)
 
    local curWave = cc.LabelAtlas:_create(0, s_yellow_num, 44, 40, string.byte("."))
    curWave:setPosition(cc.p(28, 29))
    waveLabel:addChild(curWave)

    local totalWave = cc.LabelAtlas:_create(0, s_white_num, 20, 40, string.byte("."))
    totalWave:setPosition(cc.p(140, 30))
    waveLabel:addChild(totalWave)

    local pauseLabel = cc.Sprite:createWithSpriteFrameName("MenuCenter_02_CN.png")
    pauseLabel:setPosition(cc.p(center.x, winSize.height))
    pauseLabel:setAnchorPoint(cc.p(0.5, 1))
    pauseLabel:setVisible(false)
    self:addChild(pauseLabel, 10)

    local pauseNormal = cc.Sprite:createWithSpriteFrameName("pause01.png")
    local pausePress = cc.Sprite:createWithSpriteFrameName("pause02.png")
    local pauseBtn = cc.MenuItemSprite:create(pauseNormal, pausePress)

    local resumeNormal = cc.Sprite:createWithSpriteFrameName("pause11.png")
    local resumePress = cc.Sprite:createWithSpriteFrameName("pause12.png")
    local resumeBtn = cc.MenuItemSprite:create(resumeNormal, resumePress)

    local pauseAndResume = cc.MenuItemToggle:create(pauseBtn, resumeBtn)
    pauseAndResume:setAnchorPoint(cc.p(0.5, 1))
    pauseAndResume:setPosition(cc.p(320, center.y))

    local speed1Normal = cc.Sprite:createWithSpriteFrameName("speed11.png")
    local speed1Press = cc.Sprite:createWithSpriteFrameName("speed12.png")
    local speed1Btn = cc.MenuItemSprite:create(speed1Normal, speed1Press)

    local speed2Normal = cc.Sprite:createWithSpriteFrameName("speed21.png")
    local speed2Press = cc.Sprite:createWithSpriteFrameName("speed22.png")
    local speed2Btn = cc.MenuItemSprite:create(speed2Normal, speed2Press)

    local speedBtn = cc.MenuItemToggle:create(speed1Btn, speed2Btn)
    speedBtn:setAnchorPoint(cc.p(0.5, 1))
    speedBtn:setPosition(cc.p(220, center.y))

    local menuNormal = cc.Sprite:createWithSpriteFrameName("menu01.png")
    local menuPress = cc.Sprite:createWithSpriteFrameName("menu02.png")
    local menuBtn = cc.MenuItemSprite:create(menuNormal, menuPress)
    menuBtn:setAnchorPoint(cc.p(0.5, 1))
    menuBtn:setPosition(cc.p(400, center.y))

    local gameMenu = cc.Menu:create(pauseAndResume, speedBtn, menuBtn)
    self:addChild(gameMenu, 10)

    local menuLayer = createStageMenu()
    menuLayer:setVisible(false)
    self:addChild(menuLayer, 10)

    self._moneyLabel = moneyLabel
    self._curWave = curWave
    self._totalWave = totalWave
    self._gameMenu = gameMenu

    local gameState = CF.GAME_STATE.PLAYING
    function onPauseBtn()
    	if gameState == CF.GAME_STATE.PLAYING then
    		gameState = CF.GAME_STATE.PAUSING
    		waveLabel:setVisible(false)
            pauseLabel:setVisible(true)
        elseif gameState == CF.GAME_STATE.PAUSING then
            gameState = CF.GAME_STATE.PLAYING
            waveLabel:setVisible(true)
            pauseLabel:setVisible(false)
        end
    end

    function onSpeedBtn()
    	local scheduler = cc.Director:getInstance():getScheduler()
        if scheduler:getTimeScale() == 1 then
            scheduler:setTimeScale(2)
        elseif scheduler:getTimeScale() == 2 then
            scheduler:setTimeScale(1)
        end
    end

    function onMenuBtn()
    	menuLayer:setVisible(true)
        gameMenu:setEnabled(false)
    end

    pauseAndResume:registerScriptTapHandler(onPauseBtn)
    speedBtn:registerScriptTapHandler(onSpeedBtn)
    menuBtn:registerScriptTapHandler(onMenuBtn)

    function update()
    end

    self:scheduleUpdateWithPriorityLua(update, 0)
end

function StageScene:updateDataMsg(msg)
    if msg == "money" then
        self._moneyLabel:setString(self._dataModel:getMoney())
    elseif msg == "object" then
        local clear = cc.Sprite:createWithSpriteFrameName("targetscleard_CN.png")
        clear:setPosition(cc.p(center.x, -44))
        clear:runAction(cc.Sequence:create(
            cc.MoveBy:create(0.5, cc.p(0, 88)),
            cc.DelayTime:create(7),
            cc.RemoveSelf:create(true)
        ))
        self:addChild(clear, 100)
    end
end

function StageScene:updateCurWaveLabel(number)
    local str = number < 10 and ("0" .. number) or ("" .. number)
    self._curWave:setString(str)
end

function StageScene:updateTotalWaveLabel(number)
    local str = number < 10 and ("0" .. number) or ("" .. number)
    self._totalWave:setString(str)
end

function createTestScene()
    local scene = StageScene.new()
    scene:addChild(StageLayer.new())
    return scene
end