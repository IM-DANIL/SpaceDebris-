class_name Player
extends CharacterBody3D
@onready var HANDS_RAYCAST: RayCast3D = $CameraNode/Camera3D/HandsRayCast
@onready var CARABINE_RAYCAST: RayCast3D = $CameraNode/Camera3D/CarabineRayCast
@onready var CAMERA_NODE: Node3D = $CameraNode
@onready var HANDS_NODE: CanvasLayer = $HandsNode
@onready var LEFT_HAND: Hand = $HandsNode/Left
@onready var RIGHT_HAND: Hand = $HandsNode/Right

const CARBINE_SCENE: PackedScene = preload("uid://ci4eg448vm1rw")

var CARABINE: Carabine

var PLAYER_PARAM: Dictionary = {
	"HEALTH": 100.0,
	
	"PULL_DIST": 2.25,
	"PULL_SPEED": 10.0,
	"PULL_MULTIP": 5.0,
	"PULL_ACCEL": 20.0,
	
	"CUR_SPEED": 0.0,
	"MIN_SPEED": 1.0,
	"MAX_SPEED": 4.0,
	"ACCEL": 5.0,
	"FRICT": 0.75,
	
	"IS_CARABINE": false,
	"CARABINE_DIST": 15.0
}

func _ready() -> void:
	HANDS_RAYCAST.target_position.z = -PLAYER_PARAM.PULL_DIST
	CARABINE_RAYCAST.target_position.z -= PLAYER_PARAM.CARABINE_DIST


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if PLAYER_PARAM.IS_CARABINE && event.is_action_pressed("carbine_activation"): _attach_carbine()
	
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"): _squeeze_hand(&"LEFT_HAND"); 
		elif event.is_action_released("left_click"): _unclench_hand(&"LEFT_HAND"); 
		if event.is_action_pressed("right_click"): _squeeze_hand(&"RIGHT_HAND"); 
		elif event.is_action_released("right_click"): _unclench_hand(&"RIGHT_HAND"); 


func _physics_process(delta: float) -> void:
	_player_movement(delta)
	
	if LEFT_HAND.IS_SQUEEZE or RIGHT_HAND.IS_SQUEEZE:
		_handle_pull(delta)
	
	move_and_slide()


func _player_movement(delta: float) -> void:
	if LEFT_HAND.IS_SQUEEZE or RIGHT_HAND.IS_SQUEEZE:
		PLAYER_PARAM.CUR_SPEED = lerp(PLAYER_PARAM.CUR_SPEED, PLAYER_PARAM.MAX_SPEED, delta * PLAYER_PARAM.ACCEL)
	else:
		PLAYER_PARAM.CUR_SPEED = lerp(PLAYER_PARAM.CUR_SPEED, PLAYER_PARAM.MIN_SPEED, delta * PLAYER_PARAM.FRICT)
	
	PLAYER_PARAM.CUR_SPEED  = clamp(PLAYER_PARAM.CUR_SPEED , PLAYER_PARAM.MIN_SPEED, PLAYER_PARAM.MAX_SPEED)
	velocity = velocity.limit_length(PLAYER_PARAM.CUR_SPEED)


func _handle_pull(delta: float) -> void:
	var pull_point: Vector3 = Vector3.ZERO
	var active_hands = 0
	if LEFT_HAND.IS_SQUEEZE:
		pull_point += LEFT_HAND.global_position
		active_hands += 1
	if RIGHT_HAND.IS_SQUEEZE:
		pull_point += RIGHT_HAND.global_position
		active_hands += 1
	if active_hands > 0:
		pull_point /= active_hands
	
	var dir_target = (pull_point - global_position).normalized()
	var distance = global_position.distance_to(pull_point)
	var current_speed = PLAYER_PARAM.PULL_SPEED * (PLAYER_PARAM.PULL_MULTIP if active_hands == 2 else 1.0)
	
	velocity = lerp(velocity, dir_target * current_speed * clamp(distance, 0, PLAYER_PARAM.PULL_DIST), \
	delta * PLAYER_PARAM.PULL_ACCEL)


func _squeeze_hand(hand: StringName) -> void:
	if get(hand):
		var _hand: Hand = get(hand)
		if HANDS_RAYCAST.is_colliding():
			if not _hand.IS_SQUEEZE: 
				_hand.hand_squeeze(HANDS_RAYCAST.get_collision_point(), HANDS_RAYCAST.get_collision_normal())
				_hand.IS_SQUEEZE = true


func _unclench_hand(hand: StringName) -> void:
	if get(hand):
		var _hand: Hand = get(hand)
		if _hand.IS_SQUEEZE:
			_hand.IS_SQUEEZE = false


func _attach_carbine() -> void:
	if !CARABINE:
		if CARABINE_RAYCAST.is_colliding():
			var _carabine: Carabine = CARBINE_SCENE.instantiate()
			CARABINE = _carabine
			HANDS_NODE.add_child(_carabine)
			_carabine.attach(CARABINE_RAYCAST.get_collision_point(), self)
	else:
		CARABINE.queue_free()
		CARABINE = null
