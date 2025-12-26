extends Area3D

@export var duration: float = 2.0
@export var velocity_multiplier: float = 1.0

func _ready():
	if velocity_multiplier<0:
		$CollisionShape3D.debug_color = Color.DARK_RED

func _on_area_entered(area):
	print (area)
	pass # Replace with function body.


func _on_body_entered(body):
	print(body.get_parent())
	pass # Replace with function body.
