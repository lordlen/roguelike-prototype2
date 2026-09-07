class_name ItemAction
extends Resource

enum Target {
	SELF,
	GROUND
}

@export var target: Target = Target.SELF
@export var action_name: String = "Discard"
@export var effect_range: int = 3
@export var effect_radius: int = 0
@export var uses_turn: bool = false
@export var num_uses: int = 100

func use(owner: Char, pos: Vector2i) -> bool:
	return true

func get_description() -> String:
	return ""

func get_radius_desc() -> String:
	if effect_radius == 0:
		return ""
	return " (radius: %d)" % effect_radius

func is_usable(owner: Char):
	return true

func _get_target_chars(pos: Vector2i) -> Array[Char]:
	var positions : Array[Vector2i] = []
	for x in range(pos.x - effect_radius, pos.x + effect_radius + 1):
		for y in range(pos.y - effect_radius, pos.y + effect_radius + 1):
			positions.push_back(Vector2i(x, y))
	return ActorManager.get_actors_in_positions(positions)
