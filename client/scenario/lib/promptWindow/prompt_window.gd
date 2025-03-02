extends Window

@export var text: String

@export var buttonText: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Control".size = size
	$"Control/RichTextLabel".size.x = size.x
	$"Control/RichTextLabel".size.y = size.y - 60
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	visible = false
	queue_free()


func _on_close_requested() -> void:
	visible = false
	queue_free()
