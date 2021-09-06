tool
extends Spatial

func _ready():
	rotation = Vector3.ZERO
	rotate_x(deg2rad(-48))
	rotate_y(deg2rad(42+180))
	#print("hi1", rotation)
