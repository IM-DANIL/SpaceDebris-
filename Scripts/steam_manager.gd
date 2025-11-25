extends Node
var is_owned: bool = false
var steam_app_id: int = 480
var steam_id: int = 0
var steam_username: String = ""

var lobby_id: int = 0
var lobby_max_menbers: int = 10

func _init() -> void:
	print("Inits steam.")
	OS.set_environment("SteamAppId", str(steam_app_id))
	OS.set_environment("SteamGameId", str(steam_app_id))


func _process(_delta: float) -> void:
	Steam.run_callbacks()


func initialize_steam() -> void:
	
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam Initialize?: %s" %initialize_response)
	
	if initialize_response['status'] > 0:
		print("Failed to init Steam! Shutting down. %s" % initialize_response)
		get_tree().quit()
	
	is_owned = Steam.isSubscribed() 
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	Steam.allowP2PPacketRelay(true)
	
	print("Steam_id %s" %steam_id)
	
	if is_owned == false:
		print("User does not own game!")
		get_tree().quit()
