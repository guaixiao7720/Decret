extends AcceptDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	ENet.multiplayer.server_disconnected.connect(_on_disconnect_server)
	
func _on_disconnect_server():
	visible = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_canceled() -> void:
	GlobalValue.session = ""
	get_tree().change_scene_to_file("res://client/scenario/PE/login/login.tscn")
