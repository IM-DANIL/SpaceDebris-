class_name Garbage
extends RigidBody3D
var HAND: Hand
@export var DEBRIS_SCENE: PackedScene = preload("res://scenes/debris_scenes/screw.tscn")
const MAX_BROKEN_NUMBER: int = 3
var broken_number: int = 0

@export var DEBRIS_PARAM: Dictionary = {
	"MASS": 1.0,
	"BROKEN_SPEED": 1.2,
	
	"HOLD_TIME": 5.0,
	"DEBRIS_IMPULSE": 5.0,
	"PLAYER_IMPULSE": 7.0
}

func _physics_process(delta: float) -> void:
	if HAND: _debris_movement()


func drop_object(pressing_time: float, dir: Vector3, player: Player) -> void:
	linear_velocity = Vector3.ZERO
	apply_central_impulse(-dir * pressing_time * DEBRIS_PARAM.DEBRIS_IMPULSE)
	player.pushing_player(pressing_time * DEBRIS_PARAM.PLAYER_IMPULSE)
	HAND = null


func _broken_debris() -> void:
	pass
	#if DEBRIS_SCENE:
		#if broken_number < MAX_BROKEN_NUMBER:
			#for i in range(2):
				#var debris = DEBRIS_SCENE.instantiate()
				#debris.broken_number = broken_number + 1
				#debris.mass = mass/2
				#debris.scale = scale * 0.5
				#get_parent().add_child(debris)
				#debris.global_position = global_position
				#debris.linear_velocity = -linear_velocity/2
			#queue_free()


func _debris_movement() -> void:
	global_position = HAND.OBJECT_POS.global_position
	global_rotation = HAND.global_rotation
	rpc("_debris_sync", global_position)


@rpc("call_local", "any_peer")
func set_block_owner(peer_id):
	set_multiplayer_authority(peer_id)


@rpc("unreliable")
func _debris_sync(new_pos: Vector3) -> void:
	if not is_multiplayer_authority():
		global_position = new_pos


func _on_debris_area_body_entered(body: Node3D) -> void:
	if linear_velocity.length() >= DEBRIS_PARAM.BROKEN_SPEED:
		_broken_debris()
