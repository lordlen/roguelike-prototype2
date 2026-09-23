class_name Summon
extends CardEffect

@export var num_summons: int
@export var char_resource: CharacterStats
var follow_leader: bool = true

func get_identifier() -> String:
	return "summon"
	
func get_description() -> String:
	return 'Spawn "x" n times in a random adjacent tile.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var valid_adjacent := Globals.floor_map.get_valid_adjacent(actor.grid_position)
	valid_adjacent.shuffle()
	for i in range(min(num_summons, len(valid_adjacent))):
		var cell := valid_adjacent[i]
		var new_char := ActorManager.spawn_character(char_resource)
		new_char.move_to(cell)
		if follow_leader:
			new_char.follow(actor)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return '%d %s "%s"' % [num_summons, super.get_shortform(card), char_resource.character_name]

func get_shortform_desc() -> String:
	return "n [color=orange]%s[/color] x" % [get_identifier()]
