extends Node3D

@export var mode = 4
@export var scrollSpeed : float = 0.1
@export var StepManiaScroll = false

var Rating : Dictionary = {
	"score": 0,
	"hits": 0,
	"Fantastic": 0,
	"Perfect": 0,
	"Great": 0,
	"Good": 0,
	"Bad": 0, # You dont recovery health there
	"miss": 0
}

var ratingValue : float = 0.0

# 4k:

# Up:
@onready var UpLeft = $"Playflied/4k/Left/Receptor/UpLeft"
@onready var UpDown = $"Playflied/4k/Down/Receptor/UpDown"
@onready var UpUp = $"Playflied/4k/Up/Receptor/UpUp"
@onready var UpRight = $"Playflied/4k/Right/Receptor/UpRight"

#Down:
@onready var DownLeft = $"Playflied/4k/Left/Receptor/DownLeft"
@onready var DownDown = $"Playflied/4k/Down/Receptor/DownDown"
@onready var DownUp = $"Playflied/4k/Up/Receptor/DownUp"
@onready var DownRight = $"Playflied/4k/Right/Receptor/DownRight"

#active:
var LeftActive = false
var DownActive = false
var UpActive = false
var RightActive = false

func _process(delta):
	inputCheck()
	
func inputCheck() -> void:
	if Input.is_action_pressed("Left"):
		UpLeft.visible = false
		DownLeft.visible = true
		LeftActive = true
	else:
		UpLeft.visible = true
		DownLeft.visible = false
		LeftActive = false
		
	if Input.is_action_pressed("Down"):
		UpDown.visible = false
		DownDown.visible = true
		DownActive = true
	else:
		UpDown.visible = true
		DownDown.visible = false
		DownActive = false
		
	if Input.is_action_pressed("Up"):
		UpUp.visible = false
		DownUp.visible = true
		UpActive = true
	else:
		UpUp.visible = true
		DownUp.visible = false
		UpActive = false
		
	if Input.is_action_pressed("Right"):
		UpRight.visible = false
		DownRight.visible = true
		RightActive = true
	else:
		UpRight.visible = true
		DownRight.visible = false
		RightActive = false
		
