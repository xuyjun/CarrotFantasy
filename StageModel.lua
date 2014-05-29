StageModel = class("StageModel")

StageModel.__index = StageModel

StageModel._money = 0
StageModel._totalWave = 0
StageModel._curWave = 0
StageModel._life = 0

StageModel._paths = {}
StageModel._waves = {}
StageModel._grid = {}

StageModel._towers = {}
StageModel._monsters = {}
StageModel._objectsCount = 0
StageModel._monsterTree = nil

StageModel._observers = {}

StageModel._stageScene = nil
StageModel._stageLayer = nil

function StageModel:getInstance()
	if not self._instance then
		self._instance = StageModel.new()
	end
	return self._instance
end

function StageModel:ctor()
	self:clear()
end

function StageModel:clear()
	self._money = 0
	self._totalWave = 0
	self._curWave = 1
	self._life = 10

	self._paths = {}
	self._waves = {}
	self._grid = initArray(MAX_ROW, MAX_COL, GRID_BAN)

	self._towers = {}
	self._monsters = {}
	self._objectsCount = 0
	self._monsterTree = QuadTree.new(cc.rect(0, 0, winSize.width, winSize.height), 1)

	self._observers = {}
end

function StageModel:getMoney()
	return self._money
end

function StageModel:setMoney(money)
	if self._money == money then return end
	self._money = money
	self:notifyObserver("money")
end

function StageModel:getTotalWave()
	return self._totalWave
end

function StageModel:getCurWave()
	return self._curWave
end

function StageModel:nextWave()
	self._curWave = self._curWave + 1
	self._stageScene:updateCurWaveLabel(self._curWave)
end

function StageModel:getLife()
	return self._life
end

function StageModel:decreaseLife(num)
	self._life = self._life - num
	self:notifyObserver("life")
end

function StageModel:getGridObject(grid)
	return self._grid[grid.row][grid.col]
end

function StageModel:setGridObject(grid, obj)
	self._grid[grid.row][grid.col] = obj
end

function StageModel:addTower(tower)
	self._towers[#self._towers + 1] = tower
end

function StageModel:removeTower(tower)
	for i, t in ipairs(self._towers) do
		if t == tower then
			table.remove(self._towers, i)
			break
		end
	end
end

function StageModel:getTowers()
	return self._towers
end

function StageModel:removeMonster(monster)
	for i, m in ipairs(self._monsters) do
		if m == monster then
			table.remove(self._monsters, i)
			break
		end
	end
	if #self._monsters == 0 then
		self:notifyObserver("monster")
	end
end

function StageModel:updateTree()
	self._monsterTree:clear()
	for i, m in ipairs(self._monsters) do
		self._monsterTree:insert(m)
	end
end

function StageModel:decreaseObject()
	assert(self._objectsCount > 0, "objectsCount must be greater than 0")

	self._objectsCount = self._objectsCount - 1
	if self._objectsCount <= 0 then
		self:notifyObserver("object")
	end
end

function StageModel:getPathLength(index)
	return #self._paths
end

function StageModel:getPathByIndex(index)
	return self._paths[index]
end

function StageModel:addObserver(observer)
	self._observers[#self._observers + 1] = observer
end

function StageModel:removeObserver(observer)
	for i, o in ipairs(self._observers) do
		if o == observer then
			table.remove(self._observers, i)
			break
		end
	end
end

function StageModel:notifyObserver(msg)
	for i, observer in ipairs(self._observers) do
		if observer and observer.updateDataMsg then
			observer:updateDataMsg(msg)
		end
	end
end

function StageModel:parseTMXFile(tmxFile)
	local map = cc.TMXTiledMap:create(tmxFile)
	local group = map:getObjectGroup("PATH")
	local objects = group:getObjects()
		
	for i = 1, #objects do
		local dict = objects[i]
		local name = dict["name"]
		local num = nil

		num = string.match(name, "PT(%d)")
		if num then
			num = tonumber(num)
			self._paths[num] = cc.p(dict["x"], dict["y"])
		end

		num = string.match(name, "Obj")
		if num then
			local x = dict["x"]
			local y = dict["y"]
			local width = dict["width"]
			local height = dict["height"]
			local pos = posToGrid(cc.p(x, y))
			local row, col = height / GRID_WIDTH, width / GRID_WIDTH

			for j = 0, row - 1 do
				for k = 0, col - 1 do
					self._grid[pos.row + j][pos.col + k] = GRID_EMPTY
				end
			end
		end

		num = string.match(name, "(%d)Ob")
		if num then										
			local key = "CLOUD" .. num
			local objType = ObjectsType[key]
			local obj = GridObject.new(objType)

			local x = dict["x"]
			local y = dict["y"]
			local width = dict["width"]
			local height = dict["height"]
			obj:setGridRange(x, y, width, height)
			self._objectsCount = self._objectsCount + 1

			local pos = cc.p(x + width / 2, y + height / 2)
			obj:setPosition(pos)
			self._stageLayer:addChild(obj, 10)
		end
	end
end
--[[
function StageModel:initStage(stageData)
	self:clear()
	self._money = stageData.MONEY
	self._totalWave = stageData.TOTAL_WAVE
	self._curWave = 1
	self:parseTMXFile(stageData.TMX_FILE)

	self:notifyObserver("money")

	local len = #self._paths
	self._stageLayer:initPathLabel(self._paths[1], self._paths[len - 1], self._paths[len])
end
]]--
function StageModel:runWithData(stageData)
	self:clear()
	self._money = stageData.MONEY
	self._totalWave = stageData.TOTAL_WAVE
	self._curWave = 1
	self._stageScene = StageScene.new()
	self._stageLayer = StageLayer.new()
	self._stageScene:addChild(self._stageLayer)

	self:parseTMXFile(stageData.TMX_FILE)

	-- for i, wave in ipairs(stageData.WAVES) do

	self:notifyObserver("money")

	-- local len = #self._paths
	-- self._stageLayer:initPathLabel(self._paths[1], self._paths[len - 1], self._paths[len])
	self._stageLayer:initPathLabel()
	createGo(self._stageScene)
	cc.Director:getInstance():runWithScene(self._stageScene)
end