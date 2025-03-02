extends TextureButton

@export var friendName: String
@export var unreadMessages: int = 0
@export var lastChatYear: int
@export var lastChatMonth: int
@export var lastChatDay: int
@export var lastChatHour: int
@export var lastChatMin: int
@export var friendKey: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func flush() -> void:
	var friendText: String = friendName
	friendText = friendText.erase(0, 71).left(703).replace("\n", "")
	
	if len(friendName) > 20:
		friendText = friendText.left(20)
		friendText += "..."
		
	$"nameLabel".text = friendText
	
	var lastChatText: String = "上一次聊天"
	
	if unreadMessages > 0:
		$"RedPointTextureRect".visible = true
		$"UnreadLabel".visible = true
		
		if unreadMessages > 999:
			$"UnreadLabel".text = "999"
		else:
			$"UnreadLabel".text = str(unreadMessages)
			
	else:
		$"RedPointTextureRect".visible = false
		$"UnreadLabel".visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	unreadMessages = 0
	flush()
	get_node("/root/Menu/ContactListControl").visible = false
	get_node("/root/Menu/ChatControl").visible = true
	GlobalValue.session = friendKey
	GlobalValue.sessionType = GlobalValue.SESSION_TYPE.FRIEND
	get_node("/root/Menu/ChatControl").flush()
