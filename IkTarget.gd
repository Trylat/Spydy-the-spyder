extends Marker2D

@export var step_target: Node2D
@export var step_distance = 50.0
@export var adjasent_leg : Node2D
@export var diag_oposite_leg : Node2D



var isSteping = false

func _process(delta):
	if !isSteping && !adjasent_leg.isSteping && (global_position.distance_to(step_target.global_position)) > step_distance:
		step()
		#Sdiag_oposite_leg.step()

func step():
	isSteping = true
	var target_pos = step_target.global_position
	var half_way = (global_position + step_target.global_position)/2
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + Vector2(0.5, -20.0), 0.1)
	t.tween_property(self, "global_position", target_pos, 0.1)
	t.tween_callback(func() : isSteping = false)
