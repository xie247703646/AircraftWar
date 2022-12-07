extends Node
class_name UIAnimBase

signal anim_finished

export var duration:float = 0.5

var ui = null

func _ready() -> void:
	ui = get_parent()

func play()->void:
	UIMgr.show_input_block()

func _on_anim_finished()->void:
	UIMgr.hide_input_block()
	emit_signal("anim_finished")
