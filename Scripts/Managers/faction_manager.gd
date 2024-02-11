extends Node2D

@onready var rt = get_tree().root.get_child(0)
var factions:Array
@export var starting_faction = 1
@export var player_faction = 1
var turn_count = 0
var player_turn = true
var can_move_array:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_factions():
		#check number of present factions
	for child in rt.get_children():
		if "faction" in child:
			if child.faction != 0 and !factions.has(child.faction):
				factions.append(child.faction)

func get_faction_members(fac):
	var faction_members:Array
	for child in rt.get_children():
		if "faction" in child:
			if child.faction == fac:
				faction_members.append(child.ID)
	return faction_members

func get_closest_faction_member(fac, loc):

	var members = get_faction_members(fac)
	var target_dist = 10000000
	var target
	for member in members:
		rt.astar_manager.astar_grid.set_point_solid(rt.ID_manager.location[member], false)
		print(rt.astar_manager.astar_grid.get_id_path(
			loc,
			rt.ID_manager.location[member]
		).slice(1))
		
		var dist = rt.astar_manager.astar_grid.get_id_path(
			loc,
			rt.ID_manager.location[member]
		).slice(1).size()
		
		rt.astar_manager.astar_grid.set_point_solid(rt.ID_manager.location[member], true)
		if(dist < target_dist):
			target_dist = dist
			target = member
	return target

func get_move(fac):
	can_move_array.clear()
	for child in rt.get_children():
		if "faction" in child and "moved" in child:
			if child.faction == fac and !child.moved:
				can_move_array.append(child.ID)
				
func start_faction_turn(fac):
	for child in rt.get_children():
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
		var current_object = rt.ID_manager.id_to_obj[can_move_array[can_move_array.size()-1]]
		current_object.Act()
		await !rt.move_manager.moving
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
