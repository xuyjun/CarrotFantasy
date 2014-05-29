require "DrawPrimitives"
export QuadTree = _G["class"] "QuadTree"

with QuadTree
	.__index = QuadTree
	._nodes = nil
	._stuckObjects = nil
	._objects = nil
	._rect = nil
	._depth = 0
	._maxObjects = 4
	._maxDepth = 4
	.TL = 1
	.TR = 2
	.BT = 3
	.BR = 4

QuadTree.ctor = (rect, depth, maxObjects, maxDepth) =>
	@_nodes = {}
	@_objects = {}
	@_stuckObjects = {}
	@_rect = rect
	@_depth = depth
	@_maxObjects = maxObjects or 4
	@_maxDepth = maxDepth or 4

QuadTree.clear = =>
	@_stuckObjects = {}
	@_objects = {}
	if #@_nodes then for node in *@_nodes do node\clear!
	@_nodes = {}

QuadTree.subdivive = =>
	depth = @_depth + 1
	{:x, :y, :width, :height} = @_rect
	width /= 2
	height /= 2
	@_nodes[QUadTree.TL] = QuadTree.new (cc.rect x, y + height, width, height), depth
	@_nodes[QUadTree.TR] = QuadTree.new (cc.rect x + width, y + height, width, height), depth
	@_nodes[QUadTree.BL] = QuadTree.new (cc.rect x, y, width, height), depth
	@_nodes[QUadTree.BR] = QuadTree.new (cc.rect x + width, y, width, height), depth

QuadTree.getIndex = (rect) =>
	top = rect.y > @_rect.y + @_rect.height / 2
	bottom = rect.y + rect.height < @_rect.y
	left = rect.x + rect.width < @_rect.x
	right = rect.x > @_rect.x + @_rect.width / 2
	if top
		if left then QuadTree.TL
		elseif right then QuadTree.TR
	elseif bottom
		if left then QuadTree.BL
		elseif right then QuadTree.BR
	else
		-1

QuadTree.insert = (obj) =>
	rect = obj\getBoundingBox!
	if #@_nodes != 0
		index = @\getIndex rect
		if index != -1
			@_nodes[index]\insert rect
		else
			@_stuckObjects[#@_stuckObjects + 1] = obj
		return

	@_objects[#@_objects + 1] = obj
	if #@_objects > @_maxObjects and @_depth < @_maxDepth
		@\subdivive!
		for obj in *@_objects do @\insert obj
		@_objects = {}

QuadTree.retrieve = (rect) =>
	out = {}
	if #@_nodes != 0
		index = @\getIndex rect
		if index != -1
			for obj in *@_nodes[index]\retrieve rect
				out[#out + 1] = obj
		else
			for node in *@_nodes
				if cc.rectIntersectsRect node._rect, rect
					for obj in *node\retrieve rect
						out[#out + 1] = obj

	for obj in *@_stuckObjects do out[#out + 1] = obj
	for obj in *@_objects do out[#out + 1] = obj
	out

QuadTree.debugDraw = =>
	{:x, :y, :width, :height} = @_rect
	if #@_nodes != 0		
		hw = width / 2
		hh = height / 2
		ccDrawRect (cc.p x, y), (cc.p x + hw, y + hh)
		ccDrawRect (cc.p x + hw, y), (cc.p x + width, y + hh)
		ccDrawRect (cc.p x, y + hh), (cc.p x + hw, y + height)
		ccDrawRect (cc.p x + hw, y + hh), (cc.p x + width, y + height)
	else
		ccDrawRect (cc.p x, y), (cc.p x + width, y + height)