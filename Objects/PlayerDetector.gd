class_name PlayerDetector
extends Area

var has_player = false
onready var player:Player = get_node("/root/Level/Player")

func _on_PlayerDetector_body_entered(body):
	if (body == player): has_player = true
	pass # Replace with function body.


func _on_PlayerDetector_body_exited(body):
	if (body == player): has_player = false
	pass # Replace with function body.
