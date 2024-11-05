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

@onready var Scroll_system = preload("res://Scripts/PlayState/scroll.gd")

var left_held = false
var down_held = false
var up_held = false
var right_held = false


var Left_Child: int
var Down_Child: int
var Up_Child: int
var Right_Child: int

@export var rangeClick = 100

@export var column : int
@export var pos_in_ms : int
@export var is_hold : int
@export var is_hurt : bool

@export var Chart : Dictionary = { # ID: [column, song position in ms, grid position, hold, is hurt]
	1: [2, 2000, null, 0, false, 1],
	2: [0, 2000, null, 0, false, 2],
	3: [1, 2250, null, 0, false, 3],
	4: [3, 3500, null, 0, false, 4],
	5: [2, 2500, null, 0, false, 5],
	6: [2, 3000, null, 0, false, 6],
	7: [2, 4000, null, 0, false, 7],
	8: [2, 5000, null, 0, false, 8],
}

var Chart_time_column0 = []
var Chart_time_column1 = []
var Chart_time_column2 = []
var Chart_time_column3 = []

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
	#return Down.position.y * ((time - song_time_ms) * scrollSpeed)
	
var Left_Bool: bool = 1
var Down_Bool: bool = 1
var Up_Bool: bool = 1
var Right_Bool: bool = 1

func generateUnspawn():
	if not Chart.is_empty():
		for key in Chart:
			var note_data = Chart[key]
			var id = note_data[5]
			column = note_data[0]
			pos_in_ms = note_data[1]
			is_hold = note_data[3] != 0
			
			
			if column == 0:
				var left = Sprite3D.new()
				left.name = str(note_data)
				left.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/1.png")
				left.pixel_size = 0.5
				left.offset = Vector2(0, left.texture.get_height() / 2)
				Left.add_child(left)
				
			
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
				up.name = str(pos_in_ms)
				up.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/3.png")
				up.pixel_size = 0.5
				up.offset = Vector2(0, up.texture.get_width() / 2)
				Up.add_child(up)
			if column == 3:
				var right = Sprite3D.new()
				right.name = str(note_data)
				right.texture = load("res://Assets/Custom/Skin/Default/4k/HitObjects/4.png")
				right.pixel_size = 0.5
				Right.add_child(right)
				
			match column:
				0:
					Chart_time_column0 += [pos_in_ms]
				1:
					Chart_time_column1 += [pos_in_ms]
				2:
					Chart_time_column2 += [pos_in_ms]
				3:
					Chart_time_column3 += [pos_in_ms]

func Scroll(delta: float, scrollSpeed: float) -> void:
	var LeftHO_1 = $"4k/Left/HitObjects".get_children()
	var DownHO_1 = $"4k/Down/HitObjects".get_children()
	var UpHO_1 = $"4k/Up/HitObjects".get_children()
	var RightHO_1 = $"4k/Right/HitObjects".get_children()
	
	if not Chart_time_column0.is_empty() and LeftHO_1.size() > 0:
		var iteration_count = min(len(Chart_time_column0), len(LeftHO_1))
		for key in range(iteration_count):
			var note_data = Chart_time_column0[key]
			var leftHO = LeftHO_1[key]
			leftHO.position.y = Left.position.y + (note_data - song_time_ms) * scrollSpeed
			
	if not Chart_time_column1.is_empty() and DownHO_1.size() > 0:
		var iteration_count = min(len(Chart_time_column1), len(DownHO_1))
		for key in range(iteration_count):
			var note_data = Chart_time_column1[key]
			var downHO = DownHO_1[key]
			downHO.position.y = Down.position.y + (note_data - song_time_ms) * scrollSpeed
	
	if not Chart_time_column2.is_empty() and UpHO_1.size() > 0:
		var iteration_count = min(len(Chart_time_column2), len(UpHO_1)) 
		for key in range(iteration_count):
			var note_data = Chart_time_column2[key]
			var upHO = UpHO_1[key]
			upHO.position.y = Up.position.y + (note_data - song_time_ms) * scrollSpeed
			
	if not Chart_time_column3.is_empty() and RightHO_1.size() > 0:
		var iteration_count = min(len(Chart_time_column3), len(RightHO_1)) 
		for key in range(iteration_count):
			var note_data = Chart_time_column3[key]
			var rightHO = RightHO_1[key]
			rightHO.position.y = Right.position.y + (note_data - song_time_ms) * scrollSpeed
	
	
	if not Chart.is_empty():
		for key in Chart:
			var note_data = Chart[key]
			var column = note_data[0]
			var pos_in_ms = note_data[1]
				
			if Right.get_child_count() > 0 and column == 3:
				for child in Right.get_children(0):
					child.position.y = $"4k/Right/Receptor/Right".position.y + (pos_in_ms - song_time_ms) * scrollSpeed
	
			var effective_range : float = rangeClick * (scrollSpeed * 25)
			if column == 0:
				for child in Left.get_children(0):
					if abs($"4k/Left/Receptor/Left".position.y - child.position.y) <= effective_range:
						if PlayState.LeftActive:
							LeftHitObject(effective_range, scrollSpeed)
							
	
			elif column == 1:
				for child in Down.get_children(0):
					if abs($"4k/Down/Receptor/Down".position.y - child.position.y) <= effective_range:
						if PlayState.DownActive:
							DownHitObject(effective_range, scrollSpeed)
	
			elif column == 2:
				for child in Up.get_children(0):
					if abs($"4k/Up/Receptor/Up".position.y - child.position.y) <= effective_range:
						if PlayState.UpActive:
							#HitRating(effective_range, scrollSpeed)	
							UpHitObject(effective_range, scrollSpeed)
					
			elif column == 3:
				for child in Right.get_children(0):
					if abs($"4k/Right/Receptor/Right".position.y - child.position.y) <= effective_range:
						if PlayState.RightActive:
							RightHitObject(effective_range, scrollSpeed)
			
			checkMissLeft(scrollSpeed)
			checkMissDown(scrollSpeed)
			checkMissUp(scrollSpeed)
			checkMissRight(scrollSpeed)

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

func LeftHitObject(effective_range: float, scrollSpeed: float) -> void:
	if Left.get_child_count() == 0 or Chart_time_column0.size() == 0:
		return  # Salir si no hay notas que procesar
	# Obtener el primer nodo hijo de Left y la posición del receptor
	var first_note = Left.get_child(0)
	var note_position_y = first_note.position.y
	var distance = abs(LeftReceptor.position.y - note_position_y)

	# Calcular los rangos de calificación
	var Effective_M = 0.5 * (scrollSpeed + 25)
	var Effective_P = 1 * (scrollSpeed + 25)
	var Effective_G = 1.5 * (scrollSpeed + 25)
	var Effective_GO = 2 * (scrollSpeed + 25)
	var Effective_ME = 2.5 * (scrollSpeed + 25)
	var Effective_B = 3 * (scrollSpeed + 25)

	# Calificar y eliminar la nota si se alcanza un rango efectivo
	if distance <= Effective_M:
		print("Marvelous")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Marvelous.png")
		remove_left_note()
	elif distance <= Effective_P:
		print("Perfect")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Perfect.png")
		remove_left_note()
	elif distance <= Effective_G:
		print("Great")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Great.png")
		remove_left_note()
	elif distance <= Effective_GO:
		print("Good")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Good.png")
		remove_left_note()
	elif distance <= Effective_ME:
		print("Meh")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Meh.png")
		remove_left_note()
	elif distance <= Effective_B:
		print("Bad")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Bad.png")
		remove_left_note()

	# Actualizar posiciones de las notas restantes
	update_left_notes_position(scrollSpeed)
	RatingAnimation()

# Función para eliminar la primera nota de la columna izquierda
func remove_left_note():
	# Eliminar el primer nodo de la lista y su dato de tiempo correspondiente
	if Left.get_child_count() > 0:
		Left.get_child(0).queue_free()
	if Chart_time_column0.size() > 0:
		Chart_time_column0.remove_at(0)

# Función para actualizar las posiciones de las notas restantes en la columna izquierda
func update_left_notes_position(scrollSpeed: float) -> void:
	var LeftHO_1 = Left.get_children()
	for i in range(LeftHO_1.size()):
		var note_data = Chart_time_column0[i] if i < Chart_time_column0.size() else 0
		LeftHO_1[i].position.y = Up.position.y + (note_data - song_time_ms) * scrollSpeed

			
func DownHitObject(effective_range: float, scrollSpeed: float) -> void:
	if Down.get_child_count() == 0 or Chart_time_column1.size() == 0:
		return  # Salir si no hay notas que procesar

	var first_note = Down.get_child(0)
	var note_position_y = first_note.position.y
	var distance = abs(DownReceptor.position.y - note_position_y)

	var Effective_M = 0.5 * (scrollSpeed + 25)
	var Effective_P = 1 * (scrollSpeed + 25)
	var Effective_G = 1.5 * (scrollSpeed + 25)
	var Effective_GO = 2 * (scrollSpeed + 25)
	var Effective_ME = 2.5 * (scrollSpeed + 25)
	var Effective_B = 3 * (scrollSpeed + 25)

	if distance <= Effective_M:
		print("Marvelous")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Marvelous.png")
		remove_down_note()
	elif distance <= Effective_P:
		print("Perfect")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Perfect.png")
		remove_down_note()
	elif distance <= Effective_G:
		print("Great")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Great.png")
		remove_down_note()
	elif distance <= Effective_GO:
		print("Good")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Good.png")
		remove_down_note()
	elif distance <= Effective_ME:
		print("Meh")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Meh.png")
		remove_down_note()
	elif distance <= Effective_B:
		print("Bad")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Bad.png")
		remove_down_note()

	update_down_notes_position(scrollSpeed)
	RatingAnimation()

func remove_down_note():
	if Down.get_child_count() > 0:
		Down.get_child(0).queue_free()
	if Chart_time_column1.size() > 0:
		Chart_time_column1.remove_at(0)

func update_down_notes_position(scrollSpeed: float) -> void:
	var DownHO_1 = Down.get_children()
	for i in range(DownHO_1.size()):
		var note_data = Chart_time_column1[i] if i < Chart_time_column1.size() else 0
		DownHO_1[i].position.y = Down.position.y + (note_data - song_time_ms) * scrollSpeed

	
func UpHitObject(effective_range: float, scrollSpeed: float) -> void:
	if Up.get_child_count() == 0 or Chart_time_column2.size() == 0:
		return  # Salir si no hay notas que procesar
	# Obtener el primer nodo hijo de Up y la posición del receptor
	var first_note = Up.get_child(0)
	var note_position_y = first_note.position.y
	var distance = abs(UpReceptor.position.y - note_position_y)

	# Calcular los rangos de calificación
	var Effective_M = 0.5 * (scrollSpeed + 25)
	var Effective_P = 1 * (scrollSpeed + 25)
	var Effective_G = 1.5 * (scrollSpeed + 25)
	var Effective_GO = 2 * (scrollSpeed + 25)
	var Effective_ME = 2.5 * (scrollSpeed + 25)
	var Effective_B = 3 * (scrollSpeed + 25)

	# Calificar y eliminar la nota si se alcanza un rango efectivo
	if distance <= Effective_M:
		print("Marvelous")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Marvelous.png")
		remove_up_note()
	elif distance <= Effective_P:
		print("Perfect")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Perfect.png")
		remove_up_note()
	elif distance <= Effective_G:
		print("Great")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Great.png")
		remove_up_note()
	elif distance <= Effective_GO:
		print("Good")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Good.png")
		remove_up_note()
	elif distance <= Effective_ME:
		print("Meh")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Meh	.png")
		remove_up_note()
	elif distance <= Effective_B:
		print("Bad")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Bad.png")
		remove_up_note()

	# Actualizar posiciones de las notas restantes
	update_up_notes_position(scrollSpeed)
	RatingAnimation()

func remove_up_note():
	# Eliminar el primer nodo de la lista y su dato de tiempo correspondiente
	if Up.get_child_count() > 0:
		Up.get_child(0).queue_free()
	if Chart_time_column2.size() > 0:
		Chart_time_column2.remove_at(0)

func update_up_notes_position(scrollSpeed: float) -> void:
	var UpHO_1 = Up.get_children()
	for i in range(UpHO_1.size()):
		var note_data = Chart_time_column2[i] if i < Chart_time_column2.size() else 0
		UpHO_1[i].position.y = Up.position.y + (note_data - song_time_ms) * scrollSpeed

func RightHitObject(effective_range: float, scrollSpeed: float) -> void:
	
	if Right.get_child_count() == 0 or Chart_time_column3.size() == 0:
		return  # Salir si no hay notas que procesar
	RatingAnimation()
	var first_note = Right.get_child(0)
	var note_position_y = first_note.position.y
	var distance = abs(RightReceptor.position.y - note_position_y)

	var Effective_M = 0.5 * (scrollSpeed + 25)
	var Effective_P = 1 * (scrollSpeed + 25)
	var Effective_G = 1.5 * (scrollSpeed + 25)
	var Effective_GO = 2 * (scrollSpeed + 25)
	var Effective_ME = 2.5 * (scrollSpeed + 25)
	var Effective_B = 3 * (scrollSpeed + 25)

	if distance <= Effective_M:
		print("Marvelous")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Marvelous.png")
		remove_right_note()
	elif distance <= Effective_P:
		print("Perfect")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Perfect.png")
		remove_right_note()
	elif distance <= Effective_G:
		print("Great")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Great.png")
		remove_right_note()
	elif distance <= Effective_GO:
		print("Good")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Good.png")
		remove_right_note()
	elif distance <= Effective_ME:
		print("Meh")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Meh.png")
		remove_right_note()
	elif distance <= Effective_B:
		print("Bad")
		$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Bad.png")
		remove_right_note()

	update_right_notes_position(scrollSpeed)
	RatingAnimation()

func remove_right_note():
	if Right.get_child_count() > 0:
		Right.get_child(0).queue_free()
	if Chart_time_column3.size() > 0:
		Chart_time_column3.remove_at(0)

func update_right_notes_position(scrollSpeed: float) -> void:
	var RightHO_1 = Right.get_children()
	for i in range(RightHO_1.size()):
		var note_data = Chart_time_column3[i] if i < Chart_time_column3.size() else 0
		RightHO_1[i].position.y = Right.position.y + (note_data - song_time_ms) * scrollSpeed

func checkMissLeft(scrollSpeed: float) -> void:
	if Left.get_child_count() == 0 or Chart_time_column0.size() == 0:
		return  # Salir si no hay notas que procesar
	var Effective_Miss = 5 * (scrollSpeed + 25)  # Define el rango de "Miss"
		
	var note = Left.get_child(0)
		# Comprobar si la nota está por debajo del receptor y fuera del rango
	if note.position.y < LeftReceptor.position.y:
		if abs(LeftReceptor.position.y - note.position.y) > Effective_Miss:
			print("Miss")
			$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Miss.png")
			RatingAnimation()
			note.queue_free()  # Eliminar la nota
			Chart_time_column0.remove_at(0)  # Eliminar de la lista
	var LeftHO_1 = Left.get_children()
	for i in range(LeftHO_1.size()):
		var note_data = Chart_time_column0[i] if i < Chart_time_column0.size() else 0
		LeftHO_1[i].position.y = Up.position.y + (note_data - song_time_ms) * scrollSpeed

func checkMissDown(scrollSpeed: float) -> void:
	if Down.get_child_count() == 0 or Chart_time_column1.size() == 0:
		return  # Salir si no hay notas que procesar
	var Effective_Miss = 5 * (scrollSpeed + 25)  # Define el rango de "Miss"
		
	var note = Down.get_child(0)
		# Comprobar si la nota está por debajo del receptor y fuera del rango
	if note.position.y < DownReceptor.position.y:
		if abs(DownReceptor.position.y - note.position.y) > Effective_Miss:
			print("Miss")
			$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Miss.png")
			RatingAnimation()
			note.queue_free()  # Eliminar la nota
			Chart_time_column1.remove_at(0)  # Eliminar de la lista
			
	var DownHO_1 = Down.get_children()
	for i in range(DownHO_1.size()):
		var note_data = Chart_time_column1[i] if i < Chart_time_column1.size() else 0
		DownHO_1[i].position.y = Down.position.y + (note_data - song_time_ms) * scrollSpeed

func checkMissUp(scrollSpeed: float) -> void:
	if Up.get_child_count() == 0 or Chart_time_column2.size() == 0:
		return  # Salir si no hay notas que procesar
	var Effective_Miss = 5 * (scrollSpeed + 25)  # Define el rango de "Miss"
		
	var note = Up.get_child(0)
		# Comprobar si la nota está por debajo del receptor y fuera del rango
	if note.position.y < UpReceptor.position.y:
		if abs(UpReceptor.position.y - note.position.y) > Effective_Miss:
			print("Miss")
			$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Miss.png")
			RatingAnimation()
			note.queue_free()  # Eliminar la nota
			Chart_time_column2.remove_at(0)  # Eliminar de la lista
				
	var UpHO_1 = Up.get_children()
	for i in range(UpHO_1.size()):
		var note_data = Chart_time_column2[i] if i < Chart_time_column2.size() else 0
		UpHO_1[i].position.y = Up.position.y + (note_data - song_time_ms) * scrollSpeed

func checkMissRight(scrollSpeed: float) -> void:
	if Right.get_child_count() == 0 or Chart_time_column3.size() == 0:
		return  # Salir si no hay notas que procesar
	var Effective_Miss = 5 * (scrollSpeed + 25)  # Define el rango de "Miss"
		
	var note = Right.get_child(0)
		# Comprobar si la nota está por debajo del receptor y fuera del rango
	if note.position.y < RightReceptor.position.y:
		if abs(RightReceptor.position.y - note.position.y) > Effective_Miss:
			print("Miss")
			$"../CamHUD/Rating".texture = load("res://Assets/Custom/Skin/Default/Rating/Miss.png")
			RatingAnimation()
			note.queue_free()
			Chart_time_column3.remove_at(0)
	
var active_tween = null
var is_animating = false

var anim_duration = 0.5
var start_scale = Vector3(1, 1, 1)
var end_scale = Vector3(0.75, 0.75, 0.75)
var start_modulate = Color(1, 1, 1, 1)
var end_modulate = Color(1, 1, 1, 0)

func RatingAnimation():
	var rating = $"../CamHUD/Rating"
	
	# Reinicia las propiedades iniciales
	rating.modulate = start_modulate
	rating.scale = start_scale
	
	# Inicia el tiempo
	var elapsed_time = 0.0

	# Loop de la animación
	while elapsed_time < anim_duration:
		var t = elapsed_time / anim_duration  # Normaliza el tiempo
		
		if t < 1.0:
			t = pow(2, 10 * (t - 1))

		# Interpolación de escala y modulación
		rating.scale = lerp(start_scale, end_scale, t)
		rating.modulate = lerp(start_modulate, end_modulate, t)

		# Espera el siguiente frame usando await
		await get_tree().process_frame  # Esto espera un frame
		elapsed_time += get_process_delta_time()  # Aumenta el tiempo transcurrido

	# Asegura que termina en los valores finales
	rating.scale = end_scale
	rating.modulate = end_modulate
	
func beatCount(delta) -> void:
	if MusicBeatState.playing:
		current_time += (delta * 8)
		current_beat = current_time / time_per_beat
		current_beat = round(current_beat)
	
		print("Beat:", current_beat)
