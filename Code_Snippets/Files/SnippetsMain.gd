@tool
extends EditorPlugin

const NEW_ENTRY = preload("res://addons/Code_Snippets/Files/NewEntry.tscn")
const DOCK = preload("res://addons/Code_Snippets/Files/Dock.tscn")
const SETTINGS = preload("res://addons/Code_Snippets/Files/Settings.tscn")
var TheEntry
var TheDock
var TheSettings

func _enter_tree() -> void:
	TheDock = DOCK.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL,TheDock)
	TheSettings = SETTINGS.instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_RIGHT,TheSettings)
	TheSettings.Dock = TheDock
	TheEntry = NEW_ENTRY.instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR,TheEntry)
	TheEntry.Dock = TheDock


func _exit_tree() -> void:
	TheDock.queue_free()
	remove_control_from_docks(TheDock)
	TheSettings.queue_free()
	remove_control_from_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_RIGHT,TheSettings)
	TheEntry.queue_free()
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR,TheEntry)
