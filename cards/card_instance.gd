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
	
	attack_effects = r.attack_effects
	defense_effects = r.defense_effects
	on_hit_effects = r.on_hit_effects
	tmp_attack_effects = []
	tmp_defense_effects = []
	tmp_on_hit_effects = []

func do_attack(attacker: Char, defender: Char, path: Array[Vector2i]) -> void:
	EventBus.notable_occurance.emit("%s attacks %s with %s" % [attacker.character_name, defender.character_name, card_name])
	for e in attack_effects + tmp_attack_effects:
		e.do(attacker, defender, self, path)
	attacker.deck.dispose_primary()

func do_defend(defender: Char) -> void:
	defender.bonus_defense += defense
	for e in defense_effects + tmp_defense_effects:
		e.do(null, defender, self, [])
	defender.deck.dispose_primary()

func do_on_hit(attacker: Char, defender: Char) -> void:
	for e in on_hit_effects:
		e.do(attacker, defender, self, [])

func get_description() -> String:
	var desc := "[b]%s[/b]" % card_name
	
	if atk_range > 1:
		desc += "\n+1 Range."
	
	if exhausts:
		desc += "\nExhaust."
	
	if is_innate:
		desc += "\nInnate."
	
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
			desc += e.get_description()
			desc += '\n'
		for e in tmp_defense_effects:
			desc += '(' + e.get_description() + ')'
			desc += '\n'

	if len(on_hit_effects) > 0:
		desc += "On Hit: "
		for e in on_hit_effects:
			desc += e.get_description()
			desc += '\n'
		
		for e in tmp_on_hit_effects:
			desc += '(' + e.get_description() + ')'
			desc += '\n'
	
	desc = desc.strip_edges()
	
	if desc == "":
		return "No effects"
	return desc

func get_attack() -> String:
	return "%dx%d" % [attack, num_hits] if num_hits > 1 else str(attack)

func get_defense() -> String:
	return "∅" if is_dodge else str(defense)
