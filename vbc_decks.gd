extends VBoxContainer


var pack := "tsumegos"
var http_request := HTTPRequest.new()

var icon_non_fav = preload("res://icons/NonFavorite.svg")
var icon_dl = preload("res://icons/lets-icons--import.svg")

var user_dir = DirAccess.open("user://")
var packs_dir = DirAccess.open("user://packs/")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	visibility_changed.connect(self._on_visibility_changed)
	if not user_dir.file_exists("packs.txt"):
		var file = FileAccess.open("packs.txt", FileAccess.WRITE)
		file.close()
	if not user_dir.dir_exists("packs/"):
		user_dir.make_dir("packs/")
	request_packs()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func request_packs() :
	http_request.set_download_file("user://packs.txt")
	var error = http_request.request("https://raw.githubusercontent.com/atngames/tsumegodot/main/packs/.packs.txt")
	if error != OK:
		push_error("An error occurred in the pack HTTP request.")
		return


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Pack list couldn't be downloaded. Is there a network issue ?")
	
	# For each line of the pack file, create a Node in the VBContainer
	# Clean the name
	var file = FileAccess.open("user://packs.txt", FileAccess.READ)
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
		
		var checkbox_or_download
		if user_dir.file_exists(line_content[2]):
			checkbox_or_download = CheckBox.new()
		else:
			checkbox_or_download = TextureButton.new()
			checkbox_or_download.stretch_mode = checkbox_or_download.STRETCH_KEEP_ASPECT_CENTERED
			checkbox_or_download.texture_normal = icon_dl
			checkbox_or_download.pressed.connect(self._on_dl_pressed.bind(line_content[2]))
			checkbox_or_download.mouse_entered.connect(self._on_button_mouse_hover.bind(checkbox_or_download))
			checkbox_or_download.mouse_exited.connect(self._on_button_mouse_unhover.bind(checkbox_or_download))
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

func _on_button_mouse_hover(button: TextureButton) -> void:
	button.modulate = Color.DIM_GRAY
	
func _on_button_mouse_unhover(button: TextureButton) -> void:
	button.modulate = Color.WHITE
	
func _on_visibility_changed():
	if %Packs.visible:
		request_packs()


func _on_dl_pressed(file):
	print("Downloading " + file)
	# download zip file
	var zip_request := HTTPRequest.new()
	add_child(zip_request)
	zip_request.request_completed.connect(self._zip_request_completed.bind(file, zip_request))
	zip_request.set_download_file("user://packs/%s" % file)
	var error = zip_request.request("https://raw.githubusercontent.com/atngames/tsumegodot/main/packs/%s" % file)
	if error != OK:
		push_error("An error occurred in the zip %s HTTP request." % file)


func _zip_request_completed(result, response_code, headers, body, file, zip_request):
	extract_zip_file(file)
	zip_request.queue_free()
	packs_dir.remove(file)

	
func extract_zip_file(zip_name):
	var reader = ZIPReader.new()
	var err = reader.open("user://packs/%s" % zip_name)
	if err != OK :
		print("error while extracting zip %s" % zip_name)
		return
		
	# Destination directory for the extracted files (this folder must exist before extraction).
	# Not all ZIP archives put everything in a single root folder,
	# which means several files/folders may be created in `root_dir` after extraction.
	var files = reader.get_files()
	for file_path in files:
		# If the current entry is a directory.
		if file_path.ends_with("/"):
			packs_dir.make_dir_recursive(file_path)
			continue

		# Write file contents, creating folders automatically when needed.
		# Not all ZIP archives are strictly ordered, so we need to do this in case
		# the file entry comes before the folder entry.
		packs_dir.make_dir_recursive(packs_dir.get_current_dir().path_join(file_path).get_base_dir())
		var file = FileAccess.open(packs_dir.get_current_dir().path_join(file_path), FileAccess.WRITE)
		var buffer = reader.read_file(file_path)
		file.store_buffer(buffer)
