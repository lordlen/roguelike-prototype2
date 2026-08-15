extends PanelContainer

func _ready() -> void:
	EventBus.item_description_requested.connect(set_item_description)
	EventBus.item_description_hidden.connect(hide)

func set_item_description(text: String):
	$DescriptionText.text = text
	visible = true
