class_name CardInstance
extends RefCounted

signal card_action_finished

var texture: Texture2D
var card_name: String
var description: String
var rarity: CardResource.Rarity

var attack: int
var defense: int
var num_hits: int
var atk_range: int
var is_dodge: bool
var exhausts: bool
var is_innate: bool
var is_ethereal: bool
var is_instant: bool

var attack_effects: Array[CardEffect]
var defense_effects: Array[CardEffect]
var on_use_effects: Array[CardEffect]
var on_hit_effects: Array[CardEffect]
var on_took_damage_effects: Array[CardEffect]
var on_move_effects: Array[CardEffect]
var on_discard_effects: Array[CardEffect]
var on_draw_effects: Array[CardEffect]
var on_any_attack_effects: Array[CardEffect]

var decay_exponent: int = 0
var bonus_defense := 0
var is_changed := false

func _init(r: CardResource):
	rarity = r.rarity
	texture = r.texture
	card_name = r.name
	
	attack = r.attack
	defense = r.defense
	num_hits = r.num_hits
	atk_range = r.range
	is_dodge = r.is_dodge
	exhausts = r.exhausts
	is_innate = r.is_innate
	is_ethereal = r.is_ethereal
	is_instant = r.is_instant
	
	attack_effects = r.attack_effects.duplicate(true)
	defense_effects = r.defense_effects.duplicate(true)
	on_use_effects = r.on_use_effects.duplicate(true)
	on_hit_effects = r.on_hit_effects.duplicate(true)
	on_took_damage_effects = r.on_took_damage_effects.duplicate(true)
	on_move_effects = r.on_move_effects.duplicate(true)
	on_discard_effects = r.on_discard_effects.duplicate(true)
	on_draw_effects = r.on_draw_effects.duplicate(true)
	on_any_attack_effects = r.on_any_attack_effects.duplicate(true)

func do_attack(actor: Char, defender: Char) -> void:
	await do_effects(actor, defender, attack_effects)

func do_defend(actor: Char) -> void:
	actor.is_defending = true
	if decay_exponent == 0:
		add_bonus_defense(defense / 2)
	else:
		decay_exponent = 0
	await do_effects(actor, actor, defense_effects)

func do_on_hit(attacker: Char, defender: Char) -> void:
	await do_effects(defender, attacker, on_hit_effects)

func do_on_took_damage(actor: Char) -> void:
	await do_effects(actor, actor, on_took_damage_effects)

func do_on_move_effects(actor: Char) -> void:
	await do_effects(actor, actor, on_move_effects)

func do_on_discard_effects(actor: Char) -> void:
	await do_effects(actor, actor, on_discard_effects)

func do_on_draw_effects(actor: Char) -> void:
	await do_effects(actor, actor, on_draw_effects)

func do_on_use_effects(actor: Char) -> void:
	await do_effects(actor, actor, on_use_effects)

func do_on_any_attack_effects(actor: Char) -> void:
	await do_effects(actor, actor, on_any_attack_effects)

func do_effects(actor: Char, target: Char, effects: Array[CardEffect]):
	for e in effects:
		e.do.call_deferred(actor, target, self)
		await e.card_effect_finished
	# remove tmp effects from the array
	for i in range(len(effects) - 1, -1, -1):
		var e := effects[i]
		if e.is_temp:
			effects.remove_at(i)
	EventBus.character_deck_updated.emit(actor)
	EventBus.character_deck_updated.emit(target)
	card_action_finished.emit()

func effect_is_changed():
	return is_changed

func get_all_effects():
	return attack_effects + defense_effects + on_hit_effects + on_took_damage_effects + on_move_effects + on_discard_effects

func get_description() -> String:
	var result := ""
	if exhausts:
		result += RichTextHelper.text_with_tooltip("Exhausts", "Remove from the deck when used.")
		result += ".\n"
	if is_innate:
		result += RichTextHelper.text_with_tooltip("Innate", "Always starts in your hand when reshuffling the deck.")
		result += ".\n"
	if is_instant:
		result += RichTextHelper.text_with_tooltip("Instant", "Attacking with this card will not use your turn.")
		result += ".\n"
	
	for e in self.attack_effects:
		result += e.get_shortform(self)
		result += '\n'
	
	if len(defense_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Block: \n", "Trigger effects when blocking")
		for e in defense_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'

	if len(on_hit_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Hit: \n", "Trigger effects when hit while this card is in the defense.")
		for e in on_hit_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'

	if len(on_took_damage_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Take Damage: \n", "Trigger effects when taking damage from anywhere.")
		for e in on_took_damage_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'

	if len(on_move_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Move: \n", "Trigger effects when you moved with a card effect from anywhere.")
		for e in on_move_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'
	
	if len(on_discard_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Discard: \n", "Trigger effects when you discard this card with another effect.")
		for e in on_discard_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'
	
	if len(on_draw_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Draw: \n", "Trigger effects when you draw this card.")
		for e in on_draw_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'
	
	if len(on_use_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Use: \n", "Trigger effects when you use this card.")
		for e in on_use_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'
	
	if len(on_use_effects) > 0:
		result += RichTextHelper.text_with_tooltip("On Any Attack: \n", "Trigger effects when you attack with any card.")
		for e in on_use_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'

	return result

func get_attack() -> String:
	return "%dx%d" % [attack, num_hits] if num_hits > 1 else str(attack)

func get_defense_string() -> String:
	return "∅" if is_dodge else str(get_defense())

func get_defense() -> int:
	return (defense >> decay_exponent) + bonus_defense

func get_block_defense() -> int:
	if decay_exponent == 0:
		return defense + bonus_defense
	else:
		return get_defense() + bonus_defense

func on_draw(owner: Char):
	reset_defense_decay()
	reset_bonus_defense()
	await do_on_draw_effects(owner)

func on_discard():
	reset_defense_decay()
	reset_bonus_defense()

func add_bonus_defense(val: int):
	bonus_defense += val

func reset_bonus_defense():
	bonus_defense = 0

func decay_defense():
	decay_exponent += 1

func reset_defense_decay():
	decay_exponent = 0

func duplicate() -> CardInstance:
	var dupe := CardResource.new()
	dupe.rarity = rarity
	dupe.texture = texture
	dupe.card_name = card_name
	dupe.attack = attack
	dupe.defense = defense
	dupe.num_hits = num_hits
	dupe.atk_range = atk_range
	dupe.is_dodge = is_dodge
	dupe.exhausts = exhausts
	dupe.is_innate = is_innate
	dupe.is_ethereal = is_ethereal
	dupe.is_instant = is_instant
	dupe.attack_effects = attack_effects.duplicate(true)
	dupe.defense_effects = defense_effects.duplicate(true)
	dupe.on_use_effects = on_use_effects.duplicate(true)
	dupe.on_hit_effects = on_hit_effects.duplicate(true)
	dupe.on_took_damage_effects = on_took_damage_effects.duplicate(true)
	dupe.on_move_effects = on_move_effects.duplicate(true)
	dupe.on_discard_effects = on_discard_effects.duplicate(true)
	dupe.on_draw_effects = on_draw_effects.duplicate(true)
	return CardInstance.new(dupe)
