@tool
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func entrar():
	animation_player.play("new_animation")

func accion_primaria():
	animation_player.play("animacion_1")

func accion_secundaria():
	animation_player.play("animacion_2")

func accion_terciaria():
	animation_player.play("animacion_3")

func salir():
	animation_player.play("RESET")
