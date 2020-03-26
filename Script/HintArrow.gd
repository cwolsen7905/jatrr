extends Sprite

func _ready():
	position.y = -1025

func _physics_process(_delta):
	if ($"../PlayerBody".position.y < -1054):
		show()
		position.x = $"../PlayerBody".position.x - 5
	if ($"../PlayerBody".position.y > -1054):
		hide()
