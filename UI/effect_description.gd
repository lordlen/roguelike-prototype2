class_name EffectDescription
extends PanelContainer

func set_text(number_placeholder: String, name: String, description: String) -> void:
	if number_placeholder != "":
		number_placeholder += " "
	var desc := "%s[color=orange]%s[/color]\n%s" % [number_placeholder, name, description]
	$DescriptionContainer.text = desc
