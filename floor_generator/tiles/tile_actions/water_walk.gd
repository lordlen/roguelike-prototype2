class_name WaterWalk
extends ItemAction

func use(owner: Char, pos: Vector2i) -> bool:
	if owner.traversal == Char.Traversal.AQUATIC:
			return true
	if !owner.deck.draw_pile.is_empty():
		owner.deck.discard_top()
	return true
