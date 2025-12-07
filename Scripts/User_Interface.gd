extends CanvasLayer


var Wishvel1 : Vector2 = Vector2.ZERO
var Wishvel2 : Vector2 = Vector2.ZERO
@export var InitialPosP1 : Vector2
@export var InitialPosP2 : Vector2

@onready var P1Joystick: MeshInstance2D = $PanelContainer/P1Joystick
@onready var P2Joystick: MeshInstance2D = $PanelContainer/P2Joystick

func JoystickInput():
	Wishvel1 = Vector2.ZERO
	# Définition des inputs
	if Input.is_action_pressed("forward 1"):
		Wishvel1.y -= 1
	if Input.is_action_pressed("backward 1"):
		Wishvel1.y += 1
	if Input.is_action_pressed("left 1"):
		Wishvel1.x -= 1
	if Input.is_action_pressed("right 1"):
		Wishvel1.x += 1
		
	 #Normalise la direction
	Wishvel1 = Wishvel1.normalized()
	
	Wishvel2 = Vector2.ZERO
	# Définition des inputs
	if Input.is_action_pressed("forward 2"):
		Wishvel2.y -= 1
	if Input.is_action_pressed("backward 2"):
		Wishvel2.y += 1
	if Input.is_action_pressed("left 2"):
		Wishvel2.x -= 1
	if Input.is_action_pressed("right 2"):
		Wishvel2.x += 1
		
	 #Normalise la direction
	#Wishvel2 = Wishvel2.normalized()
	
func _process(delta: float) -> void:
	JoystickInput()
	VirtualJoy()

func VirtualJoy():	
	if Wishvel1.length() > 0.1:
		P1Joystick.position = InitialPosP1 + Vector2(Wishvel1.x, Wishvel1.y) * 20
	else:
		P1Joystick.position = InitialPosP1
		
	if Wishvel2.length() > 0.1:
		P2Joystick.position = InitialPosP2 + Vector2(Wishvel2.x, Wishvel2.y) * 20
	else:
		P2Joystick.position = InitialPosP2
