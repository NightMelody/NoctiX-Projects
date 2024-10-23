extends Node3D

var initialScroll = 100.0

const DISTANCE_THRESHOLD_MS = 300  # Ejemplo: 300 ms
const UNITS_PER_SECOND = 10  # Cambia esto según tu escala de tiempo/distance

@onready var hit_objects = $HitObjects

@onready var PlayState = $".."
@onready var Ypos = $HitObjects

@onready var HODown = $HitObjects/Down
@onready var HOUp = $HitObjects/Up

@export var customXmod1: float = 0
@export var customXmod2: float = 0
@export var customXmod3: float = 0
@export var customXmod4: float = 0

var initial_positions = {}

func _ready():
	stepManiaScroll(Vector3(1, -1, 1), Vector3(1.25, -1.25, 1.25))
	"""for child in hit_objects.get_children():
		initial_positions[child.name] = []
		for sprite in child.get_children():
			if sprite is Sprite3D:  # Asegúrate de que sea un Sprite3D
				initial_positions[child.name].append(sprite.position.y)"""

func _process(delta):
	Scroll(delta,PlayState.scrollSpeed)
	HitObject()
	
"""func Scroll(delta: float, ScrollSpeed: float) -> void:
	var current_scroll_speed = ScrollSpeed
	var distance_scale = current_scroll_speed / initialScroll  # Escalado basado en la velocidad actual

	# Actualizar la posición de cada Sprite3D basándose en sus posiciones iniciales
	for child in hit_objects.get_children():
		for i in range(child.get_child_count()):
			var sprite = child.get_child(i)
			if sprite is Sprite3D:  # Asegúrate de que sea un Sprite3D
				var initial_position = initial_positions[child.name][i]
				sprite.position.y = initial_position - (distance_scale * delta * (initial_position - initial_positions[child.name][0]))  # Ajuste proporcional"""

func Scroll(delta: float, ScrollSpeed: float) -> void:
	$HitObjects/Left.position.y -= (ScrollSpeed + customXmod1) * delta
	$HitObjects/Down.position.y -= (ScrollSpeed + customXmod2) * delta
	$HitObjects/Up.position.y -= (ScrollSpeed + customXmod3) * delta
	$HitObjects/Right.position.y -= (ScrollSpeed + customXmod4) * delta
	

func stepManiaScroll(scaleHO: Vector3, scale: Vector3):
	if PlayState.StepManiaScroll == true:
		self.scale = scale
		$Up/Down.scale = scaleHO
		$Up/Up.scale = scaleHO
		$Down/Down.scale = scaleHO
		$Down/Up.scale = scaleHO
		
		for child in HODown.get_children():
			if child is Sprite3D:
				child.scale = scaleHO
				
		for child in HOUp.get_children():
			if child is Sprite3D:
				child.scale = scaleHO
	
func HitObject() -> void:
	
	if PlayState.LeftActive:
		for note in $HitObjects/Left.get_children():
			if note is Sprite3D:
				note.queue_free()
	
