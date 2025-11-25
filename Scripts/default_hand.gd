class_name Hand
extends Node3D
@onready var PLAYER: Player = $"../.."
@onready var CAMERA_NODE: Node3D = $"../../CameraNode"
@onready var HAND_MODEL: Node3D = $HandPos/HandModel
@onready var HAND_POS: Marker3D = $HandPos
@onready var MAX_POS_AREA: Area3D = $MaxPosArea

@export var POS: Marker3D 

var IS_SQUEEZE: bool = false

var HAND_PARAM: Dictionary = {
	"SPEED_HAND": 5.0,
	"SPEED_ROTATION_HAND": 10.0,
	"HAND_ROTATION": Vector3.ZERO
}

func _ready() -> void:
	HAND_PARAM.HAND_ROTATION = HAND_MODEL.rotation
	if POS:
		global_position = POS.global_position
		if POS.name in "RightPos": HAND_MODEL.scale.x = -1


func _physics_process(delta: float) -> void:
	if POS:
		_hand_movement(delta)


func _hand_movement(delta: float) -> void:
	if !IS_SQUEEZE: 
		global_position = lerp(global_position, POS.global_position, delta * HAND_PARAM.SPEED_HAND)
		
		HAND_MODEL.rotation = lerp(HAND_MODEL.rotation, HAND_PARAM.HAND_ROTATION, delta * HAND_PARAM.SPEED_HAND)
		global_transform.basis = global_transform.basis.orthonormalized().slerp( \
		CAMERA_NODE.global_transform.basis.orthonormalized(), delta * HAND_PARAM.SPEED_ROTATION_HAND).orthonormalized()


func hand_squeeze(pos: Vector3, normal: Vector3) -> void:
	global_position = pos
	
	HAND_MODEL.rotation = Vector3(deg_to_rad(90), 0, 0)
	if deg_to_rad(90) <= abs(rotation.x) && abs(rotation.x) <= deg_to_rad(180):
		look_at(global_position - normal, -PLAYER.CAMERA_NODE.global_transform.basis.y)
	else: look_at(global_position - normal, PLAYER.CAMERA_NODE.global_transform.basis.y)
