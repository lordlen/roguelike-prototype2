class_name AttackOnlyAction
extends Action

var attacker: Char
var defender: Char
var path: Array[Vector2i]
func _init(attacker: Char, defender: Char):
	self.attacker = attacker
	self.defender = defender
	self.path = path

func execute() -> bool:
	if attacker.deck.primary == null:
		return false
	var pf = Pathfinder.new()
	var path = pf.find_path(attacker.traversal, attacker.grid_position, defender.grid_position, true)
	# path includes attacker's location. a distance of 1 will have 2 elements in the path
	if attacker.deck.primary != null and len(path) - 1 <= attacker.deck.primary.atk_range:
		var is_swift = attacker.deck.primary.is_swift
		attacker.deck.primary.do_attack(attacker, defender, path)
		# don't pass the turn if it's swift
		EventBus.character_deck_updated.emit(attacker)
		EventBus.character_deck_updated.emit(defender)
		return !is_swift
	else:
		return false
