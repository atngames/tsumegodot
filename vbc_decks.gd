extends VBoxContainer


var pack := "tsumegos"
var http_request := HTTPRequest.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request_decks(pack)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func request_decks(pack) :
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	http_request.set_download_file("user://%s_decks.txt" % pack)
	var error = http_request.request("https://raw.githubusercontent.com/atngames/tsumegodot/main/problems/%s/.decks.txt" % pack)
	if error != OK:
		push_error("An error occurred in the pack HTTP request.")
		return


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Pack couldn't be downloaded. Try a different pack name.")
		return
	
	# should remove the request
	# Or move the request as a param
	
	# TODO here
	# For each line of the pack file, create a Node in the VBContainer
	var file = FileAccess.open("user://%s_decks.txt" % pack, FileAccess.READ)
	var content = file.get_as_text()
	print("--- pack : %s ---" % pack)
	print(content.split("\n", false))
	#print(content)
	#return content
