extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var keyName: String = $"../TextEdit".text
	
	var publicKey: String = keyName
	
	if not publicKey.ends_with("\n"):
		publicKey += "\n"
	
	keyName = keyName.erase(0, 71).left(30).replace("\n", "").replace("\\", "").replace("/", "")
	
	if not FileAccess.file_exists("user://friends/" + keyName + ".json"):
		var friendDict: Dictionary = {
			"publicKey" : publicKey,
			"remark" : "",
		}
		var file = FileAccess.open("user://friends/" + keyName + ".json", FileAccess.WRITE)
		file.store_string(JSON.stringify(friendDict, "\t"))
		
		var friendsTab = load("res://client/scenario/PE/menu/friendsTab.tscn").instantiate()
		friendsTab.friendName = publicKey
		friendsTab.friendKey = publicKey
		friendsTab.name = keyName
		
		get_node("/root/Menu/ContactListControl/ContactList").add_child(friendsTab)
		friendsTab.flush()
