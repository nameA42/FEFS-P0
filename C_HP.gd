extends Node2D

@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1
@onready var HP = par.Init_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	await par.ready
	ID = par.ID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(HP == 0):
		par.del()


func del():
	pass
