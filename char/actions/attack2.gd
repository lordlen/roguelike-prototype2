class_name AttackAction2
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
	# path includes attacker's location. a distance of 1 will have 2 elements in the path
	if attacker.deck.primary != null and\
	Pathfinder.chebychev_dist(attacker.grid_position, defender.grid_position) <= attacker.deck.primary.atk_range\
	and len(pf.find_path(attacker.traversal, attacker.grid_position, defender.grid_position, true)) <= attacker.deck.primary.atk_range:
		attacker.deck.primary.do_attack(attacker, defender, path)
		return true
	else:
		# if defender cannot be reached, just walk to the target.
		return GoCloserAction.new(attacker).execute()
