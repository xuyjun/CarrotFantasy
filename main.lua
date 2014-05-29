require "Cocos2d"
require "Cocos2dConstants"
require "OpenglConstants"
require "extern"
require "moonscript"

require "src/resource"
require "src/FuncLib"
require "src/GameData/GameData"
require "src/GameData/SkylineData"
require "src/GameData/ThemeData"
require "src/GameData/TowersData"
require "src/GameData/MonstersData"
require "src/GameData/ObjectData"
require "src/Animation"
require "src/SliderLayer"
require "src/WelcomeLayer"
require "src/SettingScene"
require "src/HelpScene"
require "src/SelectScene"
require "src/ThemeSelectScene"
require "src/StageSelectScene"
require "src/MenuIcon"
require "src/TowersSelect"
require "src/StageScene"
require "src/StageLayer"
require "src/Towers/Tower"
require "src/Towers/SkylineTowers"
require "src/StageModel"
require "src/Carrot"
require "src/QuadTree"
require "src/CountDown"

require "src/HurtableObject/HPObject"
require "src/HurtableObject/HurtableObject"
require "src/HurtableObject/Monster"
require "src/HurtableObject/GridObject"


winSize = cc.Director:getInstance():getWinSize()
center = cc.p(winSize.width / 2, winSize.height / 2)

local function main()
    collectgarbage("collect")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)


    -- local scene = cc.Scene:create()
    -- scene:addChild(createWelcomeLayer())
    -- cc.Director:getInstance():runWithScene(scene)
    StageModel:getInstance():runWithData(SkylineData.Stage1)
end

main()
