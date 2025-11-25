extends Control
@export var HANDS_RAYCAST: RayCast3D
@onready var AIM_POINT: Control = $aim_point

@export var BRIGHT_COLOR_AIM: Color
@export var DIM_COLOR_AIM: Color

func _process(_delta: float) -> void:
	_check_pull_hand()


func _check_pull_hand() -> void:
	if HANDS_RAYCAST.is_colliding(): AIM_POINT.self_modulate = BRIGHT_COLOR_AIM
	else: AIM_POINT.self_modulate = DIM_COLOR_AIM
