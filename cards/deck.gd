class_name Deck

var deck_list: Array[CardResource] = []
var draw_pile: Array[CardInstance] = []
var discard_pile: Array[CardInstance] = []
var primary: CardInstance = null
var offhand: CardInstance = null

func _init(deck_list: Array[CardResource]):
	for card in deck_list:
		self.deck_list.push_back(card)

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
	
	reshuffle()

func add_to_deck_list(card_resource: CardResource):
	deck_list.push_back(card_resource)
	var instance := CardInstance.new(card_resource)
	insert_to_draw_randomly(instance)

# draw if primary or offhand is null. This should be used at the start of each
# character's turn.
func draw_empty():
	if primary == null:
		var card : CardInstance = draw_pile.pop_back()
		primary = card
	if offhand == null:
		var card : CardInstance = draw_pile.pop_back()
		offhand = card

func discard_primary():
	if primary != null:
		discard_pile.push_back(primary)
		primary = null

func exhaust_primary():
	if primary != null:
		primary = null

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

func discard_offhand():
	if offhand != null:
		discard_pile.push_back(offhand)
		offhand = null

func discard_top():
	if draw_pile.size() != 0:
		var discarded_card : CardInstance = draw_pile.pop_back()
		discard_pile.push_back(discarded_card)

func reshuffle():
	# discard hand
	discard_primary()
	discard_offhand()
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
	tmp.shuffle()
	tmp.append_array(innate_cards)
	
	draw_pile = tmp
	draw_empty()

func swap():
	var temp := offhand
	offhand = primary
	primary = temp

func add_to_draw(card: CardInstance):
	draw_pile.push_back(card)

func dredge():
	if discard_pile.is_empty():
		return
	# get the top of the discard pile
	var card : CardInstance = discard_pile.pop_back()
	
	# insert in a random location
	var rand_ind := randi() % (len(draw_pile) + 1)
	draw_pile.insert(rand_ind, card)

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
