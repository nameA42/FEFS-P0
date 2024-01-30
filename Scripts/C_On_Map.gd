extends Node2D

@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID
@onready var Init_pos = par.Init_pos
@export var Offset = Vector2(8, 8)


# Called when the node enters the scene tree for the first time.
func _ready():
	print(rt)
	print(Init_pos)
	rt.Location.push_back(Init_pos)
	rt.IDToObj.push_back(par)
	ID = rt.Location.size()-1
	par.ID = ID
	par.position = Vector2(rt.Location[ID]*16) + Offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	
