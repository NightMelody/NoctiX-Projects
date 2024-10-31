@tool
extends EditorPlugin

var resource

func _enter_tree():
	resource = load("res://addons/Note3DPlugin/note_3d.tscn")
	add_custom_type("Note3D", "Sprite3D", resource, preload("res://addons/Note3DPlugin/icon.png"))
	
func _exit_tree():
	remove_custom_type("Note3D")
