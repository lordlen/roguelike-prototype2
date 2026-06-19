class_name FeatureBuilder
extends MapBuilder

class FeatureBuilderConstructor:
	var size : Vector2i
	var patterns: Array[RoomPattern]
	var num_features: int

	func set_dimensions(v: Vector2i) -> FeatureBuilderConstructor:
		size = v
		return self
	
	func set_patterns(patterns: Array[RoomPattern]) -> FeatureBuilderConstructor:
		self.patterns = patterns
		return self
	
	func set_num_features(num_features: int) -> FeatureBuilderConstructor:
		self.num_features = num_features
		return self

	func construct() -> FeatureBuilder:
		return FeatureBuilder.new(size.x, size.y, patterns, num_features)

var width : int
var height: int
var patterns: Array[RoomPattern]
var num_features: int
func _init(width: int, height: int, patterns: Array[RoomPattern], num_features: int) -> void:
	self.width = width
	self.height = height
	self.patterns = patterns
	self.num_features = num_features

func build(floor: Floor) -> Floor:
	var fail_limit := 100
	var num_failures := 0
	
	var num_successful_placements := 0
	
	while num_successful_placements < num_features and num_failures < fail_limit:
		
		# choose a random direction
		var dir : Vector2i = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT].pick_random()
		
		# choose a random position in the floor
		var position : Vector2i = floor.get_all_tiles().keys().pick_random()
		
		# choose a random room pattern
		var pattern: RoomPattern = patterns.pick_random()
		
		var points := pattern.get_used_cells(dir, position)
		
		# try to place the pattern somewhere
		if floor.is_within_used_cells(points):
			floor.append_back(points, pattern.get_cell_types())
			num_successful_placements += 1
			num_failures = 0
		else:
			num_failures += 1
		
	return floor
