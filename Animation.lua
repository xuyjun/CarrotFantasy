function createRepeatAnimate(frameName, delay)
    local animation = cc.Animation:create()
    for i, name in pairs(frameName) do
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(name)
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(delay)
    return cc.RepeatForever:create(cc.Animate:create(animation))
end

function createAnimate(frameName, delay, restore)
    local animation = cc.Animation:create()
    for i, name in pairs(frameName) do
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(name)
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(delay)
    restore = restore or true
    animation:setRestoreOriginalFrame(restore)
    return cc.Animate:create(animation)
end

function createSelect()
    local array = {}
    for i = 1, 4 do
        array[#array + 1] = string.format("select_0%d.png", i)
    end
    return createRepeatAnimate(array, 0.1)
end

function createAir0()
    local array = {}
    for i = 1, 5 do
        array[#array + 1] = string.format("air0%d.png", i)
    end
    return createAnimate(array, 0.05)
end

function createAir1()
    local array = {}
    for i = 1, 5 do
        array[#array + 1] = string.format("air1%d.png", i)
    end
    return createAnimate(array, 0.06)
end

function createAir2()
    local array = {}
    for i = 1, 6 do
        array[#array + 1] = string.format("air2%d.png", i)
    end
    return createAnimate(array, 0.05)
end

function createAir3()
    local array = {}
    for i = 1, 5 do
        array[#array + 1] = string.format("air3%d.png", i)
    end
    return createAnimate(array, 0.06);
end

function createCountdown0()
    local array = {}
    for i = 1, 3 do
        array[#array + 1] = string.format("countdown_0%d.png", i)
    end
    return createAnimate(array, 1)
end

function createCountdown1()
    local array = {}
    for i = 1, 3 do
        array[#array + 1] = string.format("countdown_1%d.png", i)
    end
    return createAnimate(array, 1)
end

function createPoint()
    local array = {}
    for i = 1, 3 do
        array[#array + 1] = string.format("point0%d.png", i)
    end
    return createRepeatAnimate(array, 0.1)
end

function createUpgrade()
    local array = {}
    for i = 1, 2 do
        array[#array + 1] = string.format("showupgrade0%d.png", i)
    end
    return createRepeatAnimate(array, 0.2)
end

function createLBShake()
    local array = {}
    for i = 0, 8 do
        array[#array + 1] = string.format("hlb1%d.png", i)
    end
    return createAnimate(array, 0.05)
end

function createLBBlink()
    local array = {}
    for i = 1, 3 do
        array[#array + 1] = string.format("hlb2%d.png", i)
    end
    return createAnimate(array, 0.1)
end

function createAttack(name, level, count)
    local array = {}
    for i = 1, count do
        array[#array + 1] = string.format("%s%d%d.png", name, level, i)
    end
    return createAnimate(array, 0.1)
end

function createMcm()
    local array = {}
    for i = 1, 2 do
        array[#array + 1] = string.format("mcm0%d.png", i)
    end
    return createAnimate(array, 0.05, false)
end