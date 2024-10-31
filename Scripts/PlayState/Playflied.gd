extends Node3D

@onready var PlayState = $".."
@onready var Ypos = $HitObjects

@onready var HODown = $"4k/Down/HitObjects"
@onready var HOUp = $"4k/Up/HitObjects"

@onready var Left = get_node("4k/Left/HitObjects")
@onready var Down = get_node('4k/Down/HitObjects')
@onready var Up = get_node('4k/Up/HitObjects')
@onready var Right = get_node("4k/Right/HitObjects")

@export var bpm : float = 180
var time_per_beat = bpm / 60
var current_beat = 1
var current_time = 0

@onready var MusicBeatState = $"../BeatMusic"

var left_held = false
var down_held = false
var up_held = false
var right_held = false

var Chart : Dictionary = { # ID: [column, song position in ms, grid position, hold]
	1: [0, 2000, null, 0, false],
	2: [1, 1000, null, 0, false],
	3: [2, 1500, null, 0, false],
}

var song_time : float

func _ready():
	generateUnspawn()
	stepManiaScroll(Vector3(1, -1, 1), Vector3(1.25, -1.25, 1.25))
	
func _process(delta):
	Scroll(delta,PlayState.scrollSpeed)
	#HitObject()
	checkHit()
	
	#beatCount(delta)

func generateUnspawn():
	if not Chart.is_empty():
		for key in Chart:
			var note_data = Chart[key]
			var column = note_data[0]
			var pos_in_ms = note_data[1]
			var is_hold = note_data[3] != 0
			
			instanceSpawn(note_data, column, pos_in_ms, is_hold)

# Modificado para que devuelva la instancia de la nota creada
func instanceSpawn(note_data, column: int, pos_in_ms: int, is_hold: float):
	if column == 0:
		var left = Sprite3D.new()
		left.name = str(note_data)
		left.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/1.png")
		left.pixel_size = 0.5
		Left.add_child(left)
	elif column == 1:
		var down = Sprite3D.new()
		down.name = str(note_data)
		down.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/2.png")
		down.pixel_size = 0.5
		Down.add_child(down)
	elif column == 2:
		var up = Sprite3D.new()
		up.name = str(note_data)
		up.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/3.png")
		up.pixel_size = 0.5
		Up.add_child(up)
	elif column == 3:
		var right = Sprite3D.new()
		right.name = str(note_data)
		right.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/4.png")
		right.pixel_size = 0.5
		Right.add_child(right)

# Función que llama a scrollMovement para cada nota en notes_data
func Scroll(delta: float, ScrollSpeed: float) -> void:
	
	if not Chart.is_empty():
		for key in Chart:
			var note_data = Chart[key]
			var column = note_data[0]
			var pos_in_ms = note_data[1]
			
			scrollMovement(delta, ScrollSpeed, column, pos_in_ms)

# Mueve cada nota restando al eje Y
func scrollMovement(delta: float, scrollSpeed: float, column : int, pos_in_ms : int) -> void:
	song_time = MusicBeatState.get_playback_position()
	var song_time_ms = round(song_time * 1000)
	print(song_time_ms)
	
	if Left.get_child_count() > 0 and column == 0:
		for child in Left.get_children(0):
			child.position.y = $"4k/Left/Receptor/Left".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
	
	if Down.get_child_count() > 0 and column == 1:
		for child in Down.get_children(0):
			child.position.y = $"4k/Down/Receptor/Down".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
			
	if Up.get_child_count() > 0 and column == 2:
		for child in Up.get_children(0):
			child.position.y = $"4k/Up/Receptor/Up".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
			
	if Right.get_child_count() > 0 and column == 3:
		for child in Right.get_children(0):
			child.position.y = $"4k/Right/Receptor/Right".position.y + (pos_in_ms - song_time_ms) * scrollSpeed

func stepManiaScroll(scaleHO: Vector3, scale: Vector3):
	if PlayState.StepManiaScroll == true:
		self.scale = scale
		$"4k/Down/Receptor/UpDown".scale = scaleHO
		$"4k/Down/Receptor/DownDown".scale = scaleHO
		$"4k/Up/Receptor/UpUp".scale = scaleHO
		$"4k/Up/Receptor/DownUp".scale = scaleHO
		
		for child in Down.get_children():
			child.scale = scaleHO
				
		for child in Up.get_children(0):
			child.scale = scaleHO
	
func checkHit():
	if PlayState.LeftActive:
		if not left_held:
			LeftHitObject()
			left_held = true
	elif not PlayState.LeftActive:
		left_held = false
	
	if PlayState.DownActive:
		if not down_held:
			DownHitObject()
			down_held = true
	elif not PlayState.DownActive:
		down_held = false
		
	if PlayState.UpActive:
		if not up_held:
			UpHitObject()
			up_held = true
	elif not PlayState.UpActive:
		up_held = false
		
	if PlayState.RightActive:
		if not right_held:
			RightHitObject()
			right_held = true
	elif not PlayState.RightActive:
		right_held = false
	
func LeftHitObject() -> void:
	if $"4k/Left/HitObjects".get_child_count() > 0:
		$"4k/Left/HitObjects".get_child(0).queue_free()
			
func DownHitObject() -> void:
	if $"4k/Down/HitObjects".get_child_count() > 0:
		$"4k/Down/HitObjects".get_child(0).queue_free()
	
func UpHitObject() -> void:
	if $"4k/Up/HitObjects".get_child_count() > 0:
		$"4k/Up/HitObjects".get_child(0).queue_free()

func RightHitObject() -> void:
	if $"4k/Right/HitObjects".get_child_count() > 0:
		$"4k/Right/HitObjects".get_child(0).queue_free()

func beatCount(delta) -> void:
	if MusicBeatState.playing:
		current_time += (delta * 8)
		current_beat = current_time / time_per_beat
		current_beat = round(current_beat)
	
		print("Beat:", current_beat)
