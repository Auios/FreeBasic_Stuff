#include "window9.bi"

enum
  text = 1
  button
  rebar
end enum

var win = OpenWindow("RebarGadget",10,10,300,300)
CenterWindow(win)

TextGadget(text,10,10,100,20,"Text")

ButtonGadget(button,10,10,100,20,"Button")

RebarGadget(rebar)
AddRebarTab(rebar,button)
AddRebarTab(rebar,text) 

var event = 0
Do
  event = WaitEvent()
  if Event=EventClose Then End
Loop



