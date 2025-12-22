extends Vehicle

#brake, engine_force, steering.
@export var STEER_SPEED: float = 1.5
@export var BRAKE_STRENGTH: float = 2.0
@export var engine_force_value : float = 40.0
@onready var vehicle_body_3d = $VehicleBody3D
var _steer_target: float = 0.0

func _ready():
	target_position = vehicle_body_3d.global_position

func _physics_process(delta: float):
	super(delta)
	_steer_target = Input.get_axis(&"turn_right", &"turn_left")
	vehicle_body_3d.steering = _steer_target#move_toward(steering, _steer_target, STEER_SPEED * delta)
	
	var speed : float = vehicle_body_3d.linear_velocity.length()

	if Input.is_action_pressed(&"accelerate"):
		vehicle_body_3d.engine_force = engine_force_value
	else:
		vehicle_body_3d.engine_force = .0
		
	if Input.is_action_pressed(&"reverse"):
		vehicle_body_3d.brake = BRAKE_STRENGTH
	else:
		vehicle_body_3d.brake = .0 

func get_current_velocity() -> Vector3:
	return vehicle_body_3d.linear_velocity
	
func set_steer_force(steering_force: Vector3):
	var forward = steering_force.dot(vehicle_body_3d.linear_velocity.limit_length(1))
	var side = steering_force.dot(vehicle_body_3d.linear_velocity.cross(Vector3.UP).limit_length(1))

	vehicle_body_3d.engine_force = forward
	vehicle_body_3d.steering = side

func get_vehicle_global_position() -> Vector3:
	return vehicle_body_3d.global_position
