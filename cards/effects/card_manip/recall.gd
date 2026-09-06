class_name Recall
extends CardEffect

@export var card_name: String

func get_identifier() -> String:
	return "recall"
	
func get_description() -> String:
	return 'Put all "x" on top of the draw pile.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var cs = actor.deck.pop_all_cards(card_name)
	for c in cs:
		actor.deck.add_to_top_draw(c)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return '%s "%s"' % [super.get_shortform(card), card_name]

func get_shortform_desc() -> String:
	return "[color=orange]%s[/color] x" % [get_identifier()]
