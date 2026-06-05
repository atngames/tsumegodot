extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func contenu_repertoire(chemin):
	var repertoire = DirAccess.open(chemin)
	if repertoire:
		repertoire.list_dir_begin()
		var nom_fichier = repertoire.get_next()
		while nom_fichier!= "":
			if repertoire.current_is_dir():
				print("Répertoire trouvé : " + nom_fichier)
			else:
				print("Fichier trouvé : " + nom_fichier)
			nom_fichier = repertoire.get_next()
	else:
		print("Une erreur s'est produite lors de l'accès au chemin.")
		
		
func _on_button_pressed() -> void:
		# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	#var file = FileAccess.open("user://201-basic-go-problems.zip", FileAccess.WRITE) 
#
	#http_request.set_download_file("user://200-basic-go-problems.zip")
	#var error = http_request.request("https://github.com/atngames/tsumegodot/raw/refs/heads/main/problems/tsumego/200-basic-go-problems.zip")
	#if error != OK:
		#push_error("An error occurred in the HTTP request.")
	#
	
	contenu_repertoire("https://github.com/atngames/tsumegodot/raw/refs/heads/main/problems/tsumego")
	#
	#var reader = ZIPReader.new()
	#var err = reader.open("oooooooooooo")
	#if err != OK :
		#print("error")
		#return
		#
	## Destination directory for the extracted files (this folder must exist before extraction).
	## Not all ZIP archives put everything in a single root folder,
	## which means several files/folders may be created in `root_dir` after extraction.
	#var root_dir = DirAccess.open("user://")
#
	#var files = reader.get_files()
	#for file_path in files:
		## If the current entry is a directory.
		#if file_path.ends_with("/"):
			#root_dir.make_dir_recursive(file_path)
			#continue
#
		## Write file contents, creating folders automatically when needed.
		## Not all ZIP archives are strictly ordered, so we need to do this in case
		## the file entry comes before the folder entry.
		#root_dir.make_dir_recursive(root_dir.get_current_dir().path_join(file_path).get_base_dir())
		#var file = FileAccess.open(root_dir.get_current_dir().path_join(file_path), FileAccess.WRITE)
		#var buffer = reader.read_file(file_path)
		#file.store_buffer(buffer)

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
