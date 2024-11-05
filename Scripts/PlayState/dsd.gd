extends Node3D

@onready var sprite = $"../Sprite3D"

func _ready():
	print(sprite.position.y)
