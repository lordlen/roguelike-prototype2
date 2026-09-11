class_name SummonLine
extends CardEffect

@export var char_resource: CharacterStats

func get_identifier() -> String:
	return "summon_line"
	
func get_description() -> String:
	return 'Spawn "x" in front of the target.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var pf := Pathfinder.new()
	var path := pf.get_straight_path(actor.grid_position, target_pos, actor.traversal)
	if len(path) >= 3:
		var cell := path[-2]
		var new_char := ActorManager.spawn_character(char_resource)
		new_char.move_to(cell)
		new_char.follow(actor)
		new_char.deck.discard_all()
	else:
		var summon := Summon.new()
		summon.num_summons = 1
		summon.char_resource = char_resource
		summon.do(actor, target_pos, card)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return '%s "%s"' % [super.get_shortform(card), char_resource.character_name]

func get_shortform_desc() -> String:
	return "[color=orange]%s[/color] x" % [get_identifier()]
