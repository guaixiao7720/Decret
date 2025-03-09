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
	var text: String = $"InputVBoxContainer/InputHBoxContainer/TextEdit".text
	
	if SensitiveWords.IsSensitive(text):
		text = "***"
	
	var crypto = Crypto.new()
	
	var key: CryptoKey = CryptoKey.new()
	key.load_from_string(GlobalValue.session, true)
	
	var aesKey: PackedByteArray = Tools.generateKey()
	
	var encryptAesKey: PackedByteArray = crypto.encrypt(key, aesKey)
	
	var cipherText: PackedByteArray = Tools.aesEncrypt(aesKey, text.to_utf8_buffer())
	
	if not GlobalValue.privateMessage.has(GlobalValue.session):
		GlobalValue.privateMessage[GlobalValue.session] = []
	
	GlobalValue.privateMessage[GlobalValue.session].append({
		"sender" : GlobalValue.publicKey,
		"cipherText" : text,
		"type" : ENet.MESSAGE_TYPE.TEXT,
		"aesKey" : encryptAesKey,
	})
	
	get_node("/root/Menu/ChatControl").flush()
	
	ENet.sendMessage.rpc_id(id, cipherText, encryptAesKey, len(text.to_utf8_buffer()), GlobalValue.publicKey)
	
	$"InputVBoxContainer/InputHBoxContainer/TextEdit".text = ""

func _on_text_edit_text_changed() -> void:
	if $"InputVBoxContainer/InputHBoxContainer/TextEdit".text == "":
		$"InputVBoxContainer/InputHBoxContainer/SendButton".disabled = true
	else:
		$"InputVBoxContainer/InputHBoxContainer/SendButton".disabled = false
