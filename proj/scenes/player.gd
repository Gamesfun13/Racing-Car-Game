extends KinematicBody2D

var velocity=Vector2(0,0);
var max_speed=400;
var accelaration=100
var deccelaration=10
var flip=false
var rot=0
var prev_inputx:int=1
var prev_inputxV:Vector2=Vector2(1,0)
var spriteframe=0
var floorN=Vector2(0,-1)
var n:Vector2
var f:Vector2=Vector2.ZERO
var input_vec=Vector2.ZERO;
onready var Pos=get_parent().get_node("Position2D")
onready var sprite=$Sprite
var collision:KinematicCollision2D=null

func _ready():
	rotation =0
	update()
func _draw():
	var v=f
	draw_line(Vector2(0,0),100*v,Color(1,0,0))
	draw_line(Vector2(0,0),velocity,Color(0,1,0))
	draw_line(Vector2(0,0),100*input_vec,Color(0,0,1))
	draw_line(Vector2(0,0),100*get_floor_normal(),Color(0,0,0))
# warning-ignore:unused_argument
func _physics_process(delta):
	#if is_on_floor():
	input_vec.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vec.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	input_vec=input_vec.rotated(self.rotation)
	input_vec=input_vec.normalized()
	if input_vec!=Vector2.ZERO :
		velocity=velocity.move_toward(input_vec*max_speed,accelaration)
	else:
		velocity=velocity.move_toward(Vector2.ZERO,deccelaration)
	update()
	if Pos.get_global_position().y > self.get_global_position().y:
		velocity.y=velocity.y +deccelaration
		var rotDec=get_rotation_degrees()
		if !is_on_floor() and prev_inputxV.x>0:
			set_rotation_degrees(rotDec+1)
		elif !is_on_floor()  and prev_inputxV.x<0:
			set_rotation_degrees(rotDec-1)
		else:
			set_rotation_degrees(0)
#		elif rotDec<0:
#			set_rotation_degrees(rotDec+1)
#		elif rotDec>0:
#			set_rotation_degrees(rotDec-1)
	if input_vec.x<0:
		spriteframe=1
		prev_inputxV=Vector2(-1,0)
	elif input_vec.x>0:
		spriteframe=0
		prev_inputxV=Vector2(1,0)

	for i in get_slide_count():
		collision=get_slide_collision(i)
		if collision:
			if collision.normal.x>0:
				rot=rad2deg(acos(Vector2(0,-1).dot(collision.normal)))
				if rot<60:
					set_rotation_degrees(rot)
					if Input.is_action_pressed("ui_left"):
						input_vec=Vector2(-1,-1).normalized()
						velocity=velocity.move_toward(input_vec*(max_speed+450),accelaration)
			elif collision.normal.x<0 :
				rot=rad2deg(acos(Vector2(0,-1).dot(collision.normal)))
				if rot<60:
					set_rotation_degrees(-rot)
					if Input.is_action_pressed("ui_right"):
						input_vec=Vector2(1,-1).normalized()
						velocity=velocity.move_toward(input_vec*(max_speed+450),accelaration)
	sprite.set_frame(spriteframe)
	
	move_and_slide(velocity,Vector2(0,-1),0.2)
	
