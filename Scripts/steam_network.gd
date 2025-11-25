extends Node
@onready var PLAYER_SCENE: PackedScene = preload("res://scenes/player_scenes/player.tscn")
var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

var _players_spawn_node
var _hosted_lobby_id = 0

const LOBBY_NAME = "SPACE_DEBRIS"
const LOBBY_MODE = "CoOP"

func _ready() -> void:
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	Steam.lobby_created.connect(_on_lobby_created.bind())
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.p2p_session_request.connect(_on_p2p_request)


func _on_p2p_request(steam_id: int):
	Steam.acceptP2PSessionWithUser(steam_id)  # Критически важно!
	print("P2P-сессия подтверждена с:", steam_id)



func become_host() -> void:
	print("Starting host!")
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, SteamManager.lobby_max_menbers)


func join_as_client(lobby_id):
	print("Joining lobby %s" % lobby_id)
	Steam.joinLobby(int(lobby_id))
	

func _on_lobby_created(connect: int, lobby_id):
	print("On lobby created.")
	if connect == 1:
		_hosted_lobby_id = lobby_id
		print("Created lobby %s" %_hosted_lobby_id)
		
		Steam.setLobbyJoinable(_hosted_lobby_id, true)
		Steam.setLobbyData(_hosted_lobby_id, "name", LOBBY_NAME)
		Steam.setLobbyData(_hosted_lobby_id, "mode", LOBBY_MODE)
		
		_create_host()


func _create_host() -> void:
	if multiplayer_peer.get_connection_status() != MultiplayerPeer.CONNECTION_DISCONNECTED:
		multiplayer_peer.close()
	var error = multiplayer_peer.create_host(0)
	multiplayer.multiplayer_peer = multiplayer_peer
	if error == OK:
		print("Host created, waiting for connections...")
		_add_player_to_game(1)
	else:
		print("Host creation error:", error)


func _on_lobby_joined(lobby: int, permissions: int, locked: bool, response: int) -> void:
	print("On lobby joined.")
	
	if response == 1:
		var id = Steam.getLobbyOwner(lobby)
		if id != Steam.getSteamID():
			print("Connecting client to socket...")
			connect_soket(id)
		else: pass
	else:
		var FAIL_REASON: String
		match response:
			2:  FAIL_REASON = "This lobby no longer exists."
			3:  FAIL_REASON = "You don't have permission to join this lobby."
			4:  FAIL_REASON = "The lobby is now full."
			5:  FAIL_REASON = "Uh... something unexpected happened!"
			6:  FAIL_REASON = "You are banned from this lobby."
			7:  FAIL_REASON = "You cannot join due to having a limited account."
			8:  FAIL_REASON = "This lobby is locked or disabled."
			9:  FAIL_REASON = "This lobby is community locked."
			10: FAIL_REASON = "A user in the lobby has blocked you from joining."
			11: FAIL_REASON = "A user you have blocked is in the lobby."
		print(FAIL_REASON)


func connect_soket(steam_id: int) -> void:
	if multiplayer_peer.get_connection_status() != MultiplayerPeer.CONNECTION_DISCONNECTED:
		multiplayer_peer.close()
	var error = multiplayer_peer.create_client(steam_id, 0)
	multiplayer.multiplayer_peer = multiplayer_peer
	if error == OK:
		print("Connecting peer to host...")
	else:
		print("Error creating client: %s" %str(error))


func list_lobbies() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	Steam.addRequestLobbyListStringFilter("name", LOBBY_NAME, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()


func _add_player_to_game(id) -> void:
	print("Player %s joined to game!" %id)
	var player_to_add = PLAYER_SCENE.instantiate()
	player_to_add.name = str(id)
	player_to_add.set_multiplayer_authority(id)

	_players_spawn_node.add_child(player_to_add, true)


func _del_player(id):
	print("Player %s left the game!" % id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()
