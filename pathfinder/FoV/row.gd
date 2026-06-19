class_name Row

var depth: int
var start_slope: float
var end_slope: float

func _init(depth: int, start_slope: float, end_slope: float) -> void:
	self.depth = depth
	self.start_slope = start_slope
	self.end_slope = end_slope

func round_ties_up(n):
	return floor(n + 0.5)

func round_ties_down(n):
	return ceil(n - 0.5)

func tiles():
	var ret: Array[Vector2i] = []
	var min_col = round_ties_up(self.depth * self.start_slope)
	var max_col = round_ties_down(self.depth * self.end_slope)
	for col in range(min_col, max_col + 1):
		ret.push_back(Vector2i(self.depth, col))
	return ret

func next():
	return Row.new(self.depth + 1,self.start_slope,self.end_slope)
