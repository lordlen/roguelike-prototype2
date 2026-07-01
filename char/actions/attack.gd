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
	if await AttackOnlyAction.new(attacker, defender).execute():
		action_finished.emit()
		return true
	# if defender cannot be reached, just walk to the target.
	var result := await GoCloserAction.new(attacker).execute()
	action_finished.emit()
	return result
