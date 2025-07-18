@tool
extends Control

@onready var window: Window = $Window
@onready var DirOptions: OptionButton = $Window/VBoxContainer/HBoxContainer/OptionButton
@onready var CodeBox: CodeEdit = $Window/VBoxContainer/CodeEdit
@onready var NameEdit: LineEdit = $Window/VBoxContainer/HBoxContainer/LineEdit

var save_path = "res://addons/Code_Snippets/Files/settings.save"
var Settings: Dictionary
var Dock

func Load():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var SettingsText = file.get_line()
		file.close()
		var SettingsJson = JSON.new()
		var error = SettingsJson.parse(SettingsText)
		Settings = SettingsJson.data
	
	CodeBox.text = DisplayServer.clipboard_get()
	
	DirOptions.clear()
	for Dir in Settings["Paths"]:
		var TheName = Dir.get_file()
		DirOptions.add_item(TheName)


func _on_add_snip_pressed() -> void:
	window.visible = true
	Load()

func _on_window_close_requested() -> void:
	window.visible = false


func _on_save_pressed() -> void:
	var ThePath = Settings["Paths"][DirOptions.selected] + "/"
	var FileName: String
	if NameEdit.text != "":
		if NameEdit.text.get_extension() == Settings["Extension"]: FileName = NameEdit.text
		else: FileName = NameEdit.text + "." + Settings["Extension"]
	else:
		push_error("Don't leave file name empty")
		return
	var file = FileAccess.open(ThePath + FileName, FileAccess.WRITE)
	file.store_string(CodeBox.text)
	file.close()
	window.visible = false
	Dock.Reload()
