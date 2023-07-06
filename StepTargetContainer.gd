extends Node2D

@export var offset = 30.0

@onready var parent = get_parent()
@onready var previous_posision = parent.global_position

func _process(delta):
	var velocity = parent.global_position - previous_posision
	global_position = parent.global_position + velocity * offset
	
	previous_posision = parent.global_position
