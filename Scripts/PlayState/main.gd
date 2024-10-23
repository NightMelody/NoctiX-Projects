extends Node3D

@export var mode = 4
@export var scrollSpeed = 100
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
@onready var UpLeft = $Playflied/Up/Left
@onready var UpDown = $Playflied/Up/Down
@onready var UpUp = $Playflied/Up/Up
@onready var UpRight = $Playflied/Up/Right

#Down:
@onready var DownLeft = $Playflied/Down/Left
@onready var DownDown = $Playflied/Down/Down
@onready var DownUp = $Playflied/Down/Up
@onready var DownRight = $Playflied/Down/Right

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
		

