extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://friends/"):
		DirAccess.make_dir_absolute("user://friends/")
	
	var friendDir = DirAccess.open("user://friends/")
	if friendDir:
		friendDir.list_dir_begin()
		var file_name = friendDir.get_next()
		while file_name != "":
			if friendDir.current_is_dir():
				pass
			else:
				
				var friendJsonStr: String = FileAccess.get_file_as_string("user://friends/" + file_name)
				var friendDict: Dictionary = JSON.parse_string(friendJsonStr)
				var publicKey: String = friendDict["publicKey"]
				#var lastChatDay = friendDict["public"]
				
				var friendsTab = load("res://client/scenario/PE/menu/friendsTab.tscn").instantiate()
				if friendDict["remark"] == "":
					friendsTab.friendName = publicKey
				else:
					friendsTab.friendName = friendDict["remark"]
				
					
				friendsTab.friendKey = publicKey
				friendsTab.name = publicKey.erase(0, 71).left(30).replace("\n", "").replace("\\", "").replace("/", "")
				add_child(friendsTab)
				friendsTab.flush()
					
			file_name = friendDir.get_next()
	else:
		print("尝试访问路径时出错。")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
