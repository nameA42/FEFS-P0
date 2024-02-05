extends CharacterBody2D

@onready var rt = get_tree().root.get_child(0)
var ID = -1
@export var Init_pos = Vector2i(0, 0)
@export var Init_hp = 1
@export var speed = 1
@export var str = 1
@export var rang = 1
@export var SpriteID = 0
@onready var sprt : AnimatedSprite2D = get_node("AnimatedSprite2D")
@export var selectable = true
@export var moved = false
@export var attacked = false
@export var faction = 1
@export var Baseactions = 1
var actions = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	ID = rt.give_id()
	print("GotID:",ID)
	rt.IDToObj[ID] = self
	sprt.frame = SpriteID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func del():
	for child in get_children():
		if child.has_method("del"):
			child.del()
	rt.remove_id(ID)
	rt.redisplay_reachable_area()
	queue_free()

func clicked():
	for child in get_children():
		if child.has_method("clicked"):
			child.clicked()

func Act():
	for child in get_children():
		if child.has_method("Act"):
			child.Act()
