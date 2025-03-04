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
				var rect: Rect2 = $"TextEdit".get_rect()
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
			
			
			
	
func _on_error(e):
	pass

func _on_permission_not_granted_by_user(permission):
	pass

func _on_image_button_pressed() -> void:
	if OS.get_name() == "Android":
		getImage.getGalleryImage()

	
	
