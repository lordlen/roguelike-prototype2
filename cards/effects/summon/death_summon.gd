class_name DeathSummon
extends CardEffect

@export var char_resource: CharacterStats
@export var num_summons: int = 1

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if actor.is_dead():
		var new_char := ActorManager.spawn_character(char_resource)
		new_char.move_to(actor.grid_position)
		var summon := Summon.new()
		summon.char_resource = char_resource
		summon.num_summons = num_summons - 1
		summon.follow_leader = false
		summon.do(actor, target_pos, card)
	card_effect_finished.emit()

func get_identifier() -> String:
	return "death_summon"

func get_description() -> String:
	return 'If hp is 0, summon n "x" characters.'

func get_shortform(card: CardInstance) -> String:
	return '%d %s "%s"' % [num_summons, super.get_shortform(card), char_resource.character_name]

func get_shortform_desc() -> String:
	return "n [color=orange]%s[/color] x" % [get_identifier()]
