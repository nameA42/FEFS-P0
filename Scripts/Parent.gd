extends CharacterBody2D

var ID
@export var Init_pos = Vector2(0, 0)
@export var SpriteID = 0
@onready var sprt : AnimatedSprite2D = get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprt.frame = SpriteID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

