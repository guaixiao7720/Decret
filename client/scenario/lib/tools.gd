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

func generateKey() -> PackedByteArray:
	var rng = RandomNumberGenerator.new()
	rng.randomize()  # 初始化随机数种子

	# 方法 1：生成 32 字节的随机字符串（由字母和数字组成）
	var charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var random_string = ""
	for i in range(32):
		random_string += charset[rng.randi_range(0, charset.length() - 1)]
		
	return random_string.to_utf8_buffer()
	
func aesEncrypt(key: PackedByteArray, data: PackedByteArray) -> PackedByteArray:
	var aes: AESContext = AESContext.new()
	var data1 = data.duplicate()
	
	while len(data1) % 16 != 0:
		data1.append(255)
	
	aes.start(AESContext.MODE_ECB_ENCRYPT, key)
	var jiamihou: PackedByteArray = aes.update(data1)
	aes.finish()
	
	return jiamihou
	
func aesDecrypt(key: PackedByteArray, data: PackedByteArray, length: int) -> PackedByteArray:
	var aes: AESContext = AESContext.new()
	
	aes.start(AESContext.MODE_ECB_DECRYPT, key)
	var jiamihou: PackedByteArray = aes.update(data)
	aes.finish()
	
	jiamihou.resize(length)
	
	return jiamihou
	
