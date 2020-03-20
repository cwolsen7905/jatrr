extends Node

const SPEED 	= 120

var back_size
var CURRENT_VERSION

var screenW			= 0
var timer			= 0
var score			= 0
var score_time		= 0
var max_score		= 0
var need_save		= false
var gamedata 		= 'user://game_data.save'
var playernamedata	= 'user://player_data.save'
var playername		= ''
var CanChangeNick 	= false
var fs				= File.new()
var fsp				= File.new()
var GAME 			= true
var SAVE			= 0
var RECORD			= ''
var AnimRecord		= false
var on_floor		= false
var planke			= preload("res://Scenes/Plank.tscn")
var hearthe			= preload("res://Scenes/Health.tscn")
var robe_tscn		= preload("res://Scenes/Robe.tscn")
var spawnhearth		= 0
var spawn_robe		= 0
var VERSION			= '0.95'
var response		= 0
var network			= false
var ValidName		= false
var server_address = ''


func _ready():
	$Pause_screen/VersionLabel.text = 'Version' + VERSION
	back_size = $Background/background_image.texture.get_size()
	screenW = get_viewport().get_visible_rect().size.y
	fs.open(gamedata, File.READ)
	max_score = fs.get_64()
	fs.close()
	fsp.open(playernamedata, File.READ)
	playername = fsp.get_as_text()
	fsp.close()
	$VersionGet.request("https://jatrr.dev.spherepbx.com/current-version")
	$GetServerAddres.request("https://jatrr.dev.spherepbx.com/rank-server")
	get_tree().paused = true

func savename(data):
	fsp.open(playernamedata, File.WRITE)
	fsp.store_string(data)
	fsp.close()

func savegame():
	fs.open(gamedata, File.WRITE)
	fs.store_64(score)
	fs.close()

func _physics_process(delta):
	$Background/background_image.position.y += SPEED * delta
	$Background/background_image2.position.y += SPEED * delta
	if $Background/background_image.position.y - back_size.y > 0:
		$Background/background_image.position.y = $Background/background_image2.position.y - back_size.y
	if $Background/background_image2.position.y - back_size.y > 0:
		$Background/background_image2.position.y = $Background/background_image.position.y - back_size.y
	timer += delta
	if timer > 0.7:
		var plank = planke.instance()
		randomize()
		plank.position.y = screenW - rand_range(1280, 1380)
		randomize()
		plank.position.x = rand_range(30, 656)
		$planks.add_child(plank)
		score_time += 1
		#if (score_time == Constants.intro_loop): #MrOlsen MUSIC
		#	$"Start_screen/StartButton/Start_music2".stop()
		#if (score_time == Constants.intro_loop):
		#	$GameMusic.play()
		randomize()
		spawnhearth = rand_range(0, 24)
		spawnhearth = round(spawnhearth)
		if (score_time > 34 && spawnhearth == 0): #MrOlsen Music
			var hearth = hearthe.instance()
			var robe = robe_tscn.instance()
			randomize()
			hearth.position.y = screenW - rand_range(1280, 1380)
			randomize()
			hearth.position.x = rand_range(30, 676)#30
			$hearths.add_child(hearth)
			$hearths.add_child(robe)
		timer = 0
		
	$GUI/score.text = 'Score: ' + str(score) + RECORD
	
	$End_screen/ColorRect/your_score.text = 'Your Score: ' + str(score)
	
	if (max_score < score):
		RECORD = '!'
		AnimRecord = true
		
	if (max_score > score):
		need_save = false
		
		$End_screen/ColorRect/max_score.text = 'Max Score: ' + str(max_score)
	else:
		need_save = true
		
		$End_screen/ColorRect/max_score.text = 'Max Score: ' + str(score)
		max_score = score

func _on_Exit_pressed():
	if (need_save == true):
		savegame()
	get_tree().quit()

func _on_PauseButton_pressed():
	get_tree().paused = true
	$Pause_screen.show()

func _on_Resume_pressed():
	$Pause_screen.hide()
	get_tree().paused = false
	
func _on_Retry_pressed(): #Retry MrOlsen
	Constants.intro_done = 0
	
	$Player/PlayerBody.life = true
	
	RECORD = ''
	AnimRecord = false
	if (need_save == true):
		savegame()
	SAVE = 0
	score_time = 0
	score = 0
	$End_screen.hide()
	$GUI.show()
	$StartPlank.timer=0
	$StartPlank.position.x=0
	$StartPlank.position.y=200
	for i in $planks.get_children():
		i.queue_free()
	for i in $hearths.get_children():
		i.queue_free()
	GAME = true
	get_tree().paused = false
	
	$Start_screen/StartButton/Start_music2.play(0)
	#$Start_screen/StartButton/Start_music2/StartSound.play('soundstart')
	$GameMusic.stop()
	
	Constants.intro_done = 0

func _on_BackFromAboutMe_pressed():
	$Pause_screen/Buttons.show()
	$Pause_screen/AboutMe.hide()

func _on_AboutMe_pressed():
	$Pause_screen/Buttons.hide()
	$Pause_screen/AboutMe.show()

func _on_BackFromAboutSettings_pressed():
	$Pause_screen/Buttons.show()
	$Pause_screen/Settings.hide()

func _on_Settings_pressed():
	$Pause_screen/Buttons.hide()
	$Pause_screen/Settings.show()

func _on_VersionGet_request_completed(result, response_code, _headers, body):
	if (result == HTTPRequest.RESULT_SUCCESS):
		response = response_code
		CURRENT_VERSION = body.get_string_from_utf8()
		if (playername == "Anonymous"):
			CanChangeNick = true
			$Pause_screen/Buttons/Change_nick.show()
		elif(playername != ''):
			$Pause_screen/Buttons/Change_nick.show()
			pass
		else:
			CanChangeNick = true
			if(response_code == 200):
				$NameInput.show()
		if(VERSION + "\n" != CURRENT_VERSION && response_code == 200):
			network = true
			$Start_screen/ColorRect/New_version.show()

func send_score(player, new_score):
	var player_send = str(player)
	var score_send = str(new_score)
	var d = {"name": player_send, "score": score_send}
	var query = JSON.print(d)
	var headers = ["Content-Type: application/json"]
	$ResultSend.request(Constants.serverAddress + 'ScriptScore.php', headers, false, HTTPClient.METHOD_POST, query)


func _on_Skip_pressed():
	savename("Anonymous")
	CanChangeNick = true
	$Pause_screen/Buttons/Change_nick.show()
	$NameInput.hide()

func _on_ApplyNick_pressed():
	var nameinput = $NameInput/ColorRect/NikLine.get_text()
	var email = $NameInput/ColorRect/EmailLine.get_text()
	var d = {"name": nameinput, "email": email}
	var query = JSON.print(d)
	var headers = ["Content-Type: application/json"]
	if(nameinput != ''):
		$CheckName.request(Constants.serverAddress + 'CheckName.php', headers, false, HTTPClient.METHOD_POST, query)

func _on_Change_nick_pressed():
	$NameInput.show()

func _on_CheckName_request_completed(_result, _response_code, _headers, body):
	var Valid = body.get_string_from_utf8()
	var nameinput = $NameInput/ColorRect/NikLine.get_text()
	if(Valid  == "false\n"):
		$NameInput/ColorRect/FreeOrNot.show()
	if(Valid  == "true\n"):
		$NameInput/ColorRect/FreeOrNot.hide()
		send_score(nameinput, max_score)
		savename(nameinput)
		playername = nameinput
		CanChangeNick = false
		$Pause_screen/Buttons/Change_nick.hide()
		$NameInput.hide()

func _on_GetServerAddres_request_completed(_result, response_code, _headers, body):
	if (response_code == 200):
		Constants.serverAddress = body.get_string_from_utf8().replace('\n', '')
	else:
		Constants.serverAddress = 'https://jatrr.dev.spherepbx.com/'
	Constants.serverAddress = 'https://jatrr.dev.spherepbx.com/'


func _on_Start_music2_finished():
	print_debug("music finished")
	Constants.intro_done = 1
	$GameMusic.play()
