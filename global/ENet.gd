extends Node

var peer: ENetMultiplayerPeer

var keyRpcID: Dictionary = {}

var serverRpcId: int

enum MESSAGE_TYPE{
	TEXT,
	OBJ,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_user_connected)
	multiplayer.peer_disconnected.connect(_on_user_disconnected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connectRelayServer(adress: String) -> bool:
	var adressArray = adress.split(":")
	
	if len(adressArray) == 1:
		return false
	
	var ip: String = adressArray[0]
	var port: int = int(adressArray[1])
	
	peer = ENetMultiplayerPeer.new()
	
	if peer.create_client(ip, port) == OK:
		multiplayer.multiplayer_peer = peer
		return true
	else:
		return false
		
func createRelayServer(port: int) -> bool:
	peer = ENetMultiplayerPeer.new()
	
	if peer.create_server(port, get_node("/root/Server").config["maxClients"]) == OK:
		multiplayer.multiplayer_peer = peer
		serverRpcId = multiplayer.get_unique_id()
		print("rpcid: " +  str(serverRpcId))
		
		return true
	else:
		return false
	
func _on_user_connected(id: int):
	print(str(id) + " 发起连接")
	connectSucess.rpc_id(id, serverRpcId)
	
func _on_user_disconnected(id: int):
	keyRpcID.erase(id)

@rpc("any_peer", "call_remote")
func regUser(publicKey: String):
	if multiplayer.is_server():
		if publicKey != "":
			var rpcid: int = multiplayer.get_remote_sender_id()
			keyRpcID[rpcid] = publicKey
			print("[" + str(rpcid) + "]" + "  已连接公钥 " + publicKey)
			
	
@rpc("any_peer", "call_remote")
func getRpcId(publicKey: String):
	if multiplayer.is_server():
		print("[" + str(multiplayer.get_remote_sender_id()) + "]" + "  获取rpcid ")
		print(str(keyRpcID))
		
		var rpcid = keyRpcID.find_key(publicKey)
		if rpcid == null:
			print("未找到")
		else:
			recieveRpcId.rpc_id(multiplayer.get_remote_sender_id(), rpcid)

@rpc("authority", "call_remote")
func recieveRpcId(id: int):
	if get_node("/root/Menu/ChatControl/InputControl/InputVBoxContainer/ImageControl").is_visible_in_tree():
		get_node("/root/Menu/ChatControl/InputControl/InputVBoxContainer/ImageControl").send(id)
	else:
		get_node("/root/Menu/ChatControl/InputControl").send(id)

@rpc("authority", "call_remote")
func connectSucess(serverRpcId: int):
	GlobalValue.serverRpcId = serverRpcId
	GlobalValue.privateKey = CryptoKey.new()
	
	if not FileAccess.file_exists("user://userKey.key") or not FileAccess.file_exists("user://userKey.key"):
		get_node("/root/Login/KeyAcceptDialog").visible = true
		return
	
	GlobalValue.privateKey.load("user://userKey.key")
	GlobalValue.publicCryptoKey = CryptoKey.new()
	GlobalValue.publicCryptoKey.load("user://userKey.pub")
	GlobalValue.publicKey = FileAccess.get_file_as_string("user://userKey.pub")
	
	
	regUser.rpc_id(GlobalValue.serverRpcId, GlobalValue.publicKey)
	get_tree().change_scene_to_file("res://client/scenario/PE/menu/menu.tscn")


@rpc("any_peer", "call_remote")
func sendMessage(cipherText: PackedByteArray, aesKey: PackedByteArray, length: int, publicKey: String):
	var keyName: String = publicKey
	keyName = keyName.erase(0, 71).left(30).replace("\n", "").replace("\\", "").replace("/", "")
	
	## 接收信息者执行
	if has_node("/root/Menu/ContactListControl/ContactList/" + keyName):
		if not (GlobalValue.sessionType == GlobalValue.SESSION_TYPE.FRIEND and GlobalValue.session == publicKey):
			get_node("/root/Menu/ContactListControl/ContactList/" + keyName).unreadMessages += 1

		get_node("/root/Menu/ContactListControl/ContactList").move_child(get_node("/root/Menu/ContactListControl/ContactList/" + keyName), 0)
		get_node("/root/Menu/ContactListControl/ContactList/" + keyName).flush()
		
	else:
		var friendsTab = load("res://client/scenario/PE/menu/friendsTab.tscn").instantiate()
		friendsTab.friendName = publicKey
		friendsTab.name = keyName
		friendsTab.friendKey = publicKey
		
		if not (GlobalValue.sessionType == GlobalValue.SESSION_TYPE.FRIEND and GlobalValue.session == publicKey):
			friendsTab.unreadMessages += 1
			
		get_node("/root/Menu/ContactListControl/ContactList").add_child(friendsTab)
		friendsTab.flush()
		
		get_node("/root/Menu/ContactListControl/ContactList").move_child(get_node("/root/Menu/ContactListControl/ContactList/" + keyName), 0)
		
		var friendDict: Dictionary = {
			"publicKey" : publicKey,
			"remark" : "",
		}
		
		var file = FileAccess.open("user://friends/" + publicKey.erase(0, 71).left(30).replace("\n", "").replace("\\", "").replace("/", "") + ".json", FileAccess.WRITE)
		file.store_string(JSON.stringify(friendDict, "\t"))

	if not GlobalValue.privateMessage.has(publicKey):
		GlobalValue.privateMessage[publicKey] = []
	GlobalValue.privateMessage[publicKey].append({
		"sender" : publicKey,
		"cipherText" : cipherText,
		"type" : MESSAGE_TYPE.TEXT,
		"aesKey" : aesKey,
		"length" : length,
	})
	
	if (GlobalValue.sessionType == GlobalValue.SESSION_TYPE.FRIEND and GlobalValue.session == publicKey):
		
		get_node("/root/Menu/ChatControl").flush()
	else:
		if GlobalValue.osName == "Android":
			var notification = Engine.get_singleton("Notification")
			notification.showNotification(get_node("/root/Menu/ContactListControl/ContactList/" + keyName).friendName, "发来一条消息", GlobalValue.notificationId)
			GlobalValue.notificationId += 1

		
@rpc("any_peer", "call_remote")
func sendObject(objectRaw: PackedByteArray, aesKey: PackedByteArray, length: int, publicKey: String):
	var keyName: String = publicKey
	keyName = keyName.erase(0, 71).left(30).replace("\n", "").replace("\\", "").replace("/", "")
	
	## 接收信息者执行
	if has_node("/root/Menu/ContactListControl/ContactList/" + keyName):
		if not (GlobalValue.sessionType == GlobalValue.SESSION_TYPE.FRIEND and GlobalValue.session == publicKey):
			get_node("/root/Menu/ContactListControl/ContactList/" + keyName).unreadMessages += 1

		get_node("/root/Menu/ContactListControl/ContactList").move_child(get_node("/root/Menu/ContactListControl/ContactList/" + keyName), 0)
		get_node("/root/Menu/ContactListControl/ContactList/" + keyName).flush()
		
	else:
		var friendsTab = load("res://client/scenario/PE/menu/friendsTab.tscn").instantiate()
		friendsTab.friendName = publicKey
		friendsTab.name = keyName
		friendsTab.friendKey = publicKey
		
		if not (GlobalValue.sessionType == GlobalValue.SESSION_TYPE.FRIEND and GlobalValue.session == publicKey):
			friendsTab.unreadMessages += 1
			
		get_node("/root/Menu/ContactListControl/ContactList").add_child(friendsTab)
		friendsTab.flush()
		
		get_node("/root/Menu/ContactListControl/ContactList").move_child(get_node("/root/Menu/ContactListControl/ContactList/" + keyName), 0)
		
		var friendDict: Dictionary = {
			"publicKey" : publicKey,
			"remark" : "",
		}
		
		var file = FileAccess.open("user://friends/" + publicKey.erase(0, 71).left(30).replace("\n", "").replace("\\", "").replace("/", "") + ".json", FileAccess.WRITE)
		file.store_string(JSON.stringify(friendDict, "\t"))

	if not GlobalValue.privateMessage.has(publicKey):
		GlobalValue.privateMessage[publicKey] = []
	GlobalValue.privateMessage[publicKey].append({
		"sender" : publicKey,
		"cipherText" : objectRaw,
		"type" : MESSAGE_TYPE.OBJ,
		"aesKey" : aesKey,
		"length" : length,
	})
	
	if (GlobalValue.sessionType == GlobalValue.SESSION_TYPE.FRIEND and GlobalValue.session == publicKey):
		
		get_node("/root/Menu/ChatControl").flush()
	else:
		if GlobalValue.osName == "Android":
			var notification = Engine.get_singleton("Notification")
			notification.showNotification(get_node("/root/Menu/ContactListControl/ContactList/" + keyName).friendName, "发来一条消息", GlobalValue.notificationId)
			GlobalValue.notificationId += 1
		
