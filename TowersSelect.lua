TowersSelect = class("TowersSelect", function()
	return cc.Sprite:create()
end)

TowersSelect.__index = TowersSelect
TowersSelect._isShow = false
TowersSelect._towers = {}

local distance = 100
function TowersSelect:ctor(array)
	self._isShow = false
	self._towers = {}
	for i, mark in pairs(array) do
		local tower = TowersIcon.new(mark)
		self:addChild(tower)
		self._towers[#self._towers + 1] = tower

		local y = 40
		if #array > 4 and i < 5 then y = 130 end
		tower:setPosition(cc.p(((i - 1) % 4 + 0.5) * distance, y))
	end

	if #array > 4 then
		self:setContentSize(cc.size(distance * 4, 170))
	else
		self:setContentSize(cc.size(distance * #array, 80))
	end

	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:showTowers(false)
end

function TowersSelect:isShow()
	return self._isShow
end

function TowersSelect:getTowersByPos(pos)
	local locPos = self:convertToNodeSpace(pos)
	for _, tower in pairs(self._towers) do
		if cc.rectContainsPoint(tower:getBoundingBox(), locPos) then
			return tower:getTower()
		end
	end

	return nil
end

local velocity = 0.1
function TowersSelect:showTowers(show)
	if show == self._isShow then return end
	self._isShow = show

	if not self._isShow then
		for _, tower in pairs(self._towers) do
			tower:runAction(cc.Sequence:create(
				cc.ScaleTo:create(velocity, 0.1),
				cc.Hide:create()
			))
		end
	else
		for _, tower in pairs(self._towers) do
			tower:runAction(cc.Sequence:create(
				cc.Show:create(),
				cc.ScaleTo:create(velocity, 1)		
			))
		end
	end
end