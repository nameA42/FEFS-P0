extends Node2D

@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)

@onready var combat_manager = root.combat_manager
@onready var faction_manager = root.faction_manager
@onready var ID_manager = root.ID_manager
@onready var combat_display_manager = root.combat_display_manager


@onready var ID = root.DEFAULT_ID

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	ID = parent.ID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Act():
	var closest_ID = faction_manager.get_closest_faction_member(1, ID_manager.Location[ID])
	if(combat_display_manager.get_in_range_area(ID, parent.rang).has(ID_manager.Location[closest_ID])):
		combat_manager.actor_move(ID, closest_ID)
	elif(!parent.moved):
		combat_manager.actor_move(ID, ID_manager.Location[closest_ID], parent.speed)
