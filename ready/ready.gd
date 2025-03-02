extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var osName = OS.get_name()
	
	GlobalValue.osName = osName
	
	if OS.has_feature("dedicated_server"):
		GlobalValue.isServer = true
		get_tree().change_scene_to_file("res://server/server.tscn")
	else:
		match GlobalValue.osName:
			"Windows", "macOS":
				get_tree().change_scene_to_file("res://client/scenario/PE/login/login.tscn")
			"Android", "iOS":
				get_tree().change_scene_to_file("res://client/scenario/PE/login/login.tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
