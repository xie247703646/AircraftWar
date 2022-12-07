extends Control
class_name UIBase

export(UI.Type) var ui_type = UI.Type.Common
var open_anim
var close_anim

var ui_name:String = ''

func on_open(data):
	pass

func on_close(data):
	pass

func close()->bool:
	return UIMgr.close_ui(ui_name)
