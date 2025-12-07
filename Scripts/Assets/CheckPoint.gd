extends Area2D

var IsChecked : bool = false
@onready var Anim : AnimationPlayer = $AnimationPlayer

func _on_body_entered(body):
	if body.is_in_group("Player"):
		IsChecked = true
		body.LastCheckPoint = body.global_position
		print("Collision")

func _process(delta: float) -> void:
	if IsChecked:
		Anim.play("Flag")
		await get_tree().create_timer(0.5).timeout
		Anim.seek(0.5)
	else:
		return
