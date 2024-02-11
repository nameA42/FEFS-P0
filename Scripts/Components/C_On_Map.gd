extends Node2D

@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var ID = root.DEFAULT_ID
var Init_pos
@export var Offset = Vector2i(8, 8)
var inited = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await root.ready
	await parent.ready
	Init_pos = parent.init_pos
	print(root)
	print(Init_pos)
	print(parent.ID)
	ID = parent.ID
	root.ID_manager.location[ID] = Init_pos
	parent.position = root.ID_manager.location[ID]*16 + Offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(!inited):
		root.astar_manager.flop_astar_grid(ID)
		inited = true


func del():
	pass

func clicked():
	pass
