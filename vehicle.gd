@abstract
class_name Vehicle
extends Node3D

#limits the speed to allow a smooth arrival within a radius
@export var MAX_SPEED: float = 1000
@export var ARRIVE_RADIUS: float = 2
#limits the force to allow huge forces behaviors: the vehicle can reach a maxforce at the end
@export var MAX_FORCE: float = 1000

#to apply status buff and debuff to vehicle
var speed_multiplier: float = 1.0

#target position is updated and changed by the controller who is the brain/soul of the vehicle...
var desired_velocity: Vector3 = Vector3.ZERO
var steer_force: Vector3 = Vector3.ZERO
var is_active = false

#...our vehicle  is stupid as possible: follow a target position arriving at location with a sterring behaviour
#this generally computes the seeking towards a target: at the end it will apply a force toward the target
func seek(target: Vector3):
	desired_velocity = target - get_vehicle_global_position()
	
	if(desired_velocity.length_squared() < ARRIVE_RADIUS*ARRIVE_RADIUS):
		#this ensure an arrive at target without bouncing
		var arrive_magnitude = lerp(0.0, MAX_SPEED, desired_velocity / ARRIVE_RADIUS)
		desired_velocity.limit_length(arrive_magnitude)
	else:
		desired_velocity.limit_length(MAX_SPEED)
	
	#this is used for TOKEN vehicle to handle the speed
	desired_velocity*= speed_multiplier
	
	#Reynold's formula
	steer_force = desired_velocity - get_current_velocity()
	steer_force.limit_length(MAX_FORCE)
	set_steer_force(steer_force)

@abstract func get_current_force() -> float
@abstract func get_current_velocity() -> Vector3
@abstract func set_steer_force(steering_force: Vector3)
@abstract func get_vehicle_global_position() -> Vector3

func apply_speed_multiplier(duration: float, new_multiplier_value: float):
	speed_multiplier = new_multiplier_value
	#var tween := create_tween()
	#tween.tween_interval(duration)
	#tween.tween_callback(func(): )
	create_tween().tween_callback(func(): speed_multiplier= 1.0).set_delay(new_multiplier_value)
