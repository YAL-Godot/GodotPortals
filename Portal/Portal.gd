class_name Portal
extends Spatial

export(NodePath) var portalPath
var otherPortal:Spatial = null
onready var mesh:MeshInstance = $PortalMesh
onready var meshMaterial:Material = mesh.mesh.surface_get_material(0)
onready var mesh2:MeshInstance = $PortalMesh2
onready var viewport:Viewport = $Viewport
onready var viewCamera:Camera = $Viewport/Camera
onready var player:Player = get_node("/root/Level/Player")
onready var playerCamera:Camera = player.get_node("Camera")

func get_global_pos(spat:Spatial)->Vector3:
	return spat.to_global(Vector3.ZERO)

func get_global_rotY(spat:Spatial)->float:
	var v0 = spat.to_global(Vector3.ZERO)
	var v1 = spat.to_global(Vector3.FORWARD)
	var r = atan2(v0.x-v1.x, v0.z-v1.z)
	#print(name, v0, v1, r)
	return r

func _ready():
	$Arrow.visible = false
	#print(meshMaterial)
	player.portals.append(self)
	if (otherPortal == null):
		otherPortal = get_node(portalPath)
		#print(portalPath, otherPortal)
		if (otherPortal != null):
			if (otherPortal.otherPortal == null):
				otherPortal.otherPortal = self
		else:
			print(name, ": Couldn't find portal! `", portalPath, "`")
	pass

func update_camera(just_teleported):
	if (otherPortal == null): return
	var p1 = get_global_pos(self)
	var p2 = get_global_pos(otherPortal)
	var pp = get_global_pos(playerCamera)
	viewCamera.translation = pp - p1 + p2
	viewCamera.rotation.y = player.rotation.y
	viewCamera.rotation.x = playerCamera.rotation.x
	if just_teleported and false:
		#mesh.mesh.surface_set_material(0, null)
		#mesh2.mesh.surface_set_material(0, null)
		print(name,
			" pp=", pp,
			" p1=", p1,
			" p2=", p2,
			" ofs=", pp-p1,
			" out=", viewCamera.translation,
			" ")
	if (Input.is_action_just_pressed("debug_dump")):
		#print(name, " ", r1, " ", r2)
		#print(name, " r1 ", r2, " ", get_global_rotY(otherPortal))
		#print(name, " r2 ", r1, " ", get_global_rotY(self))
		#print(name, offset, viewCamera.translation)
		pass
	#mesh.visible = !enable_print
	#mesh2.visible = !enable_print
	

func _process(_delta):
	viewport.size = get_viewport().size
	pass

func check_warp(_delta = 0.01):
	var p1 = get_global_pos(self)
	var p2 = get_global_pos(otherPortal)
	var offset = to_local(get_global_pos(player))
	if (offset.z > 0.01):
		#if (player.velocity.length() < 0.05 || true):
		#	var out = to_global(Vector3(0, 0, -1))
		#	out = out.normalized() * 0.1 * delta
		#	player.velocity += out
		return
	#var p0 = player.translation
	var d = Vector3(0, 0.001, 0.01).rotated(Vector3.UP, get_global_rotY(otherPortal))
	player.translation += p2 - p1 + d
	player.portal = null
	player.update_portals(true)

func on_portal_area_enter(body):
	if (body.get_parent_spatial() == player):
		player.portal = self
		#print("player.portal is now ", self)
		check_warp()
	#print(body)
	pass

func on_portal_area_exit(body):
	if (body.get_parent_spatial() == player):
		if player.portal == self:
			#print("player.portal is now null")
			player.portal = null
