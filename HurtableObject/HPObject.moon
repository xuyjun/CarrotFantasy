export HPObject = _G["class"] "HPObject", -> cc.Sprite\createWithSpriteFrameName "MonsterHP01.png"

with HPObject
	.__index = HPObject
	._totalHP = 0
	._leftHP = 0
	._isShow = false
	._empty = nil
	._schduleID = nil

HPObject.ctor = (hp) =>
	@_totalHP = hp
	@_leftHP = hp
	@_isShow = false
	@_schduleID = nil

	with @_empty = cc.ProgressTimer\create cc.Sprite\createWithSpriteFrameName "MonsterHP02.png"
		\setType cc.PROGRESS_TIMER_TYPE_BAR
		\setMidpoint cc.p 1, 0
		\setBarChangeRate cc.p 1, 0
		\setPosition cc.p @\getContentSize!.width / 2, @\getContentSize!.height / 2
		@\addChild @_empty, 1
	@\setVisible false

HPObject.isEmpty = =>
	@_leftHP <= 0

showTime = 3
HPObject.show = =>
	if @_isShow
		@\stopAction @_schduleID
	else
		@\setVisible true
	@_schduleID = schedule @, (-> @\setVisible false), showTime

HPObject.decreaseHP = (hp) =>
	@_leftHP -= hp
	if @_leftHP < 0 then @_leftHP = 0
	@_empty\setPercentage 100 * (@_totalHP - @_leftHP) / @_totalHP
	@\show!
