# Taken from First Person Exploration Template, a little janky
class_name Player
extends KinematicBody

export var gravity = -30.0
export var walk_speed = 8.0
export var run_speed = 16.0
export var jump_speed = 9.8
export var mouse_sensitivity = 0.003
export var acceleration = 9.0
export var friction = 10.0
export var fall_limit = -10.0

onready var camera:Camera = $Camera

var playable = true
var dir = Vector3.ZERO
var velocity = Vector3.ZERO
var checkpoint_ind = -1
var checkpoint_pos = Vector3.ZERO
var checkpoint_rot = Vector3.ZERO
var mouse_capture = true
var time = 0
var time_since_ground = 0
var portal:Spatial = null

var portals:Array = []
func update_portals(enable_print):
	for p in portals:
		p.update_camera(enable_print)

func _ready():
	checkpoint_pos = translation
	checkpoint_rot = rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera.near = 0.00001
	#print(camera.near)

func _physics_process(delta):
	#var old_time = time
	time += delta
	
	#translation += Vector3(cos(time) - cos(old_time), 0, sin(time) - sin(old_time)) * 0.2
	
	if Input.is_action_just_pressed("mouse_toggle"):
		mouse_capture = !mouse_capture
		if mouse_capture:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	dir = Vector3.ZERO
	var basis = global_transform.basis
	if Input.is_action_pressed("move_forward"):
		dir -= basis.z
	if Input.is_action_pressed("move_back"):
		dir += basis.z
	if Input.is_action_pressed("move_left"):
		dir -= basis.x
	if Input.is_action_pressed("move_right"):
		dir += basis.x
	dir = dir.normalized()

	var speed = walk_speed
	if is_on_floor():
		#this prevents you from sliding without messing up the is_on_ground() check
		velocity.y += gravity * delta / 100.0
		#if Input.is_action_pressed("run"):
		#	speed = run_speed
		time_since_ground = 0
	else:
		time_since_ground += delta
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump"):
		#print(time_since_ground)
		if time_since_ground < 0.3:
			time_since_ground = 1
			velocity.y = jump_speed

	var hvel = velocity
	hvel.y = 0.0

	var target = dir * speed
	var accel
	if dir.dot(hvel) > 0.0:
		accel = acceleration
	else:
		accel = friction
	hvel = hvel.linear_interpolate(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	if playable:
		velocity = move_and_slide(velocity, Vector3.UP, true)

	#prevents infinite falling
	if translation.y < fall_limit or Input.is_action_just_pressed("reset"):
		#playable = false
		#fader._reload_scene()
		translation = checkpoint_pos
		rotation = checkpoint_rot
		velocity = Vector3.ZERO
		print("reverting: ", checkpoint_pos)
	
	update_portals(false)
	if (portal != null): portal.check_warp(delta)

func _unhandled_input(event):
	if event is InputEventMouseButton and mouse_capture and OS.has_feature('JavaScript'):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and playable:
		if !mouse_capture: return
		rotate_y(-event.relative.x * mouse_sensitivity)
		var amt_y = -event.relative.y * mouse_sensitivity
		camera.rotation.x = clamp(camera.rotation.x + amt_y, -PI*0.45, PI*0.45)
