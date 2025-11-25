extends Node
@onready var PLAYER_SCENE: PackedScene = preload("res://scenes/player_scenes/player.tscn")

const SERPVER_PORT: int = 8080
const SERVER_IP = "127.0.0.1"

var multiplayer_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var _players_spawn_node


func become_host() -> void:
	print("Starting host!")
	
	multiplayer_peer.create_server(SERPVER_PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	if not OS.has_feature("dedicated_server"):
		_add_player_to_game(1)


func join_as_client(lobby_id) -> void:
	print("Player two joining.")
	
	multiplayer_peer.create_client(SERVER_IP, SERPVER_PORT)
	multiplayer.multiplayer_peer = multiplayer_peer


func _add_player_to_game(id: int) -> void:
	print("Player %s joined to game!" %id)
	
	var player_to_add = PLAYER_SCENE.instantiate()
	player_to_add.name = str(id)
	
	_players_spawn_node.add_child(player_to_add, true)


func _del_player(id: int) -> void:
	print("Player %s left to game!" %id)
	if not _players_spawn_node.has_node(str(id)): return
	_players_spawn_node.get_node(str(id))
