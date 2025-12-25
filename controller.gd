extends Node3D

@export var controlled_vehicle: Vehicle
@export var path_to_follow: Path3D

#the offset for the future position
@export var FUTURE_OFFSET: float = 1.0
#the offset from the normal point on the path to the target position
@export var TARGET_OFFSET: float = 2.5
#distance from path in which we consider the vehicle is on trail
@export var PATH_RADIUS: float = .5

func _ready():
	if path_to_follow and controlled_vehicle:
		controlled_vehicle.is_active = true

		
#controllers takes a vehicle that simply follows a path and decides the target frame by frame
func _physics_process(delta: float):
	if path_to_follow and controlled_vehicle:
		var curve =  path_to_follow.curve
		var current_future_position = get_future_positon()
		var normal_vector = current_future_position - curve.get_closest_point(current_future_position)

		var target_position = Vector3.ZERO
		
		if normal_vector.length_squared() > PATH_RADIUS*PATH_RADIUS:
			#fmod helps to get the reminder when we are approaching the last point of the path
			target_position = curve.sample_baked(fmod(curve.get_closest_offset(current_future_position)+TARGET_OFFSET, curve.get_baked_length()))
		
		if controlled_vehicle.is_active:
			controlled_vehicle.seek(target_position)
			
		#debug_draws
		$Area3D/Future.global_position = get_future_positon()
		$Area3D/Target.global_position = target_position
		$DesiredVelocityRaycast.global_position = controlled_vehicle.get_vehicle_global_position()
		$DesiredVelocityRaycast.target_position = controlled_vehicle.desired_velocity
		$SteerForceRaycast.global_position = controlled_vehicle.get_vehicle_global_position()
		$SteerForceRaycast.target_position = controlled_vehicle.steer_force


func get_future_positon() -> Vector3:
	return controlled_vehicle.get_vehicle_global_position() + controlled_vehicle.get_current_velocity().limit_length(FUTURE_OFFSET)
