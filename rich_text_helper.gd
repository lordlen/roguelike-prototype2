class_name CardDescriptionHelper

static func text_with_tooltip(text: String, tooltip: String):
	return "[url=%s]%s[/url]" % [tooltip, text]

static func orange_text(text: String) -> String:
	return "[color=orange]%s[/color]" % text
