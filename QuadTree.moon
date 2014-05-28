rectContainsRect = (rect1, rect2) ->
	result = true
	result = result and rect1.x < rect2.x
	result = result and rect1.x + rect1.width > rect2.x + rect.width
	result = result and rect1.y < rect2.y
	result = result and rect1.y + rect1.height > rect2.y + rect.height
	return result

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

QuadTree.findIndex = (rect) =>
	-- TODO
	top = rect.y > @_rect.y + @_rect.height / 2
	right = rect.x > @_rect.x + @_rect.width / 2
	if top
		if right then QuadTree.TR
		else QuadTree.TL
	else
		if right then QuadTree.BR
		else QuadTree.BL
	(-1)