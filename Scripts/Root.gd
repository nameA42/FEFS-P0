extends Node2D

@onready var tile_map = $"Map"

@onready var ID_manager = get_node("Manager's Hideout/IdManager")
@onready var astar_manager = get_node("Manager's Hideout/AstarManager")
@onready var move_manager = get_node("Manager's Hideout/MovementManager")
@onready var faction_manager = get_node("Manager's Hideout/FactionManager")
@onready var combat_display_manager = get_node("Manager's Hideout/CombatDisplayManager")
@onready var combat_manager = get_node("Manager's Hideout/CombatManager")

# TODO: apply this to the whole engine
const TILE_SIZE = 24
const DEFAULT_ID = -1

# Initialize the A star grid
# Give all tiles data
# Start the first faction's turn
func _ready(): 
	
	astar_manager.init_astar_grid()
	astar_manager.init_tile_data()
	print("root ready")


func _process(event):
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_manager.process_buffered_movement()
	progress_turn()

# Progress to the next turn if all units in faction have moved.
func progress_turn():
	#print(faction_manager.can_move_array.size())
	if(faction_manager.turn_count == 0 and faction_manager.starting_faction != 0):
		faction_manager.start_faction_turn(faction_manager.starting_faction)
		faction_manager.starting_faction = 0
	if(!move_manager.moving and faction_manager.can_move_array.size() == 0 and faction_manager.player_turn):
		faction_manager.next_turn()

