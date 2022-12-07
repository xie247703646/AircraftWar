extends Node

var game_scene:PackedScene = preload("res://scenes/game/Game.tscn")

var _game_root:Node2D
var _game:Game
var is_game_over:bool = true

func init(game_root:Node2D)->void:
	_game_root = game_root

func start_game()->void:
	is_game_over = false
	_game = game_scene.instance()
	_game_root.add_child(_game)
	UIMgr.open_ui(UI.UIGame)

func pause_game()->void:
	get_tree().paused = true

func resume_game()->void:
	get_tree().paused = false
	SignalMgr.emit_signal("game_resumed")

func game_over()->void:
	is_game_over = true
	get_tree().paused = false
	UIMgr.close_ui(UI.UIGame)
	_game.queue_free()
	_game = null
	UIMgr.open_ui(UI.UIMain)

func get_bullet_container()->Node2D:
	return _game.bullet_container

func get_aircraft_container()->Node2D:
	return _game.aircraft_container

func add_score(score:int)->void:
	if is_game_over: return
	_game.cur_score += score
	SignalMgr.emit_signal("score_updated",_game.cur_score)

func play_fx(fx_scene:PackedScene,global_pos:Vector2)->void:
	var fx:Node2D = fx_scene.instance()
	_game.fx_container.add_child(fx)
	fx.global_position = global_pos

func is_in_game()->bool:
	return _game != null
