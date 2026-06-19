class_name WaterGenerator

var width: int
var height: int
var rng: RandomNumberGenerator
func _init(width: int, height: int) -> void:
	self.width = width
	self.height = height
	self.rng = RandomNumberGenerator.new()

func build() -> Dictionary[Vector2i, bool]:
	var ret: Dictionary[Vector2i, bool] = {}
	# first pick a random point
	var x := rng.randi_range(0, width - 1)
	var y := rng.randi_range(0, height - 1)
	
	var failure_threshold := 3
	var failures := 0
	while failures < failure_threshold:
		var v := Vector2i(x,y)
		if v in ret or !(0 <= v.x and v.x < width and 0 <= v.y and v.y < height):
			failures += 1
		else:
			# first add the appropriate tiles in the dictionary
			ret[v] = true
			ret[v + Vector2i.UP] = true
			ret[v + Vector2i.DOWN] = true
			ret[v + Vector2i.LEFT] = true
			ret[v + Vector2i.RIGHT] = true
		
		# setup the next iteration
		var directions := [Vector2i(2, 1), Vector2i(-1, 2), Vector2i(-2,-1), Vector2i(1,-2)]
		var direction : Vector2i = directions.pick_random()
		x = x + direction.x
		y = y + direction.y
	
	return ret
