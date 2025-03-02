extends Window


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_register_button_pressed() -> void:
	visible = true


func _on_close_requested() -> void:
	visible = false
