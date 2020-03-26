extends Node2D

 
var POSX = 1
var POSY = 1
var ROT = 0
var START_POSITON

func _ready():
	START_POSITON = position
	randomize()
	ROT = rand_range(-0.02, 0.02)
	POSX = rand_range(1, 2)
	POSY = rand_range(1, 2)

func _physics_process(_delta):
	if (Constants.robe_active == true):
		if position.x > 800:
			POSX = -POSX
		if position.x < -100:
			POSX = -POSX
		if position.y > 1380:
			POSY = -POSY
		if position.y < -100:
			POSY = -POSY
		position.x += POSX
		position.y += POSY
		rotation += ROT
	if (($"../../".GAME == false || Constants.robe_active == false) && position != START_POSITON):
		position = START_POSITON
