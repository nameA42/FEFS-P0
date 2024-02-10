extends Node2D

var mvmnt_ind_piece = preload("res://Objects/movement_ind_piece.tscn")
@onready var tile_map = $"Map"

@onready var ID_manager = get_node("Manager's Hideout/IdManager")
@onready var astar_manager = get_node("Manager's Hideout/AstarManager")
@onready var move_manager = get_node("Manager's Hideout/MovementManager")
@onready var combat_display_manager = get_node("Manager's Hideout/CombatDisplayManager")

# TODO: apply this to the whole engine
const TILE_SIZE = 24
const DEFAULT_ID = -1

var factions:Array
@export var starting_faction = 1
@export var player_faction = 1
var turn_count = 0
var player_turn = true
var can_move_array:Array

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
	
func get_factions():
		#check number of present factions
	for child in get_children():
		if "faction" in child:
			if child.faction != 0 and !factions.has(child.faction):
				factions.append(child.faction)

func get_faction_members(fac):
	var faction_members:Array
	for child in get_children():
		if "faction" in child:
			if child.faction == fac:
				faction_members.append(child.ID)
	return faction_members

func get_closest_faction_member(fac, loc):

	var members = get_faction_members(fac)
	var target_dist = 10000000
	var target
	for member in members:
		astar_grid.set_point_solid(location[member], false)
		print(astar_grid.get_id_path(
			loc,
			location[member]
		).slice(1))
		
		var dist = astar_grid.get_id_path(
			loc,
			location[member]
		).slice(1).size()
		
		astar_grid.set_point_solid(location[member], true)
		if(dist < target_dist):
			target_dist = dist
			target = member
	return target

func get_move(fac):
	can_move_array.clear()
	for child in get_children():
		if "faction" in child and "moved" in child:
			if child.faction == fac and !child.moved:
				can_move_array.append(child.ID)
				
func start_faction_turn(fac):
	for child in get_children():
		if "faction" in child and "moved" in child:
			if child.faction == fac:
				child.moved = false
				child.actions = child.Baseactions
				can_move_array.append(child.ID)

func do_turn(faction):
	while (can_move_array.size() > 0):
		print(get_faction_members(player_faction))
		if(get_faction_members(player_faction).is_empty()):
			print("exiting")
			get_tree().quit()
			break
		print("can_move is:", can_move_array.size())
		print("moving: ", can_move_array[can_move_array.size()-1])
		var current_object = id_to_obj[can_move_array[can_move_array.size()-1]]
		current_object.Act()
		await !moving
		print("done waiting for move")
		if(!current_object.attacked):
			print("attacking")
			current_object.Act()
		await get_tree().create_timer(1.0).timeout
	print("done with turn")
	next_turn()

func next_turn():
	print("moving turns")
	turn_count += 1
	var fac_turn = (turn_count % factions.size()) + 1
	start_faction_turn(fac_turn)
	if(fac_turn == player_faction):
		print("Player Turn")
		player_turn = true
	else:
		print("Turn for faction: ", fac_turn)
		player_turn = false
		do_turn(fac_turn)

func actor_deal_damage(actor, target):
	var actor_stats = id_to_obj[actor].get_node_or_null("C_Stats")
	print(actor_stats)
	if(actor_stats != null):
		if(get_in_range_area(actor, actor_stats.rang).has(location[target])):
			var target_health = id_to_obj[target].get_node_or_null("C_HP")
			if(target_health != null):
				target_health.damage(actor_stats.str)
