extends Node2D



@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1
var inited = false

@export var ismovementDisplayed = true

@onready var speed = par.speed
@onready var str = par.str
@onready var rang = par.rang


# Called when the node enters the scene tree for the first time.
func _ready():
	await par.ready
	ID = par.ID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clicked():
	print(clicked)
	if(ismovementDisplayed):
		rt.display_reachable_area(ID, speed)
