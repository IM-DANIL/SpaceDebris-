extends Node
var IS_MULTIPLAYER: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey: 
		if Input.is_action_just_pressed("escape"):
			get_tree().quit()
