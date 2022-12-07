extends Node

const CONFIG_SECTION = "Audio"
const MIN_VOLUME = -80
const MAX_VOLUME = 24

var sound_dic = {
	"bullet":preload("res://assets/audios/bullet.wav"),
	"game_over":preload("res://assets/audios/game_over.wav"),
	"get_double_bullet":preload("res://assets/audios/get_double_bullet.wav"),
	"small_enemy_die":preload("res://assets/audios/small_enemy_die.wav"),
	"medium_enemy_die":preload("res://assets/audios/medium_enemy_die.wav"),
	"large_enemy_die":preload("res://assets/audios/large_enemy_die.wav"),
	"large_enemy_show":preload("res://assets/audios/large_enemy_show.wav"),
	"use_bomb":preload("res://assets/audios/use_bomb.wav")
}

var music_dic = {
	"game_music":preload("res://assets/audios/game_music.ogg")
}

var cur_music:Dictionary = {
	"player":null,
	"name":null
}

func _ready() -> void:
	var music_mute = bool(ConfigMgr.get_value(CONFIG_SECTION,"music_mute",false))
	var sound_mute = bool(ConfigMgr.get_value(CONFIG_SECTION,"sound_mute",false))
	var music_volume = float(ConfigMgr.get_value(CONFIG_SECTION,"music_volume",0.0))
	var sound_volume = float(ConfigMgr.get_value(CONFIG_SECTION,"sound_volume",0.0))
	set_music_mute(music_mute,false)
	set_sound_mute(sound_mute,false)
	set_music_volume(music_volume,false)
	set_sound_volume(sound_volume,false)
	ConfigMgr.save()

func play_sound(sound_name:String)->void:
	if not sound_dic.has(sound_name):
		printerr("不存在音效%s" % sound_name)
		return
	var sound_player:AudioStreamPlayer = AudioStreamPlayer.new()
	sound_player.bus = "Sound"
	sound_player.stream = sound_dic[sound_name]
	sound_player.autoplay = true
	sound_player.connect("finished",sound_player,"queue_free")
	add_child(sound_player)

func play_sound_by_stream(stream:AudioStreamSample)->void:
	var sound_player:AudioStreamPlayer = AudioStreamPlayer.new()
	sound_player.bus = "Sound"
	sound_player.stream = stream
	sound_player.autoplay = true
	sound_player.connect("finished",sound_player,"queue_free")
	add_child(sound_player)

func has_music()->bool:
	return cur_music.name != null

func play_music(music_name:String)->void:
	if not music_dic.has(music_name):
		printerr("不存在音乐%s" % music_name)
		return
	if cur_music.name != music_name:
		cur_music.name = music_name
		var music_player = cur_music.player
		if not music_player: music_player = AudioStreamPlayer.new()
		music_player.bus = "Music"
		music_player.stream = music_dic[music_name]
		music_player.autoplay = true
		cur_music.player = music_player
		add_child(music_player)

func stop_music()->void:
	if not has_music(): return
	var music_player:AudioStreamPlayer = cur_music.player
	music_player.free()
	cur_music.name = null
	cur_music.player = null

func pause_music()->void:
	if not has_music(): return
	var music_player:AudioStreamPlayer = cur_music.player
	music_player.stream_paused = true

func resume_music()->void:
	if not has_music(): return
	var music_player:AudioStreamPlayer = cur_music.player
	music_player.stream_paused = false

func set_music_mute(mute:bool,save:bool = true)->void:
	AudioServer.set_bus_mute(Enum.AudioBus.Music,mute)
	if save: ConfigMgr.set_value(CONFIG_SECTION,"music_mute",String(mute),save)

func set_music_volume(volume:float,save:bool = true)->void:
	AudioServer.set_bus_volume_db(Enum.AudioBus.Music,volume)
	if save: ConfigMgr.set_value(CONFIG_SECTION,"music_volume",String(volume),save)

func set_sound_mute(mute:bool,save:bool = true)->void:
	AudioServer.set_bus_mute(Enum.AudioBus.Sound,mute)
	if save: ConfigMgr.set_value(CONFIG_SECTION,"sound_mute",String(mute),save)

func set_sound_volume(volume:float,save:bool = true)->void:
	AudioServer.set_bus_volume_db(Enum.AudioBus.Sound,volume)
	if save: ConfigMgr.set_value(CONFIG_SECTION,"sound_volume",String(volume),save)

func get_music_volume()->float:
	return AudioServer.get_bus_volume_db(Enum.AudioBus.Music)

func get_sound_volume()->float:
	return AudioServer.get_bus_volume_db(Enum.AudioBus.Sound)

func is_music_muted()->bool:
	return AudioServer.is_bus_mute(Enum.AudioBus.Music)

func is_sound_muted()->bool:
	return AudioServer.is_bus_mute(Enum.AudioBus.Sound)

func _on_sound_finished(sound:AudioStreamPlayer)->void:
	sound.queue_free()
