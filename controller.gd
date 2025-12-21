extends Node3D

@export var controlled_vehicle: VehicleBody3D
@export var path_to_follow: Path3D

func _process(delta: float):
	if path_to_follow and  controlled_vehicle:
		var closest_pos = path_to_follow.curve.get_closest_point(controlled_vehicle.global_position)
		$Area3D.global_position = closest_pos
