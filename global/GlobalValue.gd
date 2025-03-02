extends Node

enum SESSION_TYPE{
	FRIEND,
	GROUP,
}

var osName: String

var isServer: bool = false

var serverRpcId: int

var publicKey: String

var publicCryptoKey: CryptoKey

var privateKey: CryptoKey

var privateMessage: Dictionary = {}

var session: String
var sessionType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
