extends Vehicle
class_name VehicleCarBody3D
@export var BRAKE_STRENGTH: float = 2.0
@onready var vehicle_body_3d: VehicleBody3D = $VehicleBody3D

@export var wheel_array : Array[VehicleWheel3D] = []

func _physics_process(delta: float):
	var _steer_target = Input.get_axis(&"turn_right", &"turn_left")
	
	if !is_active or _steer_target:
		vehicle_body_3d.steering = _steer_target
	
	if Input.is_action_pressed(&"accelerate"):
		vehicle_body_3d.engine_force = MAX_FORCE
	
	if Input.is_action_just_released(&"accelerate"):
		vehicle_body_3d.engine_force = .0
		
	if Input.is_action_pressed(&"reverse"):
		vehicle_body_3d.brake = BRAKE_STRENGTH
		
	if Input.is_action_just_released(&"reverse"):
		vehicle_body_3d.brake = .0 
		

func get_current_velocity() -> Vector3:
	return vehicle_body_3d.linear_velocity
	
func get_current_force() -> float:
	return vehicle_body_3d.engine_force
	
func set_steer_force(steering_force: Vector3):
	var right: Vector3 = vehicle_body_3d.global_transform.basis.x
	var steer_forward = steering_force.length() * vehicle_body_3d.mass
	var steer_side = steering_force.dot(right)
	vehicle_body_3d.engine_force = clamp(steer_forward,0,MAX_FORCE)
	vehicle_body_3d.steering = clamp(steer_side,-1,1)

func get_vehicle_global_position() -> Vector3:
	return vehicle_body_3d.global_position
