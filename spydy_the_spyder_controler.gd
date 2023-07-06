extends Node2D

@export var x_speed = 200
@export var y_speed = 100
@export var ground_offset = 5.0

@onready var f1_leg = $"Front IkTarget/FrontIkTarget"
@onready var f2_leg = $"Front IkTarget/FrontIkTarget2"
@onready var f3_leg = $"Front IkTarget/FrontIkTarget3"
@onready var f4_leg = $"Front IkTarget/FrontIkTarget4"

@onready var b1_leg = $"Back IkTarget/BackIkTarget"
@onready var b2_leg = $"Back IkTarget/BackIkTarget2"
@onready var b3_leg = $"Back IkTarget/BackIkTarget3"
@onready var b4_leg = $"Back IkTarget/BackIkTarget4"

@onready var low_check = $LowCheck
@onready var up_check = $UpCheck


func _process(delta):
	_handle_mouvement(delta)
	
func _handle_mouvement(delta):
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity = Vector2.LEFT * x_speed
	if Input.is_action_pressed("ui_right"):
		velocity = Vector2.RIGHT * x_speed
		
	if up_check.is_colliding():
		velocity.y = -y_speed
	else:
		velocity.y = y_speed
	
	position += velocity * delta
	
