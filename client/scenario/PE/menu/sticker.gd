extends Control

@export var stickerID: String

func setup():
	$"StickerTextureButton".texture_normal = load("res://client/sticker/" + stickerID)
	$"Label".text = stickerID.trim_suffix(".jpg")
	
	


func _on_sticker_texture_button_pressed() -> void:
	var textEdit: TextEdit = get_node("/root/Menu/ChatControl/InputControl/InputVBoxContainer/InputHBoxContainer/TextEdit")
	
	textEdit.insert_text_at_caret("[img]res://client/sticker/" + stickerID + "[/img]")
