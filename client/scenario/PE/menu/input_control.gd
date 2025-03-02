extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_send_button_pressed() -> void:	
	ENet.getRpcId.rpc_id(GlobalValue.serverRpcId, GlobalValue.session)
	

func send(id: int) -> void:
	var text: String = $"TextEdit".text
	var crypto = Crypto.new()
	
	var key: CryptoKey = CryptoKey.new()
	key.load_from_string(GlobalValue.session, true)
	
	var cipherText: PackedByteArray = crypto.encrypt(key, text.to_utf8_buffer())
	
	if not GlobalValue.privateMessage.has(GlobalValue.session):
		GlobalValue.privateMessage[GlobalValue.session] = []
	
	GlobalValue.privateMessage[GlobalValue.session].append({
		"sender" : GlobalValue.publicKey,
		"cipherText" : text,
	})
	
	get_node("/root/Menu/ChatControl").flush()
	
	ENet.sendMessage.rpc_id(id, cipherText, GlobalValue.publicKey)
	
	$"TextEdit".text = ""

func _on_text_edit_text_changed() -> void:
	if $"TextEdit".text == "":
		$"SendButton".disabled = true
	else:
		$"SendButton".disabled = false
