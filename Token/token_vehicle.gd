extends Area3D

@export var duration: float = 2.0
@export var speed_multiplier: float = 1.0
@export var destroy_on_pickup: bool = true

func _ready():
	
	if speed_multiplier<0:
		$CollisionShape3D.debug_color = Color.DARK_RED

func _process(delta):
	var cam := get_viewport().get_camera_3d()
	if cam:
		$Sprite3D.look_at(cam.global_position, Vector3.UP)
		
func _on_area_entered(area):
	print(area)
	pass # Replace with function body.

func _on_body_entered(body):
	var vehicle = body.get_parent()
	if vehicle is Vehicle:
		vehicle.apply_speed_multiplier(duration, speed_multiplier)
		if destroy_on_pickup:
			queue_free()
