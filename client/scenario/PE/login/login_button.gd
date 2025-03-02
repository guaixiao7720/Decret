extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if ENet.connectRelayServer(get_node("/root/Login/RelayGridContainer/LineEdit").text):
		pass
	else:
		$"/root/Login".add_child(Tools.newPromptWindow(Vector2(300, 200), "error", "connect_reloy_fail", "ok"))
