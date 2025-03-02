extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_check_box_toggled(toggled_on: bool) -> void:
	disabled = !toggled_on


func _on_pressed() -> void:
	var crypto = Crypto.new()
	var key = crypto.generate_rsa(4096)
	key.save("user://userKey.key")
	key.save("user://userKey.pub", true)
	
