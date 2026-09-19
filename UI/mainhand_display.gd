class_name MainhandDisplay
extends CardDisplay

func set_card_data(card: CardInstance) -> void:
	self.card = card
	if card != null:
		set_color_by_rarity(card.rarity)
		if card.texture != null:
			$CardThumbnail.texture = card.texture
			$AltText.text = ""
		else:
			$CardThumbnail.texture = null
			$AltText.text = card.card_name
		self.modulate.a = 1
		$AttackLabel.text = card.get_attack()
		$RangeLabel.text = str(card.atk_range)
	else:
		self.modulate.a = 0
		$AttackLabel.text = ""
		$RangeLabel.text = ""
