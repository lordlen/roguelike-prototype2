class_name AttackAction
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
		attacker.deck.primary.do_attack(attacker, defender, path)
		return true
	else:
		# if defender cannot be reached, just walk to the target.
		if len(path) < 2:
			return false
		else:
			return Walk.new(attacker, path[1]).execute()
