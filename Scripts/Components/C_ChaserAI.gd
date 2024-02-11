extends Node2D

@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)


@onready var ID = root.DEFAULT_ID
var Stats = null

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	await root.ready
	ID = parent.ID
	Stats = parent.get_node("C_Stats")
	print(ID)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Act():
	var closest_ID = root.faction_manager.get_closest_faction_member(root.faction_manager.player_faction, root.ID_manager.location[ID])
	if(root.combat_display_manager.get_in_range_area(ID, Stats.rang).has(root.ID_manager.location[closest_ID])):
		root.combat_manager.actor_move(ID, closest_ID)
	elif(!parent.get_node("C_Dynamic").moved):
		root.move_manager.actor_move(ID, root.ID_manager.location[closest_ID], Stats.speed)
