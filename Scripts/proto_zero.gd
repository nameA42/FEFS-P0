extends Node2D

var mvmnt_ind_piece = preload("res://Objects/movement_ind_piece.tscn")
@onready var tile_map = $"Map"

@onready var ID_manager = get_node("Manager's Hideout/IdManager")
@onready var astar_manager = get_node("Manager's Hideout/AstarManager")
@onready var move_manager = get_node("Manager's Hideout/MovementManager")
@onready var faction_manager = get_node("Manager's Hideout/FactionManager")
@onready var combat_display_manager = get_node("Manager's Hideout/CombatDisplayManager")

# TODO: apply this to the whole engine
const TILE_SIZE = 24
const DEFAULT_ID = -1

# Initialize the A star grid
# Give all tiles data
# Start the first faction's turn
func _ready(): 
	
	astar_manager.init_astar_grid()
	astar_manager.init_tile_data()
	get_factions()
	start_faction_turn(starting_faction)


func _process(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_manager.process_buffered_movement(astar_manager.tile_map, ID_manager.id_to_obj)
	progress_turn()

func progress_turn():
	if(!move_manager.moving and can_move_array.size() == 0 and player_turn):
		next_turn()
	


func actor_deal_damage(actor, target):
	var actor_stats = id_to_obj[actor].get_node_or_null("C_Stats")
	print(actor_stats)
	if(actor_stats != null):
		if(get_in_range_area(actor, actor_stats.rang).has(location[target])):
			var target_health = id_to_obj[target].get_node_or_null("C_HP")
			if(target_health != null):
				target_health.damage(actor_stats.str)
