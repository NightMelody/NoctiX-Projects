extends Sprite3D

@onready var Playfield = $"../../../.."

var id
var column
var time 

@onready var is_long = Playfield.is_hold
@onready var is_hurt = Playfield.is_hurt

@onready var Chart = Playfield.Chart


@onready var PlayState = $"../../../../.."

@onready var MusicBeatState = $"../../../../../BeatMusic"

@onready var Up = $"../../Receptor/Up"

var song_time : float
var song_time_ms: int
@onready var scrollSpeed = PlayState.scrollSpeed

@onready var UpHO = $"..".get_children()

var Chart_column0 = {}
var Chart_column1 = {}
var Chart_column2 = {}
var Chart_column3 = {}

func _ready():
	if not Chart.is_empty():
		for key in Chart:
			var note_data = Chart[key]
			id = note_data[5]
			column = note_data[0]
			time = note_data[1]
			
			match column:
				0:
					Chart_column0[key] = [time, null, 0, is_hurt, id]
				1:
					Chart_column1[key] = [time, null, 0, is_hurt, id]
				2:
					Chart_column2[key] = [time, null, 0, is_hurt, id]
				3:
					Chart_column3[key] = [time, null, 0, is_hurt, id]
			
	print("Notas en columna 0:", Chart_column0)
	print("Notas en columna 1:", Chart_column1)
	print("Notas en columna 2:", Chart_column2)
	print("Notas en columna 3:", Chart_column3)
			
	UpHO = $"..".get_children()
	var up_keys = Chart_column2.keys() 
	var up = min(len(up_keys), len(UpHO))
	


	for key in range(up):
		var note_key = up_keys[key]
		var note_data = Chart_column2[note_key]
		var up_node = UpHO[key]
		var UTime = note_data[0]
		
		up_node.set_meta("Time", UTime)
			
	print($"..".get_child_count())
		
			
			#self.set_meta("Id", id)
			#self.set_meta("Column", column)
			#self.set_meta("Time", time)
			
			
			#if self.get_meta("Column", 2): print(id)
			#print("Key: ", key, " Column: ", column, " Time: ", time, " Id: ", id)
			
func _process(delta: float) -> void:
	song_time = MusicBeatState.get_playback_position()
	song_time_ms = round(song_time * 1000)


	#self.position.y = $"../../Receptor/Up".position.y + (self.get_meta("Time") - song_time_ms) * PlayState.scrollSpeed
		
	#print("First Child: ", $"..".get_child(1).get_meta("Time"))
	#print("Second Child: ", $"..".get_chfild(2).get_meta("Time"))
