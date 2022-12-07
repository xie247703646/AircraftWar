extends Node

#ui场景路径
var _ui_path:String = "res://scenes/ui/%s.tscn"
#保存当前已打开的ui
var _open_ui_dic:Dictionary = {}
#记录当前已打开的window
var _window_stack:Array = []

#ui根节点
var _ui_root:CanvasLayer
#用于屏蔽玩家点击
var _input_block:Control
#window后面的遮罩
var _window_mask:Control

func init(ui_root:CanvasLayer,input_block:Control,window_mask:Control)->void:
	_ui_root = ui_root
	_input_block = input_block
	_window_mask = window_mask

func open_ui(ui_name:String,data = null)->UIBase:
	if not _ui_root:
		printerr('ui根节点为空')
		return null
	if is_ui_opened(ui_name):
		printerr('%s已经打开'%ui_name)
		return null
	var path = _ui_path % ui_name
	if not ResourceLoader.exists(path,"PackedScene"):
		printerr('不存在路径为%s的ui场景'%[path])
		return null
	var ui_scene:PackedScene = load(path)
	if not ui_scene:
		printerr('%s加载失败'%[ui_name])
		return null
	var ui_node:UIBase = ui_scene.instance()
	if not ui_node:
		printerr('%s实例化失败'%[ui_name])
		return null
	if not ui_node.has_method("on_open"):
		printerr('%s没有on_open方法'%[ui_name])
		return null
	print('打开%s' % ui_name)
	var ui_type = ui_node.ui_type
	var ui_parent = _ui_root.get_child(ui_type)
	ui_parent.add_child(ui_node)
	#如果ui是window，则需要在其后面显示遮罩
	if ui_type == UI.Type.Window:
		var idx = ui_node.get_index()
		_window_mask.visible = true
		ui_parent.move_child(_window_mask,idx - 1)
		_window_stack.append(ui_name)

	ui_node.on_open(data)
	ui_node.ui_name = ui_name
	_open_ui_dic[ui_name] = ui_node
	SignalMgr.emit_signal("ui_opened",ui_name)
	var open_anim:UIOpenAnim = ui_node.open_anim
	if open_anim: open_anim.play()
	return ui_node

func close_ui(ui_name:String,data = null)->bool:
	if not is_ui_opened(ui_name):
		printerr('%s暂未打开'%[ui_name])
		return false
	var ui_node:UIBase = _open_ui_dic.get(ui_name)
	if not ui_node.has_method("on_close"):
		printerr('%s没有on_close方法'%[ui_name])
		return false

	print('关闭%s'%[ui_name])

	var ui_type = ui_node.ui_type
	if ui_type == UI.Type.Window:
		_window_stack.erase(ui_name)
		if _window_stack.size() <= 0:
			_window_mask.visible = false
		else:
			var top_window = _window_stack[_window_stack.size() - 1]
			var idx = get_ui(top_window).get_index()
			_window_mask.get_parent().move_child(_window_mask,max(0,idx - 1))

	var close_anim:UICloseAnim = ui_node.close_anim
	if close_anim:
		close_anim.play()
		yield(close_anim,"anim_finished")
	ui_node.on_close(data)
	_open_ui_dic.erase(ui_name)
	SignalMgr.emit_signal("ui_closed",ui_name)
	ui_node.queue_free()
	return true

func is_ui_opened(ui_name:String)->bool:
	return _open_ui_dic.has(ui_name)

func get_ui(ui_name:String)->UIBase:
	if not is_ui_opened(ui_name):
		printerr('%s暂未打开'%[ui_name])
		return null
	return _open_ui_dic.get(ui_name)

func show_input_block()->void:
	_input_block.visible = true

func hide_input_block()->void:
	_input_block.visible = false
