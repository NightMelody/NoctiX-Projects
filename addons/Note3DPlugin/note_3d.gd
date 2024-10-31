extends Sprite3D

@export var ID : int = 1
@export var column : int = 0
@export var Time_note_ms : int = 0000
@export var Is_long : int = 0
@export var Is_hurt : bool = false
@export var Pos_in_grid : Vector2 = Vector2.ZERO

func SpawnNote(ID : int, column : int, Time_note_ms : int, Is_long : int, Is_hurt : bool, Pos_in_grid : Vector2):
	self.ID = ID
	self.column = column
	self.Time_note_ms = Time_note_ms
	self.Is_long = Is_long
	self.Is_hurt = Is_hurt
	self.Pos_in_grid = Pos_in_grid
