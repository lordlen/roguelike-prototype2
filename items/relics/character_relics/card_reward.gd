extends Relic

func on_self_pickup(owner: Char):
	EventBus.card_reward_cheated.emit()
