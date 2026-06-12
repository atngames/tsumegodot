extends TextureButton


var recto = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(self._on_visibility_changed)
	pressed.connect(self._on_click)
	Decks.deck_changed.connect(self._on_deck_changed)
	_on_visibility_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visibility_changed():
	if Decks.first_card == null :
		texture_normal = null
		return

	if %Study.visible:
		texture_normal = load("user://packs/%s/%s.svg" % [Decks.first_card.pack, Decks.first_card.recto])
		recto = true


func _on_deck_changed():
	Decks.save_deck()
	_on_visibility_changed()


func _on_click():
	if Decks.first_card == null : return

	if recto:
		texture_normal = load("user://packs/%s/%s.svg" % [Decks.first_card.pack, Decks.first_card.verso])
		recto = false
	else :
		texture_normal = load("user://packs/%s/%s.svg" % [Decks.first_card.pack, Decks.first_card.recto])
		recto = true


	#Decks.move_first_card_to(-1)
	#if FileAccess.file_exists("user://packs/%s/%s.svg" % [Decks.first_card.pack, Decks.first_card.recto]):
		#texture_normal = load("user://packs/%s/%s.svg" % [Decks.first_card.pack, Decks.first_card.recto])
	#else:
		#texture_normal = load("res://%s" % "icon.svg")
