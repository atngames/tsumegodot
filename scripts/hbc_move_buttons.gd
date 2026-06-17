extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Decks.cards_nb_changed.connect(self._on_deck_card_nb_changed)
	_on_deck_card_nb_changed()
	$B1.pressed.connect(self._on_b1_pressed)
	$B2.pressed.connect(self._on_b2_pressed)
	$B3.pressed.connect(self._on_b3_pressed)
	$BMid.pressed.connect(self._on_bmid_pressed)
	$BTwoThirds.pressed.connect(self._on_btwo_thirds_pressed)
	$BEnd.pressed.connect(self._on_bend_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_deck_card_nb_changed():
	visible = Decks.cards_nb > 1
	%LMoveTo.visible = Decks.cards_nb > 1
	$B1.visible = $B1.text.to_int() < Decks.cards_nb
	$BMid.visible = $B1.text.to_int() < Decks.cards_nb / 2
	$B2.visible = $B2.text.to_int() < Decks.cards_nb / 2
	$B3.visible = $B3.text.to_int() < Decks.cards_nb / 2
	$BTwoThirds.visible = $B3.text.to_int() < Decks.cards_nb

func _on_b1_pressed():
	Decks.move_first_card_to($B1.text.to_int()+1)

func _on_b2_pressed():
	Decks.move_first_card_to($B2.text.to_int()+1)

func _on_b3_pressed():
	Decks.move_first_card_to($B3.text.to_int()+1)

func _on_bmid_pressed():
	Decks.move_first_card_to(Decks.cards_nb / 2)

func _on_btwo_thirds_pressed():
	Decks.move_first_card_to(Decks.cards_nb * 2 / 3)

func _on_bend_pressed():
	Decks.move_first_card_to(Decks.cards_nb)
