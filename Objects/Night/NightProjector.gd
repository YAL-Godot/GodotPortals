extends Spatial

onready var viewport = $Viewport
onready var viewCamera:Camera = $Viewport/Camera
onready var player:Player = get_node("/root/Level/Player")
onready var playerCamera:Camera = player.get_node("Camera")
onready var icosphere:MeshInstance = $Icosphere

func _ready():
	pass # Replace with function body.

func _process(delta):
	viewport.size = get_viewport().size
	viewCamera.translation = playerCamera.to_global(Vector3.ZERO)
	viewCamera.rotation.y = player.rotation.y
	viewCamera.rotation.x = playerCamera.rotation.x
	
	icosphere.rotate_x(delta * 1)
	icosphere.rotate_y(delta * 0.5)
	icosphere.rotate_z(delta * 0.5)
	pass
