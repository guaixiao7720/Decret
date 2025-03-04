extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func scroll_to_bottom():
	var scroll_bar = get_v_scroll_bar()
	scroll_bar.value = scroll_bar.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
