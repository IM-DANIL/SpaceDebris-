extends Node3D
@onready var CAMERA: Camera3D = $camera

@export var PLAYER: Player
@export var PLAYER_MODEL: Node3D

@export var SENS: float = 0.003

func _ready() -> void:
	if not is_multiplayer_authority() and SettingsManager.IS_MULTIPLAYER: return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CAMERA.current = true


func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority() and SettingsManager.IS_MULTIPLAYER: return
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_x(-event.relative.y * SENS) 
			_rotation_model()
			if 90 <= abs(rad_to_deg(rotation.x)) and abs(rad_to_deg(rotation.x)) <= 180:
				PLAYER.rotate_y(event.relative.x * SENS)
			else: PLAYER.rotate_y(-event.relative.x * SENS)


func _rotation_model() -> void:
	if PLAYER_MODEL:
		PLAYER_MODEL.rotation.x = rotation.x
