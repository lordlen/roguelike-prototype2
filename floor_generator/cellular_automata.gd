class_name CellularAutomataGenerator

var width: int
var height: int
var fill_ratio: float
var num_iterations: int
var rng: RandomNumberGenerator

func _init(width: int, height: int, fill_ratio: float, num_iterations: int) -> void:
	self.width = width
	self.height = height
	self.fill_ratio = fill_ratio
	self.num_iterations = num_iterations
	self.rng = RandomNumberGenerator.new()

func build() -> Dictionary[Vector2i, bool]:
	var living_cells : Dictionary[Vector2i, bool] = {}
	
	# initial fill
	for x in range(width):
		for y in range(height):
			var random_num :=  rng.randf()
			if random_num < fill_ratio:
				living_cells[Vector2i(x,y)] = true
	
	for i in range(num_iterations):
		var living_cells_copy := living_cells.duplicate_deep()
		for x in range(1, width - 1):
			for y in range(1, height - 1):
				var v := Vector2i(x,y)
				var adj_count := count_adjacent(living_cells, v)
				var survival_threshold := 4
				var birth_threshold := 5
				var rand_num := rng.randf()
				if v not in living_cells and adj_count > birth_threshold and rand_num > fill_ratio:
					living_cells_copy[v] = true
				elif v in living_cells and adj_count < survival_threshold  and rand_num < fill_ratio:
					living_cells_copy.erase(v)
		living_cells = living_cells_copy
	# print( float(len(living_cells)) / float((width * height)))
	return living_cells
	
func count_adjacent(dict: Dictionary[Vector2i, bool], v: Vector2i) -> int:
	var count := 0
	for x in range(v.x - 1, v.x + 2):
		for y in range(v.y - 1, v.y + 2):
			if Vector2i(x,y) in dict:
				count += 1
				
	
	return count
