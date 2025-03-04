extends HBoxContainer

func _input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var rect: Rect2 = $"TextEdit".get_rect()
				if rect.has_point(get_local_mouse_position()):
					$"Timer".start()
				else:
					$"../Control".visible = false
					$"TextEdit".cancel_ime()
					


func _on_timer_timeout() -> void:
	$"../Control".visible = true
