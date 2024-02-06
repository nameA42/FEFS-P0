extends Node2D


@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1
var Init_pos
@export var Offset = Vector2i(8, 8)
var inited = false
var mvableArea


# Called when the node enters the scene tree for the first time.
func _ready():
	await par.ready
	Init_pos = par.Init_pos
	print(rt)
	print(Init_pos)
	print(par.ID)
	ID = par.ID
	rt.Location[ID] = Init_pos
	par.position = rt.Location[ID]*16 + Offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(!inited):
		rt.flopAstargrid(ID)
		inited = true


func del():
	pass

func clicked():
	pass
