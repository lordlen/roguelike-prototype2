class_name CardRewardGenerator
extends Resource

@export var CommonPool: Array[CardResource]

func generate_card_rewards(num_options: int) -> Array[CardResource]:
	var common_pool_indices := []

	for i in range(len(CommonPool)):
		common_pool_indices.push_back(i)

	common_pool_indices.shuffle()

	var ret : Array[CardResource] = []
	for i in num_options:
		if common_pool_indices.is_empty():
			break
		var index : int = common_pool_indices.pop_back()
		ret.push_back(CommonPool[index].duplicate(true))

	return ret
