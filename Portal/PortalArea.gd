extends Area

onready var portal:Spatial = get_node("../..")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PortalArea_body_entered(body):
	portal.on_portal_area_enter(body)
	pass # Replace with function body.


func _on_PortalArea_body_exited(body):
	portal.on_portal_area_exit(body)
	pass # Replace with function body.
