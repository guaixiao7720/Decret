extends Control


func _on_generate_button_pressed() -> void:
	Tools.changeWindow()


func _on_back_button_pressed() -> void:
	Tools.changeWindow()
	visible = true
