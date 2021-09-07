extends Spatial

export var index = 0
onready var player:Spatial = get_node("/root/Level/Player")

func _ready():
	visible = false
	#if (player.checkpoint_ind < index): activate()
	pass

func activate():
	player.checkpoint_pos = to_global(Vector3.ZERO)
	player.checkpoint_ind = index
	player.checkpoint_rot = player.rotation
	print("Checkpoint is now ", player.checkpoint_pos, " #", player.checkpoint_ind, " @", player.time)

func _on_Area_body_entered(body:Spatial):
	if (body != player): return
	if (player.checkpoint_ind >= index): return
	activate()
	pass
