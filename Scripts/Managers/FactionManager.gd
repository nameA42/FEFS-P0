extends Node2D

@onready var root = get_tree().root.get_child(0)
var factions:Array
@export var starting_faction = 1
@export var player_faction = 1
var turn_count = 0
var player_turn = true
var can_move_array:Array
const states = C_Combat.CombatState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_factions():
		#check number of present factions
	for child in root.find_child("Units").get_children():
		var child_combat = child.find_child("C_Combat")
		if child_combat != null:
			if child_combat.faction != 0 and !factions.has(child_combat.faction):
				factions.append(child_combat.faction)

func get_faction_members(fac):
	var faction_members:Array
	for child in root.get_children():
		var child_combat = child.find_child("C_Combat")
		if child_combat != null:
			if child_combat.faction == fac:
				faction_members.append(child.ID)
	return faction_members

func get_closest_faction_member(fac, loc):

	var members = get_faction_members(fac)
	var target_dist = 10000000
	var target
	for member in members:
		root.astar_manager.astar_grid.set_point_solid(root.ID_manager.location[member], false)
		print(root.astar_manager.astar_grid.get_id_path(
			loc,
			root.ID_manager.location[member]
		).slice(1))
		
		var dist = root.astar_manager.astar_grid.get_id_path(
			loc,
			root.ID_manager.location[member]
		).slice(1).size()
		
		root.astar_manager.astar_grid.set_point_solid(root.ID_manager.location[member], true)
		if(dist < target_dist):
			target_dist = dist
			target = member
	return target

func get_move(fac):
	can_move_array.clear()
	for child in root.get_children():
		var child_combat = child.find_child("C_Combat")
		if child_combat != null:
			if child_combat.faction == fac and !child_combat.combat_state == states.ACTIONABLE:
				can_move_array.append(child.ID)
				print(child.ID)
				
func start_faction_turn(fac):
	
	for child in root.find_child("Units").get_children():
		var child_combat = child.find_child("C_Combat")
		if child_combat != null:
			if child_combat.faction == fac:
				child_combat.combat_state = states.ACTIONABLE
				can_move_array.append(child.ID)
				print(child.ID)

func do_turn(faction):

	while (can_move_array.size() > 0):
		print(get_faction_members(player_faction))
		if(get_faction_members(player_faction).is_empty()):
			print("exiting")
			get_tree().quit()
			break
		print("can_move is:", can_move_array.size())
		print("moving: ", can_move_array[can_move_array.size()-1])
		var current_object = root.ID_manager.id_to_obj[can_move_array[can_move_array.size()-1]]
		current_object.act()
		await !root.move_manager.moving
		print("done waiting for move")
		if(!current_object.find_child("C_Combat").combat_state == states.EXHAUSTED):
			print("attacking")
			current_object.act()
		await get_tree().create_timer(1.0).timeout
	print("done with turn")
	next_turn()

func next_turn():
	print("moving turns")
	turn_count += 1
	if(factions.size() == 0):
		get_factions()
	print(factions)
	var fac_turn = (turn_count % factions.size()) + 1
	start_faction_turn(fac_turn)
	if(fac_turn == player_faction):
		print("Player Turn")
		player_turn = true
	else:
		print("Turn for faction: ", fac_turn)
		player_turn = false
		do_turn(fac_turn)
