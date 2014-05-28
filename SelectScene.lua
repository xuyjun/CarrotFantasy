function createSelectScene()
    local scene = cc.Scene:create()

    local bg = cc.Sprite:createWithSpriteFrameName("ss_bg.png")
    bg:setPosition(center)
    scene:addChild(bg)

    local title = cc.Sprite:createWithSpriteFrameName("theme_bg_CN.png")
    title:setPosition(center)
    scene:addChild(title)

    local function onHelpBtn()
    	cc.Director:getInstance():replaceScene(cc.TransitionSlideInT:create(0.2, createHelpScene()))
    end

    local helpNormal = cc.Sprite:createWithSpriteFrameName("ss_help_normal.png")
    local helpPress = cc.Sprite:createWithSpriteFrameName("ss_help_pressed.png")
    helpBtn = cc.MenuItemSprite:create(helpNormal, helpPress)
    helpBtn:registerScriptTapHandler(onHelpBtn)
    helpBtn:setPosition(cc.p(430, 290))

    menu = cc.Menu:create(helpBtn)
    scene:addChild(menu)

    return scene
end