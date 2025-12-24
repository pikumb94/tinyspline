extends Control

@export var vehicle_car : VehicleCar
@export var vehicle : Vehicle

@onready var speed_label = $VBoxContainer/Speed
@onready var rpm_label = $VBoxContainer/RPM
@onready var gear_label = $VBoxContainer/Gear

func _process(delta):
	if vehicle_car:
		speed_label.text = str(round(vehicle_car.speed * 3.6)) + " km/h"
		rpm_label.text = str(round(vehicle_car.motor_rpm)) + " rpm"
		gear_label.text = "Gear: " + str(vehicle_car.current_gear)

	if vehicle:
		speed_label.text = str(round(vehicle.get_current_velocity() * 3.6)) + " km/h"
		rpm_label.text = "Null" + " rpm"
		gear_label.text = "Gear: " + "Null"
