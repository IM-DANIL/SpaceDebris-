class_name MultiplayerNode
extends Control
@onready var NETWORK_MANAGER: NetworkManager = %network_manager
@onready var MULTIPLAYER_TYPE_PANEL: Panel = $multiplayer_type_panel
@onready var ENET_NODE: Control = $enet_node
@onready var STEAM_NODE: Control = $steam_node

func _on_host_button_pressed() -> void:
	print("Become host pressed.")
	hide()
	NETWORK_MANAGER.become_host()


func _on_join_button_pressed() -> void:
	print("Joining a player.")
	join_lobby()

func _on_lan_button_pressed() -> void:
	MULTIPLAYER_TYPE_PANEL.hide()
	ENET_NODE.visible = true 


func _on_steam_button_pressed() -> void:
	print("Using Steam.")
	MULTIPLAYER_TYPE_PANEL.hide()
	STEAM_NODE.visible = true
	
	SteamManager.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	NETWORK_MANAGER.active_network_type = NETWORK_MANAGER.MULTIPLAYER_NETWORK_TYPE.STEAM


func join_lobby(lobby_id: int = 0) -> void:
	hide()
	NETWORK_MANAGER.join_as_client(lobby_id)


func _on_lobby_match_list(lobbies: Array) -> void:
	pass
