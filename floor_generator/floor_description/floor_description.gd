class_name FloorDescription
extends Resource

@export var room_patterns: Array[PatternResource]
@export var treasure_patterns: Array[PatternResource]
@export var stairs_patterns: Array[PatternResource]

@export var num_rooms: int = 30
@export var num_treasure: int = 2
@export var num_initial_spawns: int = 8
@export var turns_per_spawn: int = 40

@export var initial_spawns: SpawnDescription
@export var subsequent_spawns: SpawnDescription
