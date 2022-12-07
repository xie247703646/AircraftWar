extends Node2D
class_name Game

var enemy_scene_arr:Array = [
	{
		"scene":preload("res://scenes/game/enemy/SmallEnemy.tscn"),
		"weight":70
	},
	{
		"scene":preload("res://scenes/game/enemy/MediumEmemy.tscn"),
		"weight":20
	},
	{
		"scene":preload("res://scenes/game/enemy/LargeEnemy.tscn"),
		"weight":10
	}
]

var supply_scene_arr:Array = [
	{
		"scene":preload("res://scenes/game/supply/Bomb.tscn"),
		"weight":30
	},
	{
		"scene":preload("res://scenes/game/supply/DoubleBullet.tscn"),
		"weight":70
	}
]

var enemy_spawn_weight_arr:Array = []
var supply_spawn_weight_arr:Array = []

onready var aircraft_container: Node2D = $AircraftContainer
onready var bullet_container: Node2D = $BulletContainer
onready var supply_container: Node2D = $SupplyContainer
onready var fx_container: Node2D = $FxContainer
onready var spawn_pos: Position2D = $SpawnPos
onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
onready var supply_spawn_timer: Timer = $SupplySpawnTimer
onready var player: Player = $AircraftContainer/Player

var cur_score:int = 0

func _ready() -> void:
	_init_enemy_spawn()
	_init_supply_spawn()
	UIMgr.show_input_block()
	AudioMgr.play_music("game_music")

func on_player_ready()->void:
	UIMgr.hide_input_block()
	player.start_shoot()

func _init_enemy_spawn()->void:
	for i in range(enemy_scene_arr.size()):
		var data = enemy_scene_arr[i]
		enemy_spawn_weight_arr.append(data.weight)

func _init_supply_spawn()->void:
	for i in range(supply_scene_arr.size()):
		var data = supply_scene_arr[i]
		supply_spawn_weight_arr.append(data.weight)

func _on_EnemySpawnTimer_timeout() -> void:
	var idx = MathUtil.rand_weight(enemy_spawn_weight_arr)
	var enemy_scene:PackedScene = enemy_scene_arr[idx].scene
	var enemy_ins:EnemyBase = enemy_scene.instance()
	var rand_pos_x = rand_range(0,OS.window_size.x)
	enemy_ins.global_position = Vector2(rand_pos_x,spawn_pos.global_position.y)
	aircraft_container.add_child(enemy_ins)

func _on_SupplySpawnTimer_timeout() -> void:
	var idx = MathUtil.rand_weight(supply_spawn_weight_arr)
	var supply_scene:PackedScene = supply_scene_arr[idx].scene
	var supply_ins:SupplyBase = supply_scene.instance()
	var rand_pos_x = rand_range(0,OS.window_size.x)
	supply_ins.global_position = Vector2(rand_pos_x,spawn_pos.global_position.y)
	supply_container.add_child(supply_ins)
