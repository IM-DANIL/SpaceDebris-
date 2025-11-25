class_name NetworkManager
extends Node
@export var ENET_NETWORK_SCENE: PackedScene
@export var STEAM_NETWORK_SCENE: PackedScene

enum MULTIPLAYER_NETWORK_TYPE {ENET, STEAM}
var active_network_type: MULTIPLAYER_NETWORK_TYPE = MULTIPLAYER_NETWORK_TYPE.ENET
var active_network

@export var SPAWN_NODE: Node3D

func _build_multiplayer_network() -> void:
	if not active_network:
		print("Setting active_network.")
		match  active_network_type:
			MULTIPLAYER_NETWORK_TYPE.ENET:
				if ENET_NETWORK_SCENE:
					print("Setting network type to Enet.")
					_set_active_network(ENET_NETWORK_SCENE)
			MULTIPLAYER_NETWORK_TYPE.STEAM:
				if STEAM_NETWORK_SCENE:
					print("Setting network type to Steam.")
					_set_active_network(STEAM_NETWORK_SCENE)
			_: print("No match for network type!")


func _set_active_network(active_network_scene) -> void:
	var network_scene_initialized = active_network_scene.instantiate()
	active_network = network_scene_initialized
	active_network._players_spawn_node = SPAWN_NODE
	add_child(active_network)


func become_host(is_dedicated_server = false) -> void:
	_build_multiplayer_network()
	if active_network: active_network.become_host()
	else: printerr("Absent active_network!")


func join_as_client(lobby_id = 0) -> void:
	_build_multiplayer_network()
	active_network.join_as_client(lobby_id)


func list_lobbies() -> void:
	_build_multiplayer_network()
	active_network.list_lobbies()
