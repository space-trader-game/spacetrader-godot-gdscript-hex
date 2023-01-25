class_name Game
extends Node

var HexGrid = preload("./hex_grid.gd").new()
var HexWidth = 3543
var hex_ratio: float
var current_turn = 0

@export var grid_size = 4
@export var hex_scale_size = 50.0

@onready var hex_tile = preload("res://Scenes/hex_tile.tscn")
@onready var end_turn_button = $UserInterface/BottomUI/HBoxContainer/Button
@onready var turn_counter = $UserInterface/TopUI/HBoxContainer/TurnCounter

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize a hexgrid so that we can use its math
	HexGrid.hex_scale = Vector2(hex_scale_size, hex_scale_size)
	hex_ratio = hex_scale_size / HexWidth
	print("Game.gd: hex ratio: ", hex_ratio)

	# connect UI signals
	end_turn_button.button_up.connect(_on_end_turn)

	# build the hex grid
	_build_hex_grid()


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

	current_hex_tile.local_hex_coords = Vector2(x,y)

	current_hex_tile.apply_scale(Vector2(hex_ratio, hex_ratio))
	current_hex_tile.position = current_hex_center + Vector2(960,540)

	add_child(current_hex_tile)

func _on_end_turn():
	print("Game.gd: turn button pressed!")
	current_turn += 1
	turn_counter.text = str(current_turn)
