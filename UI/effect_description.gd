class_name EffectDescription
extends PanelContainer

func set_text(shortform: String, description: String) -> void:
	var desc := "%s\n%s" % [shortform, description]
	$DescriptionContainer.text = desc
