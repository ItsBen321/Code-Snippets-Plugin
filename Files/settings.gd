@tool
extends Control

@onready var DirBox: VBoxContainer = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/HBoxContainer/ScrollContainer/VBoxContainer
@onready var DirButtonBox: VBoxContainer = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/HBoxContainer/VBoxContainer2
@onready var CodeExample: CodeEdit = $VBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/CodeEdit
@onready var Spinbox: SpinBox = $VBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/SpinBox
@onready var ExtEdit: LineEdit = $VBoxContainer/VBoxContainer/HBoxContainer3/HBoxContainer/LineEdit


var save_path = "res://addons/Code_Snippets/Files/settings.save"
var Settings: Dictionary
var DirMenu: Dictionary
var NewFile
var Dock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var SettingsText = file.get_line()
		file.close()
		var SettingsJson = JSON.new()
		var error = SettingsJson.parse(SettingsText)
		Settings = SettingsJson.data
	else:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		var SettingsData = JSON.stringify(ResetSettings())
		Settings = ResetSettings()
		file.store_line(SettingsData)
		file.close()
		
	LoadSettingsMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ResetSettings():
	return {
		"Paths": ["res://addons/Code_Snippets/Code","res://addons/Code_Snippets/Shaders"],
		"Extension" : "gd",
		"FontSize" : 10
	}

func SaveSettings(TheSettings):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var SettingsData = JSON.stringify(TheSettings)
	file.store_line(SettingsData)
	file.close()

func LoadSettingsMenu():
	DirMenu.clear()
	for child in DirBox.get_children():
		DirBox.remove_child(child)
		child.queue_free()
	for child in DirButtonBox.get_children():
		DirButtonBox.remove_child(child)
		child.queue_free()
	for Dir in Settings["Paths"]:
		var NewLabel = Label.new()
		NewLabel.text = Dir
		DirBox.add_child(NewLabel)
		var NewButton = Button.new()
		NewButton.text = "Remove"
		DirButtonBox.add_child(NewButton)
		NewButton.connect("pressed",RemoveDir.bind(NewButton))
		DirMenu[NewButton] = NewLabel
	var NewButton = Button.new()
	NewButton.text = "Add"
	DirButtonBox.add_child(NewButton)
	NewButton.connect("pressed",AddDir)
	AddFileDialog()
	CodeExample.add_theme_font_size_override("font_size", Settings["FontSize"])
	Spinbox.value = float(Settings["FontSize"])
	ExtEdit.text = Settings["Extension"]
	
func RemoveDir(TheButton):
	var SelectedPath = DirMenu[TheButton].text
	Settings["Paths"].erase(SelectedPath)
	SaveSettings(Settings)
	LoadSettingsMenu()
	Dock.Reload()

func AddFileDialog():
	NewFile = FileDialog.new()
	NewFile.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	NewFile.access = FileDialog.ACCESS_FILESYSTEM
	NewFile.title = "Open Snippets Location"
	NewFile.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	DirBox.add_child(NewFile)
	NewFile.connect("dir_selected", NewPath)

func NewPath(ThePath):
	Settings["Paths"].append(ThePath)
	SaveSettings(Settings)
	LoadSettingsMenu()
	Dock.Reload()

func AddDir():
	NewFile.visible = true


func _on_reset_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var SettingsData = JSON.stringify(ResetSettings())
	Settings = ResetSettings()
	file.store_line(SettingsData)
	file.close()

	LoadSettingsMenu()
	Dock.Reload()


func _on_spin_box_value_changed(value: float) -> void:
	Settings["FontSize"] = int(value)
	SaveSettings(Settings)
	LoadSettingsMenu()
	Dock.Reload()


func _on_button_pressed() -> void:
	Settings["Extension"] = ExtEdit.text
	SaveSettings(Settings)
	LoadSettingsMenu()
	Dock.Reload()
