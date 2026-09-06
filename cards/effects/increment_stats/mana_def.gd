class_name ManaDef
extends CardEffect

func get_identifier() -> String:
	return "mana_def"
	
func get_description() -> String:
	return "Increase this card's defense by the defense of \"Cast Spell\""

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var cast_spell: CardInstance = actor.deck.find_card("Cast Spell")
	var def_value := 0
	if cast_spell:
		def_value = cast_spell.defense
	var def_up := DefUp.new()
	def_up.value = def_value
	def_up.do(actor, target_pos, card)
	card_effect_finished.emit()
