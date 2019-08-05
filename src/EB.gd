extends Node

#singleton file for helper functions and stuff like that
var codeLibraries = {
	"Lvl":"res://src/Lvl.gd"
	}

func import(codeLibrary):
	return load(codeLibraries[codeLibrary])