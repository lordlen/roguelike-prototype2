class_name Quadrant

var north := 0
var east  := 1
var south := 2
var west  := 3

var cardinal : int
var origin : Vector2i

func _init(cardinal: int, origin: Vector2i) -> void:
	self.cardinal = cardinal
	self.origin = origin

func transform(tile: Vector2i) -> Vector2i:
	var row := tile.x
	var col := tile.y
	if self.cardinal == self.north:
		return Vector2i(origin.x + col, origin.y - row)
	if self.cardinal == self.south:
		return Vector2i(origin.x + col, origin.y + row)
	if self.cardinal == self.east:
		return Vector2i(origin.x + row, origin.y + col)
	if self.cardinal == self.west:
		return Vector2i(origin.x - row, origin.y + col)
	return Vector2i(0, 0)
