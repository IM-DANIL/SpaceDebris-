extends Control
@onready var MULTIPLAYER_TYPE_PANEL: Panel = $"../multiplayer_type_panel"
@onready var STEAM_NODE: Control = $"../steam_node"

func _on_back_button_pressed() -> void:
	MULTIPLAYER_TYPE_PANEL.visible = true
	hide()
	STEAM_NODE.visible = false
	
