extends PathFollow2D

@export var speed = 120.0
var asteroid

func _ready():
	var scene = preload("res://Scènes/Asteroids.tscn")
	asteroid = scene.instantiate()
	add_child(asteroid)
	asteroid.position = Vector2.ZERO

	loop = true

func _process(delta):
	progress += speed * delta
