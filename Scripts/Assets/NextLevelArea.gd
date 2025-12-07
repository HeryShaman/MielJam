extends Area2D

@export var NextLevel : String = ""

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Collision")
		if NextLevel != "":
			get_tree().change_scene_to_file(NextLevel)
