extends Control

var isHover: bool = false
func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if not isHover:
					visible = false

func _on_sticker_button_pressed() -> void:
	for node in get_tree().get_nodes_in_group("InputControl"):
		node.visible = false
	visible = true


func _on_mouse_entered() -> void:
	isHover = true


func _on_mouse_exited() -> void:
	isHover = false
