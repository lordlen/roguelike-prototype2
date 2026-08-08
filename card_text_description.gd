extends RichTextLabel

func _on_meta_hover_started(meta: Variant) -> void:
	tooltip_text = str(meta)

func _on_meta_hover_ended(meta: Variant) -> void:
	tooltip_text = ""
