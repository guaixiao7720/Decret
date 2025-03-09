extends Node

var config: Dictionary = {
	"ip" : "127.0.0.1",
	"port" : 25565,
	"maxClients" : 4095,
}

var notificationServer: UDPServer

var notificationPeers: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("服务器正在启动...")
	print("正在读取配置文件...")
	if FileAccess.file_exists("user://serverConfig.json"):
		var configText: String = FileAccess.get_file_as_string("user://serverConfig.json")
		var json: JSON = JSON.new()
		var configDict: Dictionary = json.parse_string(configText)
		if configDict == null:
			print("读取失败 json不合法")
		else:
			print("读取成功 正在检查配置文件是否合法")
		
		for key: String in config:
			if configDict.has(key):
				print("键值" + key + "  ✓")
			else:
				print("键值" + key + "缺失")
				
		config = configDict
				
	else:
		print("初次运行? 欢迎您 朋友")
		print("正在为您生成配置文件")
		var json: JSON = JSON.new()
		var configText: String = json.stringify(config, "\t")
		
		var file = FileAccess.open("user://serverConfig.json", FileAccess.WRITE)
		file.store_string(configText)
		
		print("已写入")
		
	
	print("正在启动服务端 address " + str(config["ip"]) + ":" + str(config["port"]))
	
	if ENet.createRelayServer(config["port"]):
		print("服务端启动成功")
	else:
		print("服务端启动失败")
		
	notificationServer = UDPServer.new()
	notificationServer.listen(config["port"] + 1)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	notificationServer.poll()

	var peer = notificationServer.take_connection()
	if peer != null:
		var packet: PackedByteArray = peer.get_packet()
		var publicKey: String = packet.get_string_from_utf8()
		
		notificationPeers[publicKey] = peer
