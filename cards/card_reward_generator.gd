class_name CardRewardGenerator
extends Resource

@export var card_resources: Array[CardResource]
@export var common_weight: int = 55
@export var uncommon_weight: int = 35
@export var rare_weight: int = 10

var rng = RandomNumberGenerator.new()
# Array[Array[CardResource]]
var grouped_cards: Array = [[],[],[]]
var common: Array[CardResource]
var uncommon: Array[CardResource]
var rare: Array[CardResource]

var is_instantiated: bool = false

func instantiate():
	is_instantiated = true
	for c in card_resources:
		match c.rarity:
			CardResource.Rarity.COMMON:
				grouped_cards[0].push_back(c)
			CardResource.Rarity.UNCOMMON:
				grouped_cards[1].push_back(c)
			CardResource.Rarity.RARE:
				grouped_cards[2].push_back(c)
			_:
				pass
	#print(len(grouped_cards[0]))
	#print(len(grouped_cards[1]))
	#print(len(grouped_cards[2]))
	#
	#for card in grouped_cards[0]:
		#print(card.name)

func generate_rarity() -> CardResource.Rarity:
	var weights := [common_weight, uncommon_weight, rare_weight]
	return [
		CardResource.Rarity.COMMON,
		CardResource.Rarity.UNCOMMON,
		CardResource.Rarity.RARE,
	][rng.rand_weighted(weights)]

func generate_rarity_cards(counts: Array[int]) -> Array[CardResource]:
	if !is_instantiated:
		instantiate()
	var ret : Array[CardResource]
	
	for i in range(len(grouped_cards)):
		# random ind list
		var inds := range(len(grouped_cards[i]))
		inds.shuffle()
		for ind in inds.slice(0, counts[i]):
			ret.push_back(grouped_cards[i][ind])
	
	return ret

func generate_card_rewards(num_options: int) -> Array[CardResource]:
	if !is_instantiated:
		instantiate()
	var ret : Array[CardResource]
	var counts := [0, 0, 0]
	var weights := [common_weight, uncommon_weight, rare_weight]
	for _i in num_options:
		counts[rng.rand_weighted(weights)] += 1
	
	for i in range(len(grouped_cards)):
		# random ind list
		var inds := range(len(grouped_cards[i]))
		inds.shuffle()
		
		for ind in inds.slice(0, counts[i]):
			ret.push_back(grouped_cards[i][ind])
	
	return ret
			
	
	#var common_pool_indices := range(len(card_resources))
	#common_pool_indices.shuffle()
#
	#var ret : Array[CardResource] = []
	#for i in num_options:
		#if common_pool_indices.is_empty():
			#break
		#var index : int = common_pool_indices.pop_back()
		#ret.push_back(card_resources[index].duplicate(true))
#
	#return ret
