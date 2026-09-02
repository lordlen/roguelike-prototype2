class_name AttackOnlyAction
extends Action

var attacker: Char
var defender: Char
func _init(attacker: Char, defender: Char):
	self.attacker = attacker
	self.defender = defender

func execute() -> bool:
	if !can_attack(attacker.grid_position, defender.grid_position, attacker.deck.primary)\
	and can_attack(attacker.grid_position, defender.grid_position, attacker.deck.offhand):
		attacker.swap()
	if can_attack(attacker.grid_position, defender.grid_position, attacker.deck.primary):
		var card := attacker.deck.primary
		attacker.char_attacked.emit(defender)
		await attacker.deck.primary.card_action_finished
		await attacker.get_tree().create_timer(0.5).timeout
		if !attacker.is_dead():
			await attacker.deck.dispose_primary()
			await attacker.deck.draw_empty()
		action_finished.emit(!card.is_instant)
		return !card.is_instant
	action_finished.emit(false)
	return false

func can_attack(start_pos: Vector2i, target_pos: Vector2i, card: CardInstance):
	var atk_range := 0 if card == null else card.atk_range
	var pf = Pathfinder.new()
	var dist = Pathfinder.chebychev_dist(attacker.grid_position, defender.grid_position)
	if dist <= atk_range:
		var path := pf.get_straight_path(start_pos, target_pos, Char.Traversal.GROUNDED)
		if len(path) - 1 >=  dist:
			return true
	return false
