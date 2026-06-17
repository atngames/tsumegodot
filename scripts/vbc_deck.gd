extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(self._on_visibility_changed)
	if not DirAccess.dir_exists_absolute("user://packs/"):
		DirAccess.make_dir_absolute("user://packs/")
	if not FileAccess.file_exists("user://packs.txt"):
		var file = FileAccess.open("user://packs.txt", FileAccess.WRITE)
		file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func rebuild_deck():
	for c in get_children():
		if c is HBoxContainer:
			c.queue_free()

	var file = FileAccess.open("user://packs.txt", FileAccess.READ)
	var content = file.get_as_text()

	for line in content.split("\n", false) :
		var line_content = line.split(",")

		if DirAccess.dir_exists_absolute("user://packs/%s" % line_content[2].get_basename()):
			var hbc = HBoxContainer.new()
			add_child(hbc)
			hbc.add_theme_constant_override("separation", 16)
			hbc.set_h_size_flags(hbc.SIZE_EXPAND_FILL)

			var checkbox = CheckBox.new()
			hbc.add_child(checkbox)
			checkbox.pressed.connect(self._on_checkbox_pressed.bind(line_content[2], checkbox))
			if Decks.packs.has(line_content[2].get_basename()) :
				checkbox.button_pressed = true

			var b_title = Button.new()
			hbc.add_child(b_title)
			b_title.text = line_content[0]
			b_title.set_h_size_flags(b_title.SIZE_EXPAND_FILL)
			b_title.pressed.connect(self._on_pack_pressed.bind(line_content[2], checkbox))


func _on_pack_pressed(zipfile, checkbox: CheckBox):
	checkbox.button_pressed = not checkbox.button_pressed
	checkbox.pressed.emit()


func _on_checkbox_pressed(zipfile, checkbox: CheckBox):
	var pack = zipfile.get_basename()
	if checkbox.button_pressed:
		Decks.add_pack(pack)
	else:
		Decks.remove_pack(pack)


func _on_visibility_changed():
	if %Deck.visible:
		rebuild_deck()
