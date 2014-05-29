StageLayer = class("StageLayer", function()
    return cc.Layer:create()
end)

StageLayer.__index = StageLayer
StageLayer._carrot = nil
StageLayer._lifeLabel = nil
StageLayer._dataModel = nil

function StageLayer:ctor()
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme1_bg1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme1_stage1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_item01)
    
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme1_monsters1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme1_monsters2)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme1_object1)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(s_theme1_object2)

    self._dataModel = StageModel:getInstance()
    self._dataModel:addObserver(self)

    local bg = cc.Sprite:createWithSpriteFrameName("BG1.png")
    bg:setPosition(center)
    self:addChild(bg)

    local path = cc.Sprite:createWithSpriteFrameName("Path.png")
    path:setPosition(center)
    self:addChild(path)

    local selectGrid = cc.Sprite:createWithSpriteFrameName("select_00.png")
    selectGrid:runAction(createSelect())
    selectGrid:setVisible(false)
    selectGrid:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    self:addChild(selectGrid, 1)

    local banSprite = cc.Sprite:createWithSpriteFrameName("forbidden.png")
    banSprite:setOpacity(0)
    self:addChild(banSprite)

    local towersSelect = TowersSelect.new({"1T", "2T", "3T", "4T", "5T", "2T"})
    towersSelect:setPosition(cc.p(-1000, -1000))
    self:addChild(towersSelect, 100)

    local carrot = Carrot.new()
    carrot:setPosition(cc.p(-1000, -1000))
    self:addChild(carrot, 15)

    local lifeLabel = cc.Sprite:createWithSpriteFrameName("BossHP10.png")
    lifeLabel:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    lifeLabel:setPosition(cc.p(-1000, -1000))
    self:addChild(lifeLabel, 15)

    local test = cc.Sprite:createWithSpriteFrameName("countdown_12.png")
    test:setPosition(cc.p(400, 400))
    self:addChild(test)
    test = cc.Sprite:createWithSpriteFrameName("countdown_13.png")
    test:setPosition(cc.p(500, 400))
    self:addChild(test)

    self._carrot = carrot
    self._lifeLabel = lifeLabel

    local function showBan(center)
        banSprite:setOpacity(200)
        banSprite:setPosition(center)
        banSprite:stopAllActions()
        banSprite:runAction(cc.FadeTo:create(0.5, 0))
    end

    local function showTowersSelect(pos, visible)
        local halfH = towersSelect:getContentSize().height / 2
        local halfW = towersSelect:getContentSize().width / 2
        if visible then
            towersSelect:showTowers(true)
            local offsetX = 0
            local offsetY = 0

            if pos.y > GRID_WIDTH * 4 then
                offsetY = -40 - halfH
            else
                offsetY = 40 + halfH
            end

            if pos.x < halfW then
                offsetX = halfW - pos.x
            elseif pos.x > (winSize.width - halfW) then 
                offsetX = winSize.width - halfW - pos.x
            end

            towersSelect:setPosition(cc.pAdd(pos, cc.p(offsetX, offsetY)))
        else
            towersSelect:showTowers(false)
        end
    end

    local selectedTower = nil
    local function onTouchBegan(touch, event)
        local pos = touch:getLocation()
        local center = posToCenter(pos)
        local grid = posToGrid(pos)

        if pos.y > GRID_WIDTH * 7 then return false end

        if towersSelect:isShow() then                   
            local tower = towersSelect:getTowersByPos(pos)
            if tower then
                local sx, sy = selectGrid:getPosition()
                tower:setPosition(sx, sy)
                self:addChild(tower, 10)
                local g = posToGrid(cc.p(sx, sy))
                self._dataModel:setGridObject(g, tower)
            end
        end

        if selectGrid:isVisible() then
            selectGrid:setVisible(false)
            if towersSelect:isShow() then
                showTowersSelect(nil, false)
            elseif selectedTower then
                selectedTower:showMenu(false)
                selectedTower:dealMenuByPos(pos)
                selectedTower = nil
            end
            return false
        end

        local obj = self._dataModel:getGridObject(grid)
        if obj == GRID_BAN then
            showBan(center)
            return false
        elseif obj == GRID_EMPTY then
            selectGrid:setVisible(true)
            selectGrid:setPosition(center)
            showTowersSelect(center, true)
        elseif obj.__cname == "Carrot" then
            obj:activate()
        elseif obj.__cname == "GridObject" then
            obj:hurt(10)
        else
            selectGrid:setVisible(true)
            selectGrid:setPosition(center)
            selectedTower = obj
            selectedTower:showMenu(true)
        end
        return false
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    function onNodeEvent(tag)
        if tag == "enter" then
            --dataModel:initStage(SkylineData.Stage1)

            local mon = Monster.new(MonstersType.LAND_PINK, 999)
            mon:setPosition(self._dataModel:getPathByIndex(1))
            mon:born()
            mon:hurt(50)
            self:addChild(mon, 10)
        elseif tag == "exit" then

        end
    end
    self:registerScriptHandler(onNodeEvent)

    -- self:initPathLabel()
end

function StageLayer:updateDataMsg(msg)
    if msg == "life" then
        local life = self._dataModel:getLife()
        self._carrot:setLife(life)
        local str = life < 10 and ("0" .. life) or ("" .. life)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("BossHP" .. str .. ".png")
        self._lifeLabel:setSpriteFrame(frame)
    end
end

function StageLayer:initPathLabel()
    local model = self._dataModel
    local pathLen  = model:getPathLength()
    local startPos = model:getPathByIndex(1)
    local pos = model:getPathByIndex(pathLen - 1)
    local labelPos = model:getPathByIndex(pathLen)

    local posGrid = posToGrid(pos)
    posGrid.row = posGrid.row - 1
    local labelGrid = posToGrid(labelPos)
    labelGrid.row = labelGrid.row - 1
    self._carrot:initGrid(posGrid, labelGrid)
    self._carrot:setPosition(pos.x + GRID_WIDTH / 2, pos.y - 50)
    self._lifeLabel:setPosition(labelPos.x + GRID_WIDTH / 2, labelPos.y)

    local carrotBase = cc.Sprite:createWithSpriteFrameName("hlb0.png")
    carrotBase:setPosition(pos.x + GRID_WIDTH / 2, pos.y - 50)
    self:addChild(carrotBase, 14)

    local startLabel = cc.Sprite:createWithSpriteFrameName("start01.png")
    startLabel:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
    startLabel:setPosition(startPos.x + GRID_WIDTH / 2, startPos.y)
    self:addChild(startLabel, 15)
end
