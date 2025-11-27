class_name FastLED extends Node


func fill_soild(targetArray: PackedColorArray, numToFill, color: Color):
	for i in numToFill:
		targetArray[i] = color
