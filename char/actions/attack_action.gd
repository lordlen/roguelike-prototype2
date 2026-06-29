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
	var dist = Pathfinder.chebychev_dist(attacker.grid_position, defender.grid_position)
	# path includes attacker's location. a distance of 1 will have 2 elements in the path
	if attacker.deck.primary != null and\
	dist <= attacker.deck.primary.atk_range:
		var path := pf.get_straight_path(attacker.grid_position, defender.grid_position, attacker.traversal)
		
		if len(path) - 1 >=  dist:
			attacker.deck.primary.do_attack(attacker, defender, path)
			return true
	return false
