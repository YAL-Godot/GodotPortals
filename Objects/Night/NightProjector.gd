extends Spatial

onready var viewport = $Viewport
onready var viewCamera:Camera = $Viewport/Camera
onready var player:Player = get_node("/root/Level/Player")
onready var playerCamera:Camera = player.get_node("Camera")
onready var icosphere:MeshInstance = $Icosphere
onready var icosphereFB:MeshInstance = $IcosphereFB
onready var visibilityNotifier:VisibilityNotifier = $VisibilityNotifier
onready var playerDetector:PlayerDetector = get_node_or_null("PlayerDetector")
onready var playerDetector2:PlayerDetector = get_node_or_null("PlayerDetector2")

func _ready():
	pass # Replace with function body.

func is_visible():
	if playerDetector == null: return false
	return (playerDetector == null or playerDetector.has_player
		or playerDetector2 != null and playerDetector2.has_player
	) and visibilityNotifier.is_on_screen()

func _process(delta):
	viewport.size = get_viewport().size
	var vis = is_visible()
	icosphere.visible = vis
	icosphereFB.visible = not vis
	if vis:
		viewCamera.translation = playerCamera.to_global(Vector3.ZERO)
		viewCamera.rotation.y = player.rotation.y
		viewCamera.rotation.x = playerCamera.rotation.x
	
	icosphere.rotate_x(delta * 1)
	icosphere.rotate_y(delta * 0.5)
	icosphere.rotate_z(delta * 0.5)
	icosphereFB.rotation = icosphere.rotation
	
	if (Input.is_action_just_pressed("debug_dump")):
		print(get_path(), ".visible = ", vis)
		if (playerDetector != null): print("pd.has_player = ", playerDetector.has_player)
	pass
