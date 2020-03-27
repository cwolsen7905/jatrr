extends TextureButton

var arrpos = 0
var time = 0

func _on_StartButton_pressed():
	time = 0
	$"../".hide()
	$"../../GUI".show()
	$"../../GUI/TouchScreen/TouchHintLeft".play()
	$"../../GUI/TouchScreen/TouchHintRight".play()
	get_tree().paused = false
	$Start_music2.play(0)
