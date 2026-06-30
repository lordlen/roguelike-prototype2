class_name CardInstance
extends RefCounted

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

var attack_effects: Array[CardEffect]
var defense_effects: Array[CardEffect]
var on_hit_effects: Array[CardEffect]

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
	
	attack_effects = r.attack_effects.duplicate()
	defense_effects = r.defense_effects.duplicate()
	on_hit_effects = r.on_hit_effects.duplicate()
	tmp_attack_effects = []
	tmp_defense_effects = []
	tmp_on_hit_effects = []

func do_attack(actor: Char, defender: Char, path: Array[Vector2i]) -> void:
	EventBus.notable_occurance.emit("%s attacks %s with %s" % [actor.character_name, defender.character_name, card_name])
	for e in attack_effects + tmp_attack_effects:
		e.do(actor, defender, self, path)
	actor.deck.dispose_primary()
	EventBus.character_deck_updated.emit(actor)

func do_defend(actor: Char) -> void:
	actor.is_defending = true
	# Add (def + decay) / 2, which is decay + (def - decay) / 2.
	# decay offsets the decay. (def - decay) / 2 rewards defending with less
	# decay.
	add_bonus_defense((defense_decay + defense) / 2)
	for e in defense_effects + tmp_defense_effects:
		e.do(actor, null, self, [])
	EventBus.character_deck_updated.emit(actor)

func do_on_hit(attacker: Char, defender: Char) -> void:
	if !defender.is_defending:
		# limit the decay to the defense
		defense_decay = min(defense_decay + 1, defense)
	for e in on_hit_effects + tmp_on_hit_effects:
		e.do(defender, attacker, self, [])

func clear_tmp_effects():
	tmp_attack_effects.clear()
	tmp_defense_effects.clear()
	tmp_on_hit_effects.clear()

func effect_is_changed():
	return is_changed or len(tmp_attack_effects + tmp_defense_effects + tmp_on_hit_effects) > 0

func get_description() -> String:
	var desc := "[b]%s[/b]" % card_name
	if effect_is_changed():
		desc += "*"

	if atk_range > 1:
		desc += "\n+%d Range." % atk_range
	
	if exhausts:
		desc += "\nExhaust."
	
	if is_innate:
		desc += "\nInnate."
	
	if is_ethereal:
		desc += "\nEthereal"
	
	for e in self.attack_effects:
		if e.get_description() != "":
			desc += '\n'
			desc += e.get_description()
	
	for e in self.tmp_attack_effects:
		if e.get_description() != "":
			desc += '\n'
			desc += '(' + e.get_description() + ')'
	
	if len(defense_effects + tmp_defense_effects) > 0:
		desc += "\nOn Defend: "
		for e in defense_effects:
			desc += '\n'
			desc += e.get_description()
		for e in tmp_defense_effects:
			desc += '\n'
			desc += '(' + e.get_description() + ')'

	if len(on_hit_effects + tmp_on_hit_effects) > 0:
		desc += "\nOn Hit: "
		for e in on_hit_effects:
			desc += '\n'
			desc += e.get_description()
		
		for e in tmp_on_hit_effects:
			desc += '\n'
			desc += '(' + e.get_description() + ')'
	
	desc = desc.strip_edges()
	return desc

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

func reset_defense_decay():
	defense_decay = 0
