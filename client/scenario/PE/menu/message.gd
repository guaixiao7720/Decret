extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(nameStr: String, message):
	var name1: String = nameStr
	name1 = name1.erase(0, 71).left(703).replace("\n", "")
	
	if len(nameStr) > 20:
		name1 = name1.left(20)
		name1 += "..."
		
	$"nameLabel".text = name1
	
	if message is String:
		var bbcodeText: String = message
		
		bbcodeText = bbcodeText.insert(0, "[color=white][font_size=28]")
		bbcodeText += "[/font_size][/color]"
		
		$"messageRichTextLabel".text = bbcodeText
	
	elif message is Image:
		custom_minimum_size.y = 566
		
		$"messageRichTextLabel".visible = false
		$"ImageTextureRect".visible = true
		
		$"ImageTextureRect".texture = ImageTexture.create_from_image(message)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
