@abstract
class_name Vehicle
extends Node3D

#limits the speed to allow a smooth arrival
@export var MAX_SPEED: float = 1000
#limits the force to allow huge forces behaviors: the vehicle can reach a maxforce at the end
@export var MAX_FORCE: float = 1000
@export var ARRIVE_RADIUS: float = 2

#target position is updated and changed by the controller who is the brain/soul of the vehicle...
var target_position: Vector3 = Vector3.ZERO
var desired_velocity: Vector3 = Vector3.ZERO
var steer_force: Vector3 = Vector3.ZERO
var is_active = false

#...our vehicle  is stupid as possible: follow a target position arriving at location with a sterring behaviour
func _physics_process(delta: float):
	if is_active:
		seek(target_position)

#this generally applies a force toward a target position
func seek(target: Vector3):
	desired_velocity = target - get_vehicle_global_position()
	
	if(desired_velocity.length_squared() < ARRIVE_RADIUS*ARRIVE_RADIUS):
		#this ensure an arrive at target without bouncing
		var arrive_magnitude = lerp(0.0, MAX_SPEED, desired_velocity / ARRIVE_RADIUS)
		desired_velocity.limit_length(arrive_magnitude)
	else:
		desired_velocity.limit_length(MAX_SPEED)
	
	#Reynold's formula
	steer_force = desired_velocity - get_current_velocity()
	steer_force.limit_length(MAX_FORCE)
	set_steer_force(steer_force)

@abstract func get_current_force() -> float
@abstract func get_current_velocity() -> Vector3
@abstract func set_steer_force(steering_force: Vector3)
@abstract func get_vehicle_global_position() -> Vector3
