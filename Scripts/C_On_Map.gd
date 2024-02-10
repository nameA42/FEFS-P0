extends Node2D


@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
var ID = -1
var Init_pos
@export var Offset = Vector2i(8, 8)
var inited = false
var mvableArea


# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	Init_pos = parent.Init_pos
	print(root)
	print(Init_pos)
	print(parent.ID)
	ID = parent.ID
	root.Location[ID] = Init_pos
	parent.position = root.Location[ID]*16 + Offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(!inited):
		root.flop_astar_grid(ID)
		inited = true


func del():
	pass

func clicked():
	pass
