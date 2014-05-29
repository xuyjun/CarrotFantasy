export Bullet = _G["class"] Bullet, -> cc.Sprite\create!

with Bullet
	.__index = Bullet
	._level = 1
	._attack = 0

Bullet.ctor = (level, attack) =>
	@_level = level
	@_attack = attack