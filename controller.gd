extends Node3D

@export var controlled_vehicle: Vehicle
@export var path_to_follow: Path3D

@export var FUTURE_OFFSET: float = 1.0
@export var DISTANCE_FROM_PATH: float = .05

func _ready():
	if path_to_follow and controlled_vehicle:
		controlled_vehicle.is_active = true

#controllers takes a vehicle that simply follows a path and decides the target frame by frame
func _process(delta: float):
	#debug_draws
	$Area3D/Future.global_position = get_future_positon()
	$Area3D/Target.global_position = controlled_vehicle.target_position
	$DesiredVelocityRaycast.global_position = controlled_vehicle.get_vehicle_global_position()
	$DesiredVelocityRaycast.target_position = controlled_vehicle.desired_velocity
	$SteerForceRaycast.global_position = controlled_vehicle.get_vehicle_global_position()
	$SteerForceRaycast.target_position = controlled_vehicle.steer_force
	
	if path_to_follow and controlled_vehicle:
		var curve =  path_to_follow.curve
		var current_future_position = get_future_positon()
		var distance_from_path = current_future_position - curve.get_closest_point(current_future_position)
		
		var new_target_offset = curve.get_closest_offset(current_future_position) + FUTURE_OFFSET
		controlled_vehicle.target_position = curve.sample_baked(curve.get_closest_offset(current_future_position)+2.5)
		#if distance_from_path.length_squared() > DISTANCE_FROM_PATH * DISTANCE_FROM_PATH:
		#	controlled_vehicle.is_active= true
		#else:
		#	controlled_vehicle.is_active = false

func get_future_positon() -> Vector3:
	return controlled_vehicle.get_vehicle_global_position() + controlled_vehicle.get_current_velocity().limit_length(FUTURE_OFFSET)
