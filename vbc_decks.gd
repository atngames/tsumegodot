extends VBoxContainer


var pack := "tsumegos"
var http_request := HTTPRequest.new()

var icon_non_fav = preload("res://icons/NonFavorite.svg")
var icon_dl = preload("res://icons/lets-icons--import.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	request_decks(pack)
	visibility_changed.connect(self._on_visibility_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func request_decks(pack) :
	http_request.set_download_file("user://%s_decks.txt" % pack)
	var error = http_request.request("https://raw.githubusercontent.com/atngames/tsumegodot/main/problems/%s/.decks.txt" % pack)
	if error != OK:
		push_error("An error occurred in the pack HTTP request.")
		return


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Pack list couldn't be downloaded. Is there a network issue ?")
	
	# For each line of the pack file, create a Node in the VBContainer
	# Clean the name
	var file = FileAccess.open("user://%s_decks.txt" % pack, FileAccess.READ)
	var content = file.get_as_text()
	
	# We can do better than removing everything
	for c in get_children():
		if c is HBoxContainer:
			c.queue_free()
		
	for line in content.split("\n", false) :
		var line_content = line.split(",")
		
		var hbc = HBoxContainer.new()
		add_child(hbc)
		hbc.add_theme_constant_override("separation", 16)
		hbc.set_h_size_flags(hbc.SIZE_EXPAND_FILL)
		
		var user_dir = DirAccess.open("user://")
		var checkbox_or_download
		if user_dir.file_exists(line_content[2]):
			checkbox_or_download = CheckBox.new()
		else:
			checkbox_or_download = TextureButton.new()
			checkbox_or_download.stretch_mode = checkbox_or_download.STRETCH_KEEP_ASPECT_CENTERED
			checkbox_or_download.texture_normal = icon_dl
		hbc.add_child(checkbox_or_download)
		
		var button_pack = Button.new()
		hbc.add_child(button_pack)
		button_pack.set_h_size_flags(button_pack.SIZE_EXPAND_FILL)
		button_pack.text = "%s" % line_content[0]
		
		var label_rank = Label.new()
		hbc.add_child(label_rank)
		label_rank.text = "(%s)" % line_content[1]
		
		var button_fav := TextureButton.new()
		hbc.add_child(button_fav)
		button_fav.stretch_mode = button_fav.STRETCH_KEEP_ASPECT_CENTERED
		button_fav.texture_normal = icon_non_fav



	#print(content)
	#return content
	
	#notification(NOTIFICATION_RESIZED)


func _on_visibility_changed():
	if %Packs.visible:
		request_decks(pack)
