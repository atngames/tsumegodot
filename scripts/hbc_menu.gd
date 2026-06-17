extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for c in get_children():
		c.pressed.connect(self._on_menu_button_pressed.bind(i))
		i += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed(tab_nb):
	%TCMainPanel.current_tab = tab_nb
