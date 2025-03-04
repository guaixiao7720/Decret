extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func newPromptWindow(size: Vector2, tittle: String, text: String, buttonText: String) -> Window:
	var window = load("res://client/scenario/lib/promptWindow/promptWindow.tscn").instantiate()
	
	window.size
	window.title = tittle
	window.text = text
	window.buttonText = buttonText
	
	return window
	
func changeWindow():
	for node in get_tree().get_nodes_in_group("control"):
		node.visible = false
