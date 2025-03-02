extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(nameStr: String, message: String):
	var name1: String = nameStr
	name1 = name1.erase(0, 71).left(703).replace("\n", "")
	
	if len(nameStr) > 20:
		name1 = name1.left(20)
		name1 += "..."
		
	$"nameLabel".text = name1
	
	$"messageRichTextLabel".text = message
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
