extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flush() -> void:
	for child in $"MessageScrollContainer/MessageVBoxContainer".get_children():
		child.queue_free()
		
	var name1 = GlobalValue.session
	name1 = name1.erase(0, 71).left(703).replace("\n", "")
	
	if len(GlobalValue.session) > 20:
		name1 = name1.left(20)
		name1 += "..."
	
	$"nameLabel".text = name1
		
	if not GlobalValue.privateMessage.has(GlobalValue.session):
		GlobalValue.privateMessage[GlobalValue.session] = []
	
	for messageDict: Dictionary in GlobalValue.privateMessage[GlobalValue.session]:
		if messageDict["sender"] == GlobalValue.publicKey:
			var text: String = messageDict["cipherText"]
			var messageTab = load("res://client/scenario/PE/menu/message.tscn").instantiate()
			$"MessageScrollContainer/MessageVBoxContainer".add_child(messageTab)
			messageTab.setup(messageDict["sender"], text)

		
		else:
			var cipherText: PackedByteArray = messageDict["cipherText"]
			
			var crypto = Crypto.new()
			var text: String
			
			text = crypto.decrypt(GlobalValue.privateKey, cipherText).get_string_from_utf8()
			
			var messageTab = load("res://client/scenario/PE/menu/message.tscn").instantiate()
			$"MessageScrollContainer/MessageVBoxContainer".add_child(messageTab)
			messageTab.setup(messageDict["sender"], text)
	
	$"MessageScrollContainer".scroll_to_bottom()
	

func _on_back_button_pressed() -> void:
	GlobalValue.session = ""
	visible = false
	$"../ContactListControl".visible = true
