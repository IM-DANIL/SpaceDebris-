extends Control
@onready var HANDS_RAYCAST: RayCast3D = $"../../CameraNode/Camera3D/HandsRayCast"
@onready var AIM_TEXTURE: TextureRect = $AimTexture

@export var BRIGHT_AIM: Color
@export var DIM_AIM: Color

func _process(_delta: float) -> void:
	if HANDS_RAYCAST.is_colliding(): AIM_TEXTURE.self_modulate = BRIGHT_AIM
	else: AIM_TEXTURE.self_modulate = DIM_AIM
