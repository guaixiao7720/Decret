extends HBoxContainer

var isShow: bool = false

func _input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var rect: Rect2 = $"TextEdit".get_rect()
				if rect.has_point(get_local_mouse_position()):
					isShow = true
					$"Timer".start()
				else:
					isShow = false
					$"Timer".start()
					


func _on_timer_timeout() -> void:
	if isShow:
		$"../Control".visible = true
	else:
		$"../Control".visible = false
		$"TextEdit".cancel_ime()
