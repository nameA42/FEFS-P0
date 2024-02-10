extends Node2D



@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
var ID = -1
var inited = false

@export var ismovementDisplayed = true

@onready var speed = parent.speed
@onready var str = parent.str
@onready var rang = parent.rang


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
		root.display_reachable_area(ID, speed)
