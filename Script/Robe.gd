extends Node2D

var trans = Vector2(0.1, 0.1)

func _physics_process(delta):
	$Sprite.scale += trans * delta #delta was not originally part of this
	if ($Sprite.scale.x > 3):
		trans = -trans
	if ($Sprite.scale.x < 2):
		trans = -trans
	position.y += 1.3
	if position.y > 1281:
		queue_free()
	elif Constants.robe_active == true:
		queue_free()

func _on_RobeArea_area_entered(area):
	
	var groups = area.get_groups()
	if(groups.has("player") && Constants.robe_active == false):
		queue_free()
		Constants.robe_active = true
		Constants.robe_spawned = false
		$"../../Player/PlayerBody/AnimatedSprite".play("wr_jumping")
		$"../../GameMusic".stop()
		$"../../GameMusic2".play()
