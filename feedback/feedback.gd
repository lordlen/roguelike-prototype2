extends Panel

@onready var http_request: HTTPRequest = $HTTPRequest
const DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/1550977238940254282/hDl7Vs4UlHMbt9Iq9fNpyyFhOaxblIA1TuK_v_jm5DTsWPbfyDLG8mzueh1tYLGOhbJA"

signal feedback_success()
signal feedback_fail()

func send_feedback(text):
	var payload := {
		"content": text
	}
	var json_payload := JSON.stringify(payload)
	var headers = ["Content-Type: application/json"]
	var error := http_request.request(DISCORD_WEBHOOK_URL, headers, HTTPClient.METHOD_POST, json_payload)
	if error == OK:
		feedback_success.emit()
	else:
		feedback_fail.emit()

func _on_send_button_pressed() -> void:
	send_feedback($Feedback.text)
	$Feedback.text = ""
	$SendButton.disabled = true
	hide()

func _on_cancel_button_pressed() -> void:
	hide()

func _on_feedback_text_changed() -> void:
	$SendButton.disabled = len($Feedback.text) == 0
