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

var Left_Child: int
var Down_Child: int
var Up_Child: int
var Right_Child: int

@export var rangeClick = 100

var Chart : Dictionary = { # ID: [column, song position in ms, grid position, hold, is hurt]
	0: [0, 3000, null, 0, false],
	1: [1, 2000, null, 0, false],
	2: [1, 1000, null, 0, false],
	3: [2, 2000, null, 0, false],
	4: [0, 2500, null, 0, false]
}

var song_time : float
var song_time_ms: int
@onready var scrollSpeed = PlayState.scrollSpeed

@onready var LeftReceptor = $"4k/Left/Receptor/Left"
@onready var DownReceptor = $"4k/Down/Receptor/Down"
@onready var UpReceptor = $"4k/Up/Receptor/Up"
@onready var RightReceptor = $"4k/Right/Receptor/Right"

func _ready():
	stepManiaScroll(Vector3(1, -1, 1), Vector3(1.25, -1.25, 1.25))
	generateUnspawn()
	
func _process(delta):
	song_time = MusicBeatState.get_playback_position()
	song_time_ms = round(song_time * 1000)
	
	Scroll(delta,scrollSpeed)
	#HitObject()
	#checkHit()
	
	#beatCount(delta)
	
	
func position_at_time_down(time: float) -> float:
	return Down.position.y * ((time - song_time_ms) * scrollSpeed)
	
var Left_Bool: bool = 1
var Down_Bool: bool = 1
var Up_Bool: bool = 1
var Right_Bool: bool = 1

func generateUnspawn():
	if not Chart.is_empty():
		for key in Chart:
			var note_data = Chart[key]
			var column = note_data[0]
			var pos_in_ms = note_data[1]
			var is_hold = note_data[3] != 0
			
			if column == 0:
				var new_position = $"4k/Left/Receptor/Left".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
				var last_position = 0.0
				if Left.get_child_count() > 0:
					last_position = Left.get_child(Left.get_child_count() - 1).position.y
				if new_position <= last_position:
					new_position = last_position + 10
				if Left_Bool:
					var left = Sprite3D.new()
					left.name = str(note_data)
					left.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/1.png")
					left.pixel_size = 0.5
					left.offset = Vector2(0, left.texture.get_height() / 2)
					left.position.y = new_position
					Left.add_child(left)
					#Left_Bool = 0
				
			
			print(Left.get_child_count())
			if column == 1:
				var down = Sprite3D.new()
				down.name = str(note_data)
				down.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/2.png")
				down.pixel_size = 0.5
				down.offset = Vector2(0, down.texture.get_height() / 2)
				Down.add_child(down)
				
				Down_Child = Down.get_child_count()
				
			if column == 2:
				var up = Sprite3D.new()
				up.name = str(note_data)
				up.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/3.png")
				up.pixel_size = 0.5
				Up.add_child(up)
			if column == 3:
				var right = Sprite3D.new()
				right.name = str(note_data)
				right.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/4.png")
				right.pixel_size = 0.5
				Right.add_child(right)

# Función que llama a scrollMovement para cada nota en notes_data
func Scroll(delta: float, scrollSpeed: float) -> void:
	if not Chart.is_empty():
		for key in Chart:
			var note_data = Chart[key]
			var column = note_data[0]
			var pos_in_ms = note_data[1]
			#print(song_time_ms)
			
			var two = Left.get_child(0)
			#print("First", Left.get_child(1).position)
			#print("Second",two.position)
			var D_child_count
			
			if Left.get_child_count() > 0:
				for child in Left.get_children(0):
					child.position.y -= (scrollSpeed * 200) * delta
		
			if Down.get_child_count() > 0:
				D_child_count = Down.get_child_count()
				for i in range(D_child_count):
					var child = Down.get_child(i)
					child.position.y = $"4k/Down/Receptor/Down".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
				
			if Up.get_child_count() > 0 and column == 2:
				for child in Up.get_children(0):
					child.position.y = $"4k/Up/Receptor/Up".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
				
			if Right.get_child_count() > 0 and column == 3:
				for child in Right.get_children(0):
					child.position.y = $"4k/Right/Receptor/Right".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
	
			var effective_range : float = rangeClick * (scrollSpeed * 25)
			if column == 0:
				if Left.get_child_count() > 0:
					for child in Left.get_children(0):
						if abs($"4k/Left/Receptor/Left".position.y - child.position.y) <= effective_range:
							if PlayState.LeftActive:
								if not left_held:
									LeftHitObject(effective_range, scrollSpeed)
									left_held = true
								elif not PlayState.LeftActive:
									left_held = false
	
	#elif column == 1:
		#for child in Down.get_children(0):
			#if abs($"4k/Down/Receptor/Down".position.y - child.position.y) <= effective_range:
				#if PlayState.DownActive:
					#if not down_held:
						#DownHitObject(effective_range, scrollSpeed)
						#down_held = true
				#elif not PlayState.DownActive:
					#down_held = false
	
			if column == 2:
				for child in Up.get_children(0):
					if abs($"4k/Up/Receptor/Up".position.y - child.position.y) <= effective_range:
						if PlayState.UpActive:
							if not up_held:
								UpHitObject(effective_range, scrollSpeed)
								up_held = true
							elif not PlayState.UpActive:
								up_held = false
					
			elif column == 3:
				for child in Right.get_children(0):
					if abs($"4k/Right/Receptor/Right".position.y - child.position.y) <= effective_range:
						if PlayState.RightActive:
							if not right_held:
								RightHitObject(effective_range, scrollSpeed)
								right_held = true
							elif not PlayState.RightActive:
								right_held = false
	
			MissHit(scrollSpeed)

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

	
func LeftHitObject(effective_range: float, scrollSpeed : float) -> void:
	if $"4k/Left/HitObjects".get_child_count() > 0:
		$"4k/Left/HitObjects".get_child(0).queue_free()
		HitRating(effective_range, scrollSpeed)
			
func DownHitObject(effective_range: float, scrollSpeed : float) -> void:
	if $"4k/Down/HitObjects".get_child_count() > 0:
		$"4k/Down/HitObjects".get_child(0).queue_free()
	#HitRating(effective_range, scrollSpeed)
	
func UpHitObject(effective_range: float, scrollSpeed : float) -> void:
	if $"4k/Up/HitObjects".get_child_count() > 0:
		$"4k/Up/HitObjects".get_child(0).queue_free()
	#HitRating(effective_range, scrollSpeed)
	
func RightHitObject(effective_range: float, scrollSpeed : float) -> void:
	if $"4k/Right/HitObjects".get_child_count() > 0:
		$"4k/Right/HitObjects".get_child(0).queue_free()
	#HitRating(effective_range, scrollSpeed)
	
func HitRating(effective_range: float, scrollSpeed: float):
	var Effective_M = 0.5 * (scrollSpeed * 25)
	var Effective_P = 1 * (scrollSpeed + 25)
	var Effective_G = 1.5 * (scrollSpeed + 25)
	var Effective_GO = 2 * (scrollSpeed + 25)
	var Effective_ME = 3 * (scrollSpeed + 25)
	var Effective_B = 4 * (scrollSpeed + 25)
	
	for child in Left.get_children(0):
		if not child.has_meta("Missed"):
			child.set_meta("Missed", false)
		
		if abs(LeftReceptor.position.y - child.position.y) <= Effective_M:
			print("Marvelous")
		elif abs(LeftReceptor.position.y - child.position.y) <= Effective_P:
			print("Perfect")
		elif abs(LeftReceptor.position.y - child.position.y) <= Effective_G:
			print("Great")
		elif abs(LeftReceptor.position.y - child.position.y) <= Effective_GO:
			print("Good")
		elif abs(LeftReceptor.position.y - child.position.y) <= Effective_ME:
			print("Meh")
		elif abs(LeftReceptor.position.y - child.position.y) <= Effective_B:
			print("Bad")
			
	for child in Down.get_children(0):
		if abs(DownReceptor.position.y - child.position.y) <= Effective_M:
			print("Marvelous")
		elif abs(DownReceptor.position.y - child.position.y) <= Effective_P:
			print("Perfect")
		elif abs(DownReceptor.position.y - child.position.y) <= Effective_G:
			print("Great")
		elif abs(DownReceptor.position.y - child.position.y) <= Effective_GO:
			print("Good")
		elif abs(DownReceptor.position.y - child.position.y) <= Effective_ME:
			print("Meh")
		elif abs(DownReceptor.position.y - child.position.y) <= Effective_B:
			print("Bad")
			
func MissHit(scrollSpeed: float):
	var Effective_Miss = 5 * (scrollSpeed + 25)
	if Left.get_child_count() > 0:
		for child in Left.get_children(0):
			if not child.has_meta("in_range"):
				child.set_meta("in_range", false)
			
			if abs(LeftReceptor.position.y - child.position.y) <= Effective_Miss:
				child.set_meta("in_range", true)
			elif abs(LeftReceptor.position.y - child.position.y) > Effective_Miss and child.get_meta("in_range"):
				print("Miss")
				child.set_meta("in_range", false)
	#for child in Down.get_children(0):
		#if not child.has_meta("in_range"):
			#child.set_meta("in_range", false)
		
		#if abs(DownReceptor.position.y - child.position.y) <= Effective_Miss:
			#child.set_meta("in_range", true)
		#elif abs(DownReceptor.position.y - child.position.y) > Effective_Miss and child.get_meta("in_range"):
			#print("Miss1")
			#child.set_meta("in_range", false)
			
	for child in Up.get_children(0):
		if not child.has_meta("in_range"):
			child.set_meta("in_range", false)
		
		if abs(UpReceptor.position.y - child.position.y) <= Effective_Miss:
			child.set_meta("in_range", true)
		elif abs(UpReceptor.position.y - child.position.y) > Effective_Miss and child.get_meta("in_range"):
			print("Miss2")
			child.set_meta("in_range", false)

func ShowRating():
	pass
	
func beatCount(delta) -> void:
	if MusicBeatState.playing:
		current_time += (delta * 8)
		current_beat = current_time / time_per_beat
		current_beat = round(current_beat)
	
		print("Beat:", current_beat)
