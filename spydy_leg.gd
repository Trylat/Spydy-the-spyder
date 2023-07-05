#@tool

extends Node2D

const min_dist = 50

@onready var join0 = $join0
@onready var join1 = $join0/join1
@onready var join2 = $join0/join1/join2
@onready var tip = $join0/join1/join2/tip

@onready var lineUpper = Line2D.new()
@onready var lineMiddle = Line2D.new()
@onready var lineLower = Line2D.new()

var len_upper = 0
var len_middle = 0
var len_lower = 0

var join0_position = 0
var join1_position = 0
var join2_position = 0
var tip_position = 0

@export var flipped = true
@export var ik_target : Marker2D

func _ready():
	len_upper = abs(join1.position.x)
	len_middle = abs(join2.position.x)
	len_lower = abs(tip.position.x)
	
	add_child(lineUpper)
	add_child(lineMiddle)
	add_child(lineLower)
	
	lineUpper.default_color = Color(1, 0, 0)  # Couleur blanche
	lineMiddle.default_color = Color(0, 1, 0)  # Couleur blanche
	lineLower.default_color = Color(0, 0, 1)  # Couleur blanche
	
	if flipped:
		join0.get_node("Sprite").flip_v = true
		join1.get_node("Sprite").flip_v = true
		join2.get_node("Sprite").flip_v = true
	update_lines()

func _process(delta):
	update_ik(ik_target.global_position)
	join0_position = join0.global_position
	join1_position = join1.global_position
	join2_position = join2.global_position
	tip_position = tip.global_position
	update_lines()
	

func update_ik(target_pos):
	
	var offset = target_pos - global_position
	var distance_to_target = offset.length()
	if distance_to_target < min_dist:
		offset = (offset / distance_to_target) * min_dist
		distance_to_target = min_dist
	var base_rotation = offset.angle()
	var len_total = len_lower + len_middle + len_upper
	var len_dummy_side = (len_upper + len_middle) * clamp(distance_to_target / len_total, 0.0, 1.0)
	
	var base_angle = sss_cal(len_dummy_side, len_lower, distance_to_target)
	var next_angle = sss_cal(len_upper, len_middle, len_dummy_side)
	
	join0.rotation = base_angle.B + next_angle.B + base_rotation
	join1.rotation = next_angle.C
	join2.rotation = base_angle.C + next_angle.A 
	
	
func sss_cal(side_a, side_b, side_c):
	if side_c >= side_a + side_b:
		return{"A":0, "B":0, "C":0}
	var angle_a = law_of_cos(side_b, side_c, side_a)
	var angle_b = law_of_cos(side_c, side_a, side_b) + PI
	var angle_c = -angle_a - angle_b + PI
	
	if flipped:
		angle_a = -angle_a
		angle_b = -angle_b
		angle_c = -angle_c
	
	return{"A": angle_a, "B":angle_b, "C":angle_c}
	
func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0  
	return acos( (a * a + b * b - c * c) / (2 * a * b) )


func update_lines():
	var start_point_upper = join0_position
	var start_point_middle = join1_position
	var start_point_lower = join2_position
	
	var endPointUpper = join1_position
	var endPointMiddle = join2_position
	var endPointLower = tip_position
	
	lineUpper.points = [start_point_upper, endPointUpper]
	lineMiddle.points = [start_point_middle, endPointMiddle]
	lineLower.points = [start_point_lower, endPointLower]
	
	lineUpper.width = 2
	lineMiddle.width = 2
	lineLower.width = 2
	
