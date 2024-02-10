extends Node2D

@onready var parent = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1
@onready var HP = parent.Init_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	ID = parent.ID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(HP <= 0):
		parent.del()

func damage(dmg):
	HP -= dmg
	print(ID, " took ", dmg, " damage!")

func del():
	pass
