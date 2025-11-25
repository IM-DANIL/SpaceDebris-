extends Control
@onready var MULTIPLAYER_TYPE_PANEL: Panel = $"../multiplayer_type_panel"
@onready var ENET_NODE: Control = $"../enet_node"

func _on_back_button_pressed() -> void:
	MULTIPLAYER_TYPE_PANEL.visible = true
	hide()
	ENET_NODE.visible = false
