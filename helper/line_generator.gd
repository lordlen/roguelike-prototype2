class_name BresenhamIterator
extends RefCounted

var start: Vector2i
var end: Vector2i
var maximum: int
var diff: Vector2i
var curr_start: Vector2i
var line: Array[Vector2i]
var line_ind: int
var counter : int

func _init(start: Vector2i, end: Vector2i, maximum: int) -> void:
	self.start = start
	self.end = end
	self.maximum = maximum
	self.counter = 0
	
	diff = end - start
	line = Geometry2D.bresenham_line(start, end)
	line_ind = 0

func skip_to_end():
	# set a new start as the last item in the line
	curr_start = line[len(line) - 1]
	
	# create a new line
	line = Geometry2D.bresenham_line(curr_start, curr_start + diff)
	
	# curr_start has already been iterated, so set line_ind to 1
	line_ind = 1

func should_continue():
	return start != end and counter < maximum

func _iter_init(_iter: Array) -> bool:
	curr_start = start
	line = Geometry2D.bresenham_line(start, end)
	counter = 0
	skip_to_end()
	return should_continue()

func _iter_next(_iter: Array) -> bool:
	line_ind += 1
	counter += 1
	if line_ind >= len(line):
		skip_to_end()
	return should_continue()

func _iter_get(_iter: Variant) -> Variant:
	return line[line_ind]
