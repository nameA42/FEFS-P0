class_name Actor extends Node2D

@onready var root = get_tree().root.get_child(0)

@onready var ID = root.DEFAULT_ID
@export var set_IP_from_pos = false
@export var init_pos = Vector2i(0, 0)

@export var sprite_id = 0
@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	await root.ready
	init_position()
	init_id()
	print("actor ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init_position():
	if(set_IP_from_pos):
		init_pos = Vector2i(((position - Vector2(8, 8))/16).round())
		print(init_pos)

func init_id():
	print(root.ID_manager)
	ID = root.ID_manager.give_id()

	root.ID_manager.id_to_obj[ID] = self
	sprite.frame = sprite_id

# When called, calls delete() in any children and kills the node.
func delete():
	for child in get_children():
		if child.has_method("delete"):
			child.delete()
	root.ID_manager.remove_id(ID)
	root.combat_display_manager.redisplay_reachable_area()
	queue_free()

# When called, activates act() in any children.
func act():
	for child in get_children():
		if child.has_method("Act"):
			child.Act()

