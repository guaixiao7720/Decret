extends Control

var getImage

var image: Image

func _ready() -> void:
	visible = false
	if OS.get_name() == "Android":
		getImage = Engine.get_singleton("GodotGetImage")
		getImage.connect("image_request_completed", _on_image_request_completed)
		getImage.connect("error", _on_error)
		getImage.connect("permission_not_granted_by_user", _on_permission_not_granted_by_user)

func _input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var rect: Rect2 = get_rect()
				if not rect.has_point(get_local_mouse_position()):
					image = null
					visible = false


func _on_image_request_completed(dict):
	for img_buffer in dict.values():
		image = Image.new()
		var error = image.load_jpg_from_buffer(img_buffer)
		#var error = image.load_png_from_buffer(img_buffer)
		
		if error != OK:
			print("Error loading png/jpg buffer, ", error)
		else:
			print("We are now loading texture... ")
			$"ImageTextureRect".texture = ImageTexture.new().create_from_image(image)
			visible = true
			
			
func send(id: int):
	if image != null:
		var imageRaw: PackedByteArray = var_to_bytes_with_objects(image)
		var crypto = Crypto.new()
		
		var key: CryptoKey = CryptoKey.new()
		key.load_from_string(GlobalValue.session, true)
		
		var aesKey: PackedByteArray = Tools.generateKey()
		
		var encryptAesKey: PackedByteArray = crypto.encrypt(key, aesKey)
		
		var cipherText: PackedByteArray = Tools.aesEncrypt(aesKey, imageRaw)
		
		if not GlobalValue.privateMessage.has(GlobalValue.session):
			GlobalValue.privateMessage[GlobalValue.session] = []
		
		GlobalValue.privateMessage[GlobalValue.session].append({
			"sender" : GlobalValue.publicKey,
			"cipherText" : image,
			"type" : ENet.MESSAGE_TYPE.OBJ,
			"aesKey" : encryptAesKey,
		})
		
		get_node("/root/Menu/ChatControl").flush()
		
		ENet.sendObject.rpc_id(id, cipherText, encryptAesKey, len(imageRaw), GlobalValue.publicKey)

		visible = false
		image = null
	
func _on_error(e):
	pass

func _on_permission_not_granted_by_user(permission):
	pass

func _on_image_button_pressed() -> void:
	if OS.get_name() == "Android":
		getImage.getGalleryImage()

	
	


func _on_send_image_texture_button_pressed() -> void:
	ENet.getRpcId.rpc_id(GlobalValue.serverRpcId, GlobalValue.session)
