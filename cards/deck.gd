class_name Deck

var deck_owner: Char
var deck_list: Array[CardResource] = []
var innate_list: Array[CardResource] = []
var draw_pile: Array[CardInstance] = []
var discard_pile: Array[CardInstance] = []
var primary: CardInstance = null
var offhand: CardInstance = null

static var reshuffle_texture := preload("res://indicators/reshuffle_indicator.tres")

func _init(owner: Char, deck_list: Array[CardResource], innate_list: Array[CardResource]):
	deck_owner = owner
	
	owner.char_attacked.connect(on_attack)
	owner.char_defended.connect(on_defend)
	owner.char_is_hit.connect(on_hit)
	owner.char_took_damage.connect(on_took_damage)
	owner.char_move_effect.connect(on_move_effect)
	
	for card in deck_list:
		self.deck_list.push_back(card.duplicate(true))
	for card in innate_list:
		self.innate_list.push_back(card.duplicate(true))

# initialize should be called every time the player goes to another floor, removing
# statuses and any kind of card scaling
func initialize():
	draw_pile.clear()
	discard_pile.clear()
	primary = null
	offhand = null
	
	for card_resource in deck_list:
		var instance := CardInstance.new(card_resource)
		draw_pile.push_back(instance)
	
	for card_resource in innate_list:
		var instance := CardInstance.new(card_resource)
		instance.is_innate = true
		draw_pile.push_back(instance)
	reshuffle()

func add_to_deck_list(card_resource: CardResource):
	deck_list.push_back(card_resource)
	deck_owner.char_card_added.emit(card_resource)
	var instance := CardInstance.new(card_resource)
	insert_to_draw_randomly(instance)

func remove_from_deck_list(card_resource: CardResource):
	deck_list.erase(card_resource)
	initialize()

# draw if primary or offhand is null. This should be used at the start of each
# character's turn.
func draw_empty():
	if primary == null:
		var card : CardInstance = draw()
		primary = card
	if offhand == null:
		var card : CardInstance = draw()
		offhand = card
	EventBus.character_deck_updated.emit(deck_owner)

func draw() -> CardInstance:
	if draw_pile.is_empty():
		return null
	var c : CardInstance = draw_pile.pop_back()
	c.on_draw()
	return c

func discard_primary():
	if primary != null:
		primary.clear_tmp_effects()
		discard_pile.push_back(primary)
		
		deck_owner.spawn_discard_particle(primary.texture)
		
		primary = null
		EventBus.character_deck_updated.emit(deck_owner)

func exhaust_primary():
	if primary != null:
		primary = null
		EventBus.character_deck_updated.emit(deck_owner)

func dispose_primary():
	if primary == null:
		return
	
	if primary.exhausts:
		exhaust_primary()
	else:
		discard_primary()

func exhaust_offhand():
	if offhand != null:
		offhand = null
		EventBus.character_deck_updated.emit(deck_owner)

func discard_offhand():
	# remove temporary effects from the offhand
	if offhand != null:
		offhand.clear_tmp_effects()
		discard_pile.push_back(offhand)
		deck_owner.spawn_discard_particle(offhand.texture)
		offhand = null
		EventBus.character_deck_updated.emit(deck_owner)

func dispose_offhand():
	if offhand == null:
		return

	if offhand.exhausts:
		exhaust_offhand()
	else:
		discard_offhand()

func discard_top():
	if draw_pile.size() != 0:
		var discarded_card : CardInstance = draw_pile.pop_back()
		discard_pile.push_back(discarded_card)
		EventBus.character_deck_updated.emit(deck_owner)

func discard_all():
	discard_primary()
	discard_offhand()
	discard_pile.append_array(draw_pile)
	draw_pile.clear()
	EventBus.character_deck_updated.emit(deck_owner)

func reshuffle():
	# discard hand
	#discard_primary()
	#discard_offhand()
	# put all the cards in the discard pile onto the draw pile
	draw_pile.append_array(discard_pile)
	discard_pile.clear()

	var innate_cards: Array[CardInstance] = []
	var tmp : Array[CardInstance] = []
	for card in draw_pile:
		if card.is_innate:
			innate_cards.append(card)
		else:
			tmp.append(card)
	# try to put innate cards on the primary
	if !innate_cards.is_empty():
		# if primary not nothing
		if primary != null:
			tmp.push_back(primary)
		primary = innate_cards.pop_back()

	if !innate_cards.is_empty():
		# if primary not nothing
		if offhand != null:
			tmp.push_back(offhand)
		offhand = innate_cards.pop_back()
		
	tmp.shuffle()
	# add the rest of the innate cards at the top
	tmp.append_array(innate_cards)
	# tmp.append_array(innate_cards)
	
	draw_pile = tmp
	draw_empty()
	var reshuffle_indicator := load("res://indicators/reshuffle_indicator.tres")
	deck_owner.spawn_discard_particle(reshuffle_indicator)

func swap():
	var temp := offhand
	offhand = primary
	primary = temp
	EventBus.character_deck_updated.emit(deck_owner)

func add_to_draw(card: CardInstance):
	var rand_ind := randi() % (len(draw_pile) + 1)
	draw_pile.insert(rand_ind, card)
	EventBus.character_deck_updated.emit(deck_owner)

func add_to_top_draw(card: CardInstance):
	draw_pile.push_back(card)
	EventBus.character_deck_updated.emit(deck_owner)

func dredge():
	if discard_pile.is_empty():
		return
	# get the top of the discard pile
	var card : CardInstance = discard_pile.pop_back()
	
	add_to_draw(card)

func insert_to_draw_randomly(card: CardInstance):
	# insert in a random location
	var rand_ind := randi() % (len(draw_pile) + 1)
	draw_pile.insert(rand_ind, card)

func add_to_discard(card: CardInstance):
	discard_pile.push_back(card)

func exhaust_ethereal():
	if primary != null and primary.is_ethereal:
		exhaust_primary()
	if offhand != null and offhand.is_ethereal:
		exhaust_offhand()

func get_all_card_instances() -> Array[CardInstance]:
	var result: Array[CardInstance] = []
	if primary:
		result.push_back(primary)
	if offhand:
		result.push_back(offhand)
	result.append_array(draw_pile)
	result.append_array(discard_pile)
	return result

func find_card(card_name: String):
	var cards := get_all_card_instances()
	var ind := cards.find_custom(func(c:CardInstance): return c.card_name == card_name)
	if ind == -1:
		return null
	return cards[ind]

func index_card_discard(card_name: String) -> int:
	var cards := discard_pile
	var ind := cards.find_custom(func(c:CardInstance): return c.card_name == card_name)
	return ind

func index_card_draw(card_name: String) -> int:
	var cards := draw_pile
	var ind := cards.find_custom(func(c:CardInstance): return c.card_name == card_name)
	return ind

func pop_card(card_name: String):
	var ind := index_card_discard(card_name)
	if ind != -1:
		var card := discard_pile[ind]
		discard_pile.remove_at(ind)
		return card
	ind = index_card_draw(card_name)
	if ind != -1:
		var card := draw_pile[ind]
		draw_pile.remove_at(ind)
		return card
	return null

func on_attack(actor: Char, defender: Char):
	if actor.deck.primary != null:
		actor.deck.primary.do_attack(actor, defender)

func on_defend(actor: Char):
	if offhand != null:
		actor.deck.offhand.do_defend(actor)

func on_hit(actor: Char, attacker: Char):
	if offhand != null:
		offhand.do_on_hit(attacker, actor)

func on_took_damage(actor: Char):
	# all cards with on_took_damage use their effects
	for card in get_all_card_instances():
		card.do_on_took_damage(actor)

func on_move_effect():
	for card in get_all_card_instances():
		card.do_on_move_effects(deck_owner)
