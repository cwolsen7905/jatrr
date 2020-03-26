extends Sprite

var POSX = 1
var POSY = 1
var ROT = 0.01
var START_POSITON
var COOL_DOWN = 0

func _ready():
	START_POSITON = position
	randomize()
	ROT = rand_range(-0.02, 0.02)
	POSX = rand_range(1, 2)
	POSY = rand_range(1, 2)

func _physics_process(_delta):
	if Constants.robe_active == true && COOL_DOWN < Constants.score_time:
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
	if (($"../../../".GAME == false || Constants.robe_active == false) && (position != START_POSITON)):
		position = START_POSITON

func _on_Area2D_area_entered(area):
	var groups = area.get_groups()
	if(groups.has("player") && Constants.robe_active == true):
		$"../../../FO".play()
		position = START_POSITON
		COOL_DOWN = Constants.score_time + rand_range(15, 45)
		Constants.score += 5
