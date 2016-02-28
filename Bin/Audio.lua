----------------------------------
-- Shadow RPG - Audio
-- By Shuenhoy
-- At 2013-01-28 11:28:50
----------------------------------
local alien=require "alien"
local Winmm = alien.load("winmm")
local User32= alien.load("user32")
Winmm.PlaySound:types{"string","int","int"}
User32.MessageBeep:types{"long"}

module(...,package.seeall)

flags={
	sync=0,
	async=1,
	loop=8,
}

value={
	ok=0,
	hand=16,
	question=32,
	tip=48,
	error=64
}
----------------------------------
-- Audio - Play
-- By Shuenhoy
-- At 2013-01-28 11:29:16
----------------------------------
function Play(filename,flag)
	Winmm.PlaySound(filename,0,flag or flags.async)
end
----------------------------------
-- Audio - Stop
-- By Shuenhoy
-- At 2013-01-28 11:29:38
----------------------------------
function Stop()
	Winmm.PlaySound("",0,0)
end
----------------------------------
-- Audio - Beep
-- By Joshua
-- At 2013-01-28 11:40:31
----------------------------------
function Beep(v)
	if type(v)=="string" then
		return User32.MessageBeep(value[v] or 0)
	else
		return User32.MessageBeep(v or 0)
	end
end