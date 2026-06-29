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
	if AttackOnlyAction.new(attacker, defender).execute():
		return true
	# if defender cannot be reached, just walk to the target.
	return GoCloserAction.new(attacker).execute()
