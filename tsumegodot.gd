extends Control


var packs : Dictionary
var decks : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	pass
		## Create an HTTP request node and connect its completion signal.
	#var http_request = HTTPRequest.new()
	#add_child(http_request)
	#http_request.request_completed.connect(self._http_request_completed)
#
	##var file = FileAccess.open("user://201-basic-go-problems.zip", FileAccess.WRITE)
##
	#http_request.set_download_file("user://tsumegos_decks.txt")
	#var error = http_request.request("https://raw.githubusercontent.com/atngames/tsumegodot/main/problems/tsumegos/.decks.txt")
	#if error != OK:
		#push_error("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
