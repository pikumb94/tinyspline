extends VehicleBody3D

#brake, engine_force, steering.
@export var STEER_SPEED: float = 1.5
@export var BRAKE_STRENGTH: float = 2.0
@export var engine_force_value : float = 40.0

var _steer_target: float = 0.0

func _physics_process(delta: float):
	_steer_target = Input.get_axis(&"turn_right", &"turn_left")
	steering = _steer_target#move_toward(steering, _steer_target, STEER_SPEED * delta)
	
	var speed := linear_velocity.length()

	if Input.is_action_pressed(&"accelerate"):
		engine_force = engine_force_value
	else:
		engine_force = .0
		
	if Input.is_action_pressed(&"reverse"):
		brake = BRAKE_STRENGTH
	else:
		brake = .0 
