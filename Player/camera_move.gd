extends Node3D

@export var move_speed := 20.0
@export var edge_margin := 20
@export var rotate_speed := 1.5
@export var zoom_speed := 5.0
@export var min_zoom := 5.0
@export var max_zoom := 40.0

var target_yaw := 0.0

#@onready var pivot := $Pivot
@onready var camera := $Persp

func _ready():
	target_yaw = rotation.y
	
func _process(delta):
	_handle_keyboard_move(delta)
	_handle_edge_scroll(delta)
	
	rotation.y = lerp_angle(rotation.y, target_yaw, delta * 8.0)

func _unhandled_input(event):
	_handle_rotation(event)
	_handle_zoom(event)
	
func _handle_edge_scroll(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size

	var dir = Vector3.ZERO

	if mouse_pos.x < edge_margin:
		dir.x -= 1
	elif mouse_pos.x > viewport_size.x - edge_margin:
		dir.x += 1

	if mouse_pos.y < edge_margin:
		dir.z -= 1
	elif mouse_pos.y > viewport_size.y - edge_margin:
		dir.z += 1

	if dir != Vector3.ZERO:
		# Convert screen input to camera-relative world movement
		var right :Vector3= camera.transform.basis.x
		var forward :Vector3= camera.transform.basis.z  # camera forward
		
		dir = (right * dir.x + forward * dir.z)
		dir.y = 0
		dir = dir.normalized()
		translate(dir * move_speed * delta)
		

func _handle_rotation(event):
	if Input.is_action_pressed("camera_rotate_left"):
		rotate_step(-1)
	elif Input.is_action_pressed("camera_rotate_right"):
		rotate_step(1)

func _handle_zoom(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.translate(Vector3(0, 0, -zoom_speed))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.translate(Vector3(0, 0, zoom_speed))

		camera.transform.origin.z = clamp(
			camera.transform.origin.z,
			-min_zoom,
			-max_zoom
		)

func _handle_keyboard_move(delta):
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):
		input_dir.z -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.z += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1

	if input_dir != Vector3.ZERO:
		input_dir = input_dir.normalized()
		translate((transform.basis * input_dir) * move_speed * delta)

func rotate_step(direction: int):
	var step := deg_to_rad(45)
	target_yaw += direction * step
	target_yaw = wrapf(target_yaw, -PI, PI)
