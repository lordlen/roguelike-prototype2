extends RichTextLabel

func _on_meta_hover_ended(meta: Variant) -> void:
	tooltip_text = ""


func _on_meta_hover_started(meta: Variant) -> void:
	tooltip_text = meta
