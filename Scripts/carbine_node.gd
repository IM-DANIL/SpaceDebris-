class_name Carabine
extends Node3D
var PLAYER: Player

var CARABINE_PARAM: Dictionary = {
	"MAX_DIST": 1.5,
	"SPRING_FORCE": 250.0
	}

func attach(pos: Vector3, player: Player) -> void:
	global_position = pos
	PLAYER = player

func _physics_process(delta: float) -> void:
	if !PLAYER: return
	
	var dir_to_player: Vector3 = PLAYER.global_position.direction_to(global_position)
	var dist_to_player: float = PLAYER.global_position.distance_to(global_position)
	if dist_to_player > CARABINE_PARAM.MAX_DIST:
		PLAYER.velocity += delta * dir_to_player * CARABINE_PARAM.SPRING_FORCE 

"""
@export var SPRING_STIFFNESS: float = 300.0
@export var DAMPING: float = 50.0

var current_dist: float = 0.0



func _physics_process(delta: float) -> void:

	if current_dist > MAX_DIST:
		var overshoot = current_dist - MAX_DIST
		var spring_force = -dir_to_player * overshoot * SPRING_STIFFNESS
		var relative_velocity = PLAYER.velocity.dot(dir_to_player)
		var damping_force = -dir_to_player * relative_velocity * DAMPING
		PLAYER.velocity += (spring_force + damping_force) * current_dist * delta
"""
