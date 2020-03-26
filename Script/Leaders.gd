extends Control

var list
var FILE = 'user://leaders.list'
var gamedata = 'user://gamedata-test.save'
var fs = File.new()
var max_score = 0

func update():
	$GetLeaders.request(Constants.serverAddress + 'Leaders')

func _print_list():
	$BlackBack/List.text = list

func _on_GetLeaders_request_completed(_result, response_code, _headers, body):
	list = body.get_string_from_utf8()
	$BlackBack/YourScore.text = 'Your max score: ' + str($"../".max_score)
	if(response_code == 200):
		fs.open(FILE, File.WRITE)
		fs.store_string(list)
		fs.close()
		_print_list()
	else:
		fs.open(FILE, File.READ)
		list = fs.get_as_text()
		fs.close()
		_print_list()

func _on_Back_pressed():
	self.hide()
	$"../End_screen".show()
