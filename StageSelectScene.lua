StageSelectLayer = class("StageSelectLayer", function()
    return SelectSlideLayer.new()
end)

StageSelectLayer.disableColor = cc.c3b(70, 70, 70)
StageSelectLayer.enableColor = cc.c3b(255, 255, 255)
StageSelectLayer._theme = nil
StageSelectLayer._waveLabel = nil
StageSelectLayer._towersSprite = nil

function StageSelectLayer:ctor(theme)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(theme.SELECT_PLIST)
    self._velocity = 3000
    self._theme = theme

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
        stage:setColor(StageSelectLayer.disableColor)

        array[#array + 1] = stage
    end
    self:initWithArray(array, 515)

    local waveLabel = cc.Sprite:create()
    waveLabel:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    waveLabel:setPosition(cc.p(480, 545))
    self:addChild(waveLabel)

    self._list:getChildByTag(0):setColor(StageSelectLayer.enableColor)
    self._list:setPosition(cc.p(0, 40))

    local towersSprite = cc.Sprite:create()
    towersSprite:setPosition(cc.p(center.x, 150))
    self:addChild(towersSprite)

    local cloud = cc.Sprite:createWithSpriteFrameName("ss_cloud.png")
    cloud:setPosition(center)
    self:addChild(cloud)

    self._waveLabel = waveLabel
    self._towersSprite = towersSprite
    self:changeTowers()
    self:changeWaveLabel()
end

function StageSelectLayer:onSelected()
    local index = self._curIndex
    local str = "Stage" .. index
    local stageData = self._theme.STAGE_DATA[str]
    local scene = StageScene.new(stageData)
    scene:addChild(StageLayer.new(stageData))
    StageModel:getInstance():initStage(stageData)
    cc.Director:getInstance():replaceScene(scene)
end

local spriteFrameCache = cc.SpriteFrameCache:getInstance()
function StageSelectLayer:changeWaveLabel()
    local stage = "Stage" .. (self._curIndex + 1)
    local count = self._theme.STAGE_DATA[stage].TOTAL_WAVE
    local str = "ss_waves_" .. count .. ".png"
    self._waveLabel:setSpriteFrame(spriteFrameCache:getSpriteFrame(str))
end

function StageSelectLayer:changeTowers()
    local i = self._curIndex + 1
    local num = i > 9 and ("" .. i) or ("0" .. i)
    self._towersSprite:setSpriteFrame(spriteFrameCache:getSpriteFrame(string.format("ss_towers_%s.png", num)))
end

function StageSelectLayer:changePlayBtn()
    local parent = self:getParent()
    if self._theme.UNLOCK_STAGE[self._curIndex + 1] >= 1 then
        parent._playBtn:setEnabled(true)
    else
        parent._playBtn:setEnabled(false)
    end
end

function StageSelectLayer:onTouchEnded(touch, evnet)
    local leftRect = cc.rect(0, self._rect.y, self._rect.x, self._rect.height)
    local rightRect = cc.rect(self._rect.x + self._rect.width, self._rect.y, self._rect.x, self._rect.height)

    self._list:getChildByTag(self._curIndex):setColor(StageSelectLayer.disableColor)
    local point = touch:getLocation()
    SelectSlideLayer.onTouchEnded(self, touch, evnet)
    if self._curMouseX == self._oldMouseX then
        if cc.rectContainsPoint(leftRect, point)
            and self._curIndex > 0 then
            self:slideToPre()
        elseif cc.rectContainsPoint(rightRect, point)
            and self._curIndex < self._total - 1 then
            self:slideToNext()
        end
    end
    self._list:getChildByTag(self._curIndex):setColor(StageSelectLayer.enableColor)

    self:changeTowers()
    self:changePlayBtn()
    self:changeWaveLabel()
end


function createStageSelectScene(theme)
	local scene = createSelectScene()

    local backNormal = cc.Sprite:createWithSpriteFrameName("ss_back_normal.png")
    local backPress = cc.Sprite:createWithSpriteFrameName("ss_back_pressed.png")
    local backBtn = cc.MenuItemSprite:create(backNormal, backPress)
    backBtn:setPosition(cc.p(-430, 290))

    local playNoraml = cc.Sprite:createWithSpriteFrameName("ss_play_normal_CN.png")
    local playPress = cc.Sprite:createWithSpriteFrameName("ss_play_pressed_CN.png")
    local playDisable = cc.Sprite:createWithSpriteFrameName("ss_locked_CN.png")
    scene._playBtn = cc.MenuItemSprite:create(playNoraml, playPress, playDisable)
    scene._playBtn:setPosition(cc.p(0, -250))

    menu:addChild(backBtn)
    menu:addChild(scene._playBtn)

    local layer = StageSelectLayer.new(theme)
    scene:addChild(layer)

    local function onBackBtn()
        cc.Director:getInstance():popScene()
    end

    local function onPlayBtn()
        layer.onSelected()
    end

    local function onHelpBtn()
        cc.Director:getInstance():popScene()
        cc.Director:getInstance():replaceScene(createHelpScene())
    end

    backBtn:registerScriptTapHandler(onBackBtn)
    scene._playBtn:registerScriptTapHandler(onPlayBtn)
    helpBtn:registerScriptTapHandler(onHelpBtn)

    scene.onPlayBtn = onPlayBtn

	return scene
end