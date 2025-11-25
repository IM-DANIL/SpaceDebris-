extends Node3D
@onready var PLAYER: Player = $"../.."
@onready var HAND_MODEL: Marker3D = $hand_pos
@onready var OBJECT_POS: Marker3D = $hand_pos/object_pos
@onready var HOLD_TIMER: Timer = $hold_timer
@onready var AWAIT_TIMER: Timer = $await_timer

@export var IS_LEFT: bool = false
@export var HAND_POS: Marker3D
var HAND_MODEL_ROTATION: Vector3

var IS_SQUEEZE: bool = false
@export var SPEED_HAND: float = 5.0

var cur_object: Node3D
var IS_DRAG: bool = false

func _ready() -> void:
	if not IS_LEFT: HAND_MODEL.scale.x = -1


func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority() and SettingsManager.IS_MULTIPLAYER: return
	if event is InputEventMouseButton:
		if IS_DRAG and AWAIT_TIMER.is_stopped():
			if event.is_action_pressed(name+"_click"): 
				HOLD_TIMER.stop()
				HOLD_TIMER.start(cur_object.DEBRIS_PARAM.HOLD_TIME)
			elif event.is_action_released(name+"_click"): _drop_object()


func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority() and SettingsManager.IS_MULTIPLAYER: return
	_hand_movement(delta)


func _hand_movement(delta: float) -> void:
	if HAND_POS and not IS_SQUEEZE: 
		HAND_MODEL.rotation.x = deg_to_rad(-75)
		global_position = lerp(global_position, HAND_POS.global_position, delta * SPEED_HAND)
		global_rotation = PLAYER.CAMERA_NODE.global_rotation


func hand_squeeze(pos: Vector3, normal: Vector3) -> void:
	global_position = pos
	HAND_MODEL.rotation.x = deg_to_rad(0)
	look_at(global_position - normal, PLAYER.CAMERA_NODE.global_transform.basis.y, false)

func drag_object(_cur_object: Node3D) -> void:
	cur_object = _cur_object
	IS_DRAG = true
	
	cur_object.HAND = self
	cur_object.set_block_owner.rpc(PLAYER.get_multiplayer().get_unique_id())
	AWAIT_TIMER.start()


func _drop_object() -> void:
	if cur_object:
		var pressing_time: float = 1.0 -(HOLD_TIMER.time_left / cur_object.DEBRIS_PARAM.HOLD_TIME)
		cur_object.drop_object(pressing_time, PLAYER.CAMERA_NODE.global_transform.basis.z.normalized(), PLAYER)
	
		cur_object = null
		IS_DRAG = false
