class_name Game
extends Node

var HexGrid = preload("./hex_grid.gd").new()
var HexWidth = 3543
var hex_ratio: float
var current_turn = 0
var starting_funds = 1000000

@export var grid_size = 2
@export var hex_scale_size = 50.0

@onready var tile_area = $Tiles
@onready var unit_area = $Units
@onready var hex_tile = preload("res://Scenes/hex_tile.tscn")
@onready var base_freighter = preload("res://Scenes/Units/BaseFreighter.tscn")
@onready var end_turn_button = $UserInterface/BottomUI/HBoxContainer/Button
@onready var turn_counter = $UserInterface/TopUI/HBoxContainer/TurnCounter

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize a hexgrid so that we can use its math
	HexGrid.hex_scale = Vector2(hex_scale_size, hex_scale_size)
	hex_ratio = hex_scale_size / HexWidth
	print("Game.gd: hex ratio: ", hex_ratio)
	
	$HexMap.camera = $"RTS-Camera2D"

	# connect UI signals
	end_turn_button.button_up.connect(_on_end_turn)

	# build the hex grid
	_build_hex_grid()

	# place the base freighter
	_place_initial_freighter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _build_hex_grid():
	for x in range(-1 * grid_size, grid_size + 1):
		for y in range(-1 * grid_size, grid_size + 1):
			_place_tile(x,y)


func _place_tile(x,y):
	print("Game.gd: coords: (", x, ",", y, ")")
	var current_hex_center = HexGrid.get_hex_center(Vector2(x,y))
	print("Game.gd: Hex center: ", current_hex_center)

	# instantiate a hex tile at the hex center
	var current_hex_tile = hex_tile.instantiate()

  # store the hex coordinates of the tile
	current_hex_tile.local_hex_coords = Vector2(x,y)

  # scale the artwork
	current_hex_tile.apply_scale(Vector2(hex_ratio, hex_ratio))

  # place the tile
	current_hex_tile.position = current_hex_center

  # name the tile and add it to the tiles group
	current_hex_tile.name = "Hex: " + str(x) + "," + str(y)
	current_hex_tile.add_to_group("hex_tiles")

  # add the tile to the scene
	tile_area.add_child(current_hex_tile)

func _place_initial_freighter():
	var initial_freighter = base_freighter.instantiate()
	initial_freighter.base_setup(5)

	var zero_hex = HexGrid.get_hex_center(Vector2(0,0))
	initial_freighter.position = zero_hex
	initial_freighter.apply_scale(Vector2(0.5, 0.5))

	initial_freighter.add_to_group("units")
	unit_area.add_child(initial_freighter)


# signal handling

func _on_end_turn():
	print("Game.gd: turn button pressed!")
	current_turn += 1
	turn_counter.text = str(current_turn)
