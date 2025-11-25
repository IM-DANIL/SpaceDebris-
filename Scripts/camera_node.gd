extends Node3D
@onready var CAMERA: Camera3D = $Camera3D
@onready var PLAYER: CharacterBody3D = $".."
@onready var PLAYER_MODEL: Node3D = $"../PlayerModel"


@export var MOUSE_SENS: float = 0.003

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && event is InputEventMouseMotion:
		rotate_x(-event.relative.y * MOUSE_SENS)
		PLAYER_MODEL.rotation.x = rotation.x
		if deg_to_rad(90) <= abs(rotation.x) && abs(rotation.x) <= deg_to_rad(180):
			PLAYER.rotate_y(event.relative.x * MOUSE_SENS)
		else: PLAYER.rotate_y(-event.relative.x * MOUSE_SENS)
