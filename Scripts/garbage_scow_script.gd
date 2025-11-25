extends Node3D

var garbade_arrays: Array = []

func _process(delta: float) -> void:
	if garbade_arrays.size() >= 4: print("win")


func _on_object_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().is_in_group("object"):
		var garbage_object: Garbage = area.get_parent_node_3d()
		garbage_object.linear_velocity = Vector3.ZERO
		garbade_arrays.append(garbage_object)
