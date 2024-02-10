extends Node2D

var mvmnt_ind_piece = preload("res://Objects/movement_ind_piece.tscn")
@onready var tile_map = $"Map"

@export var Location : Array
@export var OpenIDs : Array
@export var starting_faction = 1
@export var player_faction = 1
var OpenIDN = 0
var IDToObj : Array

var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]

var moving = false
var movingTarget
var move_id = -1
var inited = false
var movement_ind

var last_reachable_tiles:Array
var lastID = 0
var lastSpd = 1

var factions:Array
var TurnCount = 0
var player_turn = true
var can_move_array:Array
var can_move = 0

# Initialize the A star grid
# Give all tiles data
# Start the first faction's turn
func _ready(): 
	
	init_astar_grid()
	init_tile_data()
	get_factions()
	start_faction_turn(starting_faction)

func init_astar_grid():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()	

func init_tile_data():
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(x,y)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or !tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)	

func _process(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !current_id_path.is_empty():
		var target_position = tile_map.map_to_local(current_id_path.front())
		
		#print(target_position)
		
		IDToObj[move_id].global_position = IDToObj[move_id].global_position.move_toward(target_position, 1)
		
		
		if IDToObj[move_id].global_position == target_position:
			current_id_path.pop_front()
	elif(move_id != -1):
		print(move_id)
		move_id = -1
		moving = false
	if(!moving and can_move == 0 and player_turn):
		nextTurn()
	

func get_factions():
		#check number of present factions
	for child in get_children():
		if "faction" in child:
			if child.faction != 0 and !factions.has(child.faction):
				factions.append(child.faction)

func get_faction_members(fac):
	var FacMems:Array
	for child in get_children():
		if "faction" in child:
			if child.faction == fac:
				FacMems.append(child.ID)
	return FacMems

func get_closest_faction_member(fac, loc):
	var members = get_faction_members(fac)
	var Targetdist = 10000000
	var Target
	for member in members:
		astar_grid.set_point_solid(Location[member], false)
		print(astar_grid.get_id_path(
			loc,
			Location[member]
		).slice(1))
		
		var dist = astar_grid.get_id_path(
			loc,
			Location[member]
		).slice(1).size()
		
		astar_grid.set_point_solid(Location[member], true)
		if(dist < Targetdist):
			Targetdist = dist
			Target = member
	return Target

func get_move(fac):
	can_move = 0
	can_move_array.clear()
	for child in get_children():
		if "faction" in child and "moved" in child:
			if child.faction == fac and !child.moved:
				can_move += 1
				can_move_array.append(child.ID)
				
func start_faction_turn(fac):
	for child in get_children():
		if "faction" in child and "moved" in child:
			if child.faction == fac:
				child.moved = false
				child.actions = child.Baseactions
				can_move += 1
				can_move_array.append(child.ID)

func doTurn(faction):
	while (can_move > 0):
		print(get_faction_members(player_faction))
		if(get_faction_members(player_faction).is_empty()):
			print("exiting")
			get_tree().quit()
			break
		print("can_move is:", can_move)
		print("moving: ", can_move_array[can_move-1])
		var currObj = IDToObj[can_move_array[can_move-1]]
		currObj.Act()
		await !moving
		print("done waiting for move")
		if(!currObj.attacked):
			print("attacking")
			currObj.Act()
		await get_tree().create_timer(1.0).timeout
	print("done with turn")
	nextTurn()

func nextTurn():
	print("moving turns")
	TurnCount += 1
	var Fac_turn = (TurnCount % factions.size()) + 1
	start_faction_turn(Fac_turn)
	if(Fac_turn == player_faction):
		print("Player Turn")
		player_turn = true
	else:
		print("Turn for faction: ", Fac_turn)
		player_turn = false
		doTurn(Fac_turn)

func actor_move(id, loc, speed = -1):
	if (last_reachable_tiles.has(loc) or speed != -1):
		print("Moving")
		print(Location[id], loc)
		astar_grid.set_point_solid(loc, false)
		print(astar_grid.get_id_path(
			Location[id],
			loc
		))
		
		var id_path = astar_grid.get_id_path(
			Location[id],
			loc
		).slice(1)
		
		astar_grid.set_point_solid(loc, true)
		print(id_path)
		if(speed != -1):
			print("speedOps")
			id_path = id_path.slice(0, speed)
			print(id_path)
			if(id_path.has(loc)):
				print("speedOps in bounds")
				id_path = id_path.slice(0, -1)
		print(id_path)
		if !id_path.is_empty():
			print("imprinting id")
			current_id_path = id_path
		
			print(id_path[-1])
			astar_grid.set_point_solid(Location[id], false)
			astar_grid.set_point_solid(id_path[-1], true)
			
			move_id = id
			Location[id] = id_path[-1]
			
			moving = true
			IDToObj[id].moved = true
			can_move -= 1
			can_move_array.erase(id)
			print("Actually Moving: ", id)
			return true
		else:
			return false
	else:
		return false
	
func get_id(loc, EID=-1):
	for i in Location.size():
		if(loc == Location[i] && i != EID && OpenIDs[i] != 0):
			return i
	return -1

func give_id():
	print("giving id")
	if(OpenIDN == 0):
		OpenIDs.push_back(1)
		Location.push_back(Vector2i(0,0))
		IDToObj.push_back(1)
		return OpenIDs.size()-1 
	else:
		var wid = 0
		while OpenIDs[wid] == 1:
			wid+=1
		OpenIDs[wid] = 1
		OpenIDN -= 1
		return wid
		
func remove_id(ID):
	flop_astar_grid(ID)
	OpenIDs[ID] = 0
	OpenIDN += 1

func flop_astar_grid(ID):
	print(Location[ID])
	astar_grid.set_point_solid(Location[ID], !astar_grid.is_point_solid(Location[ID]))
	
func get_reachable_area(ID, speed):
	var reachable_tiles:Array
	var current_speed = speed
	while current_speed >= 1:
		var x = current_speed
		var y = 0
		var xrot = -1
		var yrot = 1
		while(xrot == -1 or x != current_speed):
			var loc = Location[ID] + Vector2i(x, y)
			if(!reachable_tiles.has(loc)):
				loc = loc.clamp(Vector2i(0,0), tile_map.get_used_rect().size)
				var id_path = astar_grid.get_id_path(
				Location[ID],
				loc).slice(1)
				if(id_path.size() <= speed):
					for tloc in id_path:
						if(!reachable_tiles.has(tloc)):
							reachable_tiles.append(tloc)
			x += xrot
			y += yrot
			if(x == -current_speed):
				xrot = 1
			if(y == current_speed):
				yrot = -1
			if(y == -current_speed):
				yrot = 1
		current_speed -= 1
	reachable_tiles.sort()
	print(reachable_tiles)
	return reachable_tiles

func redisplay_reachable_area():
	if(player_turn):
		rmvInd()
		display_reachable_area(lastID, lastSpd)

func display_reachable_area(ID, speed, dis = true):
	lastID = ID
	lastSpd = speed
	last_reachable_tiles = get_reachable_area(ID, speed)
	print(Location[ID])
	if(dis):
		movement_ind = Node2D.new()
		add_child(movement_ind)
		for tile in last_reachable_tiles:
			var tTile : Sprite2D = mvmnt_ind_piece.instantiate()
			tTile.position = tile*16 + Vector2i(8,8)
			movement_ind.add_child(tTile)
		
func rmvInd():
	movement_ind.queue_free()

func get_in_range_area(ID, speed):
	var reachable_tiles:Array
	var current_speed = speed
	while current_speed >= 1:
		var x = current_speed
		var y = 0
		var xrot = -1
		var yrot = 1
		while(xrot == -1 or x != current_speed):
			var loc = Location[ID] + Vector2i(x, y)
			reachable_tiles.append(loc)
			x += xrot
			y += yrot
			if(x == -current_speed):
				xrot = 1
			if(y == current_speed):
				yrot = -1
			if(y == -current_speed):
				yrot = 1
		current_speed -= 1
	reachable_tiles.sort()
	print(reachable_tiles)
	return reachable_tiles

func display_in_range_area(ID, speed, distance = true):
	lastID = ID
	lastSpd = speed
	last_reachable_tiles = get_in_range_area(ID, speed)
	if(distance):
		movement_ind = Node2D.new()
		add_child(movement_ind)
		for tile in last_reachable_tiles:
			var tTile : Sprite2D = mvmnt_ind_piece.instantiate()
			tTile.position = tile*16 + Vector2i(8,8)
			tTile.modulate = Color(1, 0, 0, .5)
			movement_ind.add_child(tTile)

func actor_deal_damage(actor, target):
	var actor_stats = IDToObj[actor].get_node_or_null("C_Stats")
	print(actor_stats)
	if(actor_stats != null):
		if(get_in_range_area(actor, actor_stats.rang).has(Location[target])):
			var target_health = IDToObj[target].get_node_or_null("C_HP")
			if(target_health != null):
				target_health.damage(actor_stats.str)
