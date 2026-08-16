class_name CardInstance
extends RefCounted

signal card_action_finished

var texture: Texture2D
var card_name: String
var description: String

var attack: int
var defense: int
var num_hits: int
var atk_range: int
var is_dodge: bool
var exhausts: bool
var is_innate: bool
var is_ethereal: bool
var is_instant: bool

var effects: Dictionary[String, Array]

var attack_effects: Array[CardEffect]
var defense_effects: Array[CardEffect]
var on_hit_effects: Array[CardEffect]
var on_took_damage_effects: Array[CardEffect]
var on_move_effects: Array[CardEffect]

var tmp_attack_effects: Array[CardEffect]
var tmp_defense_effects: Array[CardEffect]
var tmp_on_hit_effects: Array[CardEffect]

var bonus_defense := 0
var defense_decay := 0
var is_changed := false

func _init(r: CardResource):
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
	on_hit_effects = r.on_hit_effects.duplicate(true)
	on_took_damage_effects = r.on_took_damage_effects.duplicate(true)
	on_move_effects = r.on_move_effects.duplicate(true)
	tmp_attack_effects = []
	tmp_defense_effects = []
	tmp_on_hit_effects = []

func handle_card_event(event_name: String, actor: Char, target: Char):
	if effects[event_name]:
		for e in effects[event_name]:
			e.do.call_deferred(actor, target, self)
			await e.card_effect_finished
		EventBus.character_deck_updated.emit(actor)
		card_action_finished.emit()

func do_attack(actor: Char, defender: Char) -> void:
	do_effects(actor, defender, attack_effects)

func do_defend(actor: Char) -> void:
	actor.is_defending = true
	@warning_ignore("integer_division")
	add_bonus_defense((defense_decay + defense) / 2)
	do_effects(actor, actor, defense_effects)

func do_on_hit(attacker: Char, defender: Char) -> void:
	do_effects(defender, attacker, on_hit_effects)

func do_on_took_damage(actor: Char) -> void:
	do_effects(actor, actor, on_took_damage_effects)

func do_on_move_effects(actor: Char) -> void:
	do_effects(actor, actor, on_move_effects)

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
	card_action_finished.emit()

func clear_tmp_effects():
	tmp_attack_effects.clear()
	tmp_defense_effects.clear()
	tmp_on_hit_effects.clear()

func effect_is_changed():
	return is_changed or len(tmp_attack_effects + tmp_defense_effects + tmp_on_hit_effects) > 0

func get_all_effects():
	return attack_effects + defense_effects + on_hit_effects + on_took_damage_effects

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
		result += RichTextHelper.text_with_tooltip("On Move Effect: \n", "Trigger effects when you moved with a card effect from anywhere")
		for e in on_move_effects:
			result += '\t' + e.get_shortform(self)
			result += '\n'

	return result

#func get_description() -> String:
	#var desc := "[b]%s[/b]" % card_name
	#if effect_is_changed():
		#desc += "*"
#
	#if atk_range > 1:
		#desc += "\n+%d Range." % atk_range
	#
	#if exhausts:
		#desc += "\nExhaust."
	#
	#if is_innate:
		#desc += "\nInnate."
	#
	#if is_ethereal:
		#desc += "\nEthereal"
	#
	#for e in self.attack_effects:
		#if e.get_description() != "":
			#desc += '\n'
			#desc += e.get_description()
	#
	#for e in self.tmp_attack_effects:
		#if e.get_description() != "":
			#desc += '\n'
			#desc += '(' + e.get_description() + ')'
	#
	#if len(defense_effects + tmp_defense_effects) > 0:
		#desc += "\nOn Block: "
		#for e in defense_effects:
			#desc += '\n'
			#desc += e.get_description()
		#for e in tmp_defense_effects:
			#desc += '\n'
			#desc += '(' + e.get_description() + ')'
#
	#if len(on_hit_effects + tmp_on_hit_effects) > 0:
		#desc += "\nOn Hit: "
		#for e in on_hit_effects:
			#desc += '\n'
			#desc += e.get_description()
		#
		#for e in tmp_on_hit_effects:
			#desc += '\n'
			#desc += '(' + e.get_description() + ')'
	#
	#desc = desc.strip_edges()
	#return desc

func get_attack() -> String:
	return "%dx%d" % [attack, num_hits] if num_hits > 1 else str(attack)

func get_defense_string() -> String:
	return "∅" if is_dodge else str(get_defense())

func get_defense() -> int:
	return max(0, defense - defense_decay + bonus_defense)

func on_draw():
	reset_defense_decay()
	reset_bonus_defense()

func add_bonus_defense(val: int):
	bonus_defense += val

func reset_bonus_defense():
	bonus_defense = 0

func decay_defense():
	defense_decay = min(defense_decay + 1, defense)

func reset_defense_decay():
	defense_decay = 0
