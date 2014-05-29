export HurtableObject = _G["class"] "HurtableObject", -> cc.Sprite\create!

with HurtableObject
	.__index = HurtableObject
	._isDead = false
	._dataModel = nil
	._hpObject = nil
	._money = 0

HurtableObject.ctor = (hp, money) =>
	@_isDead = false
	@_hpObject = HPObject.new hp
    @\addChild @_hpObject, 1
	@_money = money
	@_dataModel = StageModel\getInstance!

HurtableObject.isDead = =>
	@_isDead

HurtableObject.hurt = (hp) =>
	with @_hpObject
		\setPosition cc.p @\getContentSize!.width / 2, 100
		\decreaseHP hp
		if \isEmpty! then @\die!

HurtableObject.die = =>
	@_isDead = true
	@_dataModel\setMoney @_dataModel\getMoney! + @_money

	x, y = @\getPosition!
	str = @_money < 10 and ("0" .. @_money) or ("" .. @_money)
	with moneySprite = cc.Sprite\createWithSpriteFrameName "money" .. str .. ".png"
		@\getParent!\addChild moneySprite, 15
		\setPosition cc.p x, y + 60
		\runAction cc.Sequence\create (cc.MoveBy\create 0.5, cc.p 0, 40),
			cc.FadeOut\create 0.2,
			cc.RemoveSelf\create true