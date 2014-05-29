export createGo = (scene) ->
	spriteBG = with cc.Sprite\createWithSpriteFrameName "countdown_11.png"
		\setPosition center
		\runAction cc.Sequence\create (cc.DelayTime\create 0.3),
			cc.ScaleTo\create 0.3, 0.2,
			cc.CallFunc\create ->
				scene\gameStart!,
			cc.RemoveSelf\create true

	size = spriteBG\getContentSize!	
	spriteGo = with cc.Sprite\createWithSpriteFrameName "countdown_13.png"
		\setPosition cc.p size.width / 2, size.height / 2
		\setRotation 180
		\setScale 3
		\runAction cc.ScaleTo\create 0.3, 1
		\runAction cc.RotateTo\create 0.3, 0
	spriteBG\addChild spriteGo, 1
	scene\addChild spriteBG, 100

export createCountDown = (scene) ->
	spriteBG = with cc.Sprite\createWithSpriteFrameName "countdown_11.png"
		\setPosition center
		\runAction cc.Sequence\create (cc.DelayTime\create 3.2),
			cc.ScaleTo\create 0.2, 0.2,
			cc.CallFunc\create ->
				scene\gameStart!,
			cc.RemoveSelf\create true	

	size = spriteBG\getContentSize!
	pos = cc.p size.width / 2, size.height / 2
	light = with cc.Sprite\createWithSpriteFrameName "countdown_12.png"
		\setPosition pos
		\runAction cc.Sequence\create (cc.RotateBy\create 3, -360 * 3),
			cc.RemoveSelf\create true

	num3 = with cc.Sprite\createWithSpriteFrameName "countdown_01.png"
		\setPosition pos
		\setScale 0.2
		\runAction cc.Sequence\create (cc.ScaleTo\create 0.2, 1),
			cc.DelayTime\create 0.8,
			cc.RemoveSelf\create true

	num2 = with cc.Sprite\createWithSpriteFrameName "countdown_02.png"
		\setPosition pos
		\setScale 0.2
		\setVisible false
		\runAction cc.Sequence\create (cc.DelayTime\create 1),
			cc.Show\create!,
			cc.ScaleTo\create 0.2, 1,
			cc.DelayTime\create 0.8,
			cc.RemoveSelf\create true

	num1 = with cc.Sprite\createWithSpriteFrameName "countdown_03.png"
		\setPosition pos
		\setScale 0.2
		\setVisible false
		\runAction cc.Sequence\create (cc.DelayTime\create 2),
			cc.Show\create!,
			cc.ScaleTo\create 0.2, 1,
			cc.DelayTime\create 0.8,
			cc.RemoveSelf\create true

	spriteGo = with cc.Sprite\createWithSpriteFrameName "countdown_13.png"
		\setPosition pos
		\setRotation 180
		\setScale 3
		\setVisible false
		\runAction cc.Sequence\create (cc.DelayTime\create 3),
			cc.Show\create!,
			cc.Spawn\create (cc.ScaleTo\create 0.2, 1),
				cc.RotateTo\create 0.2, 0

	spriteBG\addChild light, 1
	spriteBG\addChild num3, 1
	spriteBG\addChild num2, 1
	spriteBG\addChild num1, 1	
	spriteBG\addChild spriteGo, 1
	scene\addChild spriteBG, 100