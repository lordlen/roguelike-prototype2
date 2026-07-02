class_name FloorDescription
extends Resource

@export var room_patterns: Array[PatternResource]
@export var special_patterns: Array[PatternResource]
@export var stairs_patterns: Array[PatternResource]

@export var num_rooms: int = 12
@export var num_initial_spawns: int = 8
@export var num_elite_spawns: int = 1
@export var turns_per_spawn: int = 80

@export var item_pool: ItemPoolDescription
# items
@export var potion_ratio: float = 1
@export var shrine_ratio: float = 0 # 0.3
@export var gold_ratio: float = 1

@export var initial_spawns: SpawnDescription
@export var subsequent_spawns: SpawnDescription
@export var elite_spawns: SpawnDescription
