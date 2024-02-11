extends Node2D



@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var ID = root.DEFAULT_ID
var inited = false

@export var ismovementDisplayed = true

@export var speed = 1
@export var str = 1
@export var rang = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	ID = parent.ID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clicked():
	print(clicked)
	if(ismovementDisplayed):
		root.combat_display_manager.display_reachable_area(ID, speed)
