extends Node2D

@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var ID = root.DEFAULT_ID
@export var max_hp = 1
var hp = max_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	ID = parent.ID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(hp <= 0):
		parent.delete()

func damage(dmg):
	hp -= dmg
	print(ID, " took ", dmg, " damage!")

func del():
	pass
