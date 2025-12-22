extends Vehicle

#brake, engine_force, steering.
@export var STEER_SPEED: float = 1.5
@export var BRAKE_STRENGTH: float = 2.0
@export var engine_max_force : float = 40.0
@onready var vehicle_body_3d = $VehicleBody3D
var _steer_target: float = 0.0

func _ready():
	target_position = vehicle_body_3d.global_position

func _physics_process(delta: float):
	super(delta)
	_steer_target = Input.get_axis(&"turn_right", &"turn_left")
	
	if _steer_target:
		vehicle_body_3d.steering = _steer_target#move_toward(steering, _steer_target, STEER_SPEED * delta)
	
	var speed : float = vehicle_body_3d.linear_velocity.length()

	if Input.is_action_pressed(&"accelerate"):
		vehicle_body_3d.engine_force = engine_max_force
	
	if Input.is_action_just_released(&"accelerate"):
		vehicle_body_3d.engine_force = .0
		
	if Input.is_action_pressed(&"reverse"):
		vehicle_body_3d.brake = BRAKE_STRENGTH
		
	if Input.is_action_just_released(&"reverse"):
		vehicle_body_3d.brake = .0 
		

func get_current_velocity() -> Vector3:
	return vehicle_body_3d.linear_velocity
	
func set_steer_force(steering_force: Vector3):
	var forward: Vector3 = vehicle_body_3d.global_transform.basis.z
	var right: Vector3 = vehicle_body_3d.global_transform.basis.x

	var steer_forward = steering_force.length()#.dot(forward)
	var steer_side = steering_force.dot(right)
	vehicle_body_3d.engine_force = steer_forward*10#lerp(0.0, engine_max_force, forward/ engine_max_force )
	vehicle_body_3d.steering = clamp(steer_side,-1,1)

func get_vehicle_global_position() -> Vector3:
	return vehicle_body_3d.global_position
