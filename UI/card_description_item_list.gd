extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_item_tooltip(0, "Damage dealt to the target(s) when attacking")
	set_item_tooltip(1, "Number of hits done when attacking")
	set_item_tooltip(2, "Range when attacking")
	set_item_tooltip(3, "Damage subtracted when attacked while this card is in the defense.")
