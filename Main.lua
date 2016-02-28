--------------------------------------------
-- Project - The Snake
-- By Joshua
-- At 2013-09-21 19:58:04
-- FA 2013-11-30 18:43:58
--------------------------------------------
-- Thanks Shuenhoy for the lua-library(lcon)
--------------------------------------------
require("lcon")
require("cio")

math.randomseed(os.time())
----------------------------
-- The Snake - Map
-- By Joshua
-- At 2013-9-23 14:58:15
-- RC 2013-11-30 12:16:26
----------------------------
-- Game Info
----------------------------
-- Game Window
-- ##...##(90)		|
-- #(...)#(1+88+1)	|
-- #(...)#         	|  30 lines x 90 points
-- ... ...			|
-- ##...##(90)		|
-- gray box
-- gray box
-- black line
----------------------------
do
	local point = 0
	local pos = {}
	local def_speed = 5 -- Game Level (How often does it move again? -- 1 : 0.5, 2: 0.45, ...)
	local speed = def_speed
					-- What's decide the speed? emm...
					-- def is 3. you can change it.
	local direction = 1 -- 1 for up, 2 for down; 3 for left, 4 for right. (changed)
						-- no. 1 for up, 2 for left, 3 for right, 4 for down. 
						-- why? (5 - dir) can get another dir. such as 1, 4 - up, down.
	local t_direction = 1
	local startTime = 0	-- when the game start, record it
	local lastTime = 0	-- last time to refresh
	local nick = ""
	
	function init()
		direction = 1
		t_direction = 1
		speed = def_speed
		pos = {}
		point = 0
	end
	
	function recordNick(n)
		nick = n
	end
	
	function getPauseTime()
		return 0.5 - (speed - 1) * 0.05
	end
	
	function getNick()
		return nick
	end
	
	function speedUp()
		if speed < 9 then
			speed = speed + 1
		end
	end
	
	function getPoint()
		return point
	end
	
	function randomPoint()
		local t = {}
		for k = 1, 88 do
			for j = 1, 28 do
				for p = 1, #pos do
					if pos[p][1] == k and pos[p][2] == j then
						break
					end
				end
				table.insert(t, {k, j})
			end
		end
		return t[math.random(1, #t)]
	end
	
	--1 2 3 4 (up left down right) ()
	
	function changeDirection(n)
		if (5 - direction) ~= n then
			t_direction = n
		end
	end
	
	function getStartTime()
		return startTime
	end
	
	function checkDie()
		if pos[1][1] == 0 or pos[1][1] == 89 or pos[1][2] == 0 or pos[1][2] == 29 then
			return true
		end
		for k = 2, #pos do
			if pos[1][1] == pos[k][1] and pos[1][2] == pos[k][2] then
				return true
			end
		end
		return false
	end
	
	function moveHead()
		direction = t_direction
		local pl = {{0, -1}, {-1, 0}, {1, 0}, {0, 1}}
		local t = {pos[1][1] + pl[direction][1], pos[1][2] + pl[direction][2]}
		if t[1] == pos[0][1] and t[2] == pos[0][2] then
			point = point + 1
			if point % 10 == 0 then
				speedUp()
			end
			for k = #pos + 1, 2, -1 do
				pos[k] = pos[k - 1]
			end
			pos[0] = randomPoint()
			pos[1] = t
			lcon.gotoXY(pos[1][1], pos[1][2])
			io.write("@")
			lcon.gotoXY(pos[0][1], pos[0][2])
			io.write("o")
		else
			lcon.gotoXY(pos[#pos][1], pos[#pos][2])
			io.write(" ")
			for k = #pos, 2, -1 do
				pos[k] = pos[k - 1]
			end
			lcon.gotoXY(pos[1][1], pos[1][2])
			io.write("*")
			pos[1] = t 
			lcon.gotoXY(pos[1][1], pos[1][2])
			io.write("@")
		end
	end	
	
	function initPos()
		pos[0] = {unpack(randomPoint())} -- Dot
		pos[1] = {45, 14} -- Snake's Head
		pos[2] = {45, 15}
		pos[3] = {45, 16}
	end
	
	function getPos()
		return pos
	end
	
	function recordStartTime()
		startTime = os.clock()
		lastTime = startTime
	end
	
	function refreshTime(t)
		if t - lastTime > getPauseTime() then
			lastTime = t
			return true
		end
		return false
	end
	
	function resetStatus()
		clearScrn()
		lcon.gotoXY(0, 30)
		lcon.set_colorx(11, 8)
		io.write("  Player:                         Point :                  Speed :                        ")
		lcon.gotoXY(0, 31)
		io.write("  Time  :                         Length:                  Status:                        ")
		lcon.gotoXY(0, 0)
		lcon.set_colorx(7, 0)
	end

	function refreshStatus(status)
		lcon.set_colorx(15, 8)
		lcon.gotoXY(10, 30)
		io.write(nick)
		lcon.gotoXY(42, 30)
		io.write(point)
		lcon.gotoXY(67, 30)
		io.write(speed)
		lcon.gotoXY(10, 31)
		io.write(os.clock() - startTime)
		lcon.gotoXY(42, 31)
		io.write(point + 3)
		lcon.gotoXY(67, 31)
		io.write(status)
		lcon.set_colorx(7, 0)
	end
end

function toLua(o, f)
	if type(o) == "number" then
		f:write(o)
	elseif type(o) == "string" then
		f:write(string.format("%q", o))
	elseif type(o) == "table" then
		f:write("{\n")
		for k, v in pairs(o) do
			f:write("[ ")
			toLua(k, f)
			f:write(" ] = ")
			toLua(v, f)
			f:write(",\n")
		end
		f:write("}\n")
	end
end

function clearScrn()
	os.execute("@cls")
end

function setTitle()
	os.execute("@title The Snake")
end

function systemInit()
	os.execute("@title The Snake & mode con cols=90 lines=33 & cls")
	lcon.hide_cursor()
end

function resetMap()
	local tp = getPos()
	lcon.gotoXY(0, 0)
	io.write(("#"):rep(90))
	for k = 1, 28 do
		io.write("#", (" "):rep(88), "#")
	end
	io.write(("#"):rep(90))
	lcon.gotoXY(unpack(tp[0]))
	io.write("o")
	lcon.gotoXY(unpack(tp[1]))
	io.write("@")
	for k = 2, #tp do
		lcon.gotoXY(unpack(tp[k]))
		io.write("*")
	end
end

function waitEnter()
	while lcon.getch() ~= 13 do
	end
end

function showMenu()
	lcon.cls_c(7, 0)
	lcon.gotoXY(0, 0)
	io.write([[
	
				
				
				[lred >>> The Snake <<<]
		
		
		
		
		
			[lyellow Are you ready to start this game?]
		
		
		
		
		
				      [lsgreen <START>]
	]])
	waitEnter()
end

function startGame(nick)
	recordStartTime()
	local status = "playing"
	local keyboard = {[72] = 1, [75] = 2, [77] = 3, [80] = 4}
	initPos()
	resetStatus()
	resetMap()
	repeat
		while lcon.kbhit() == 1 do
			local k = lcon.getch()
			if keyboard[k] then
				changeDirection(keyboard[k])
			end
		end
		if refreshTime(os.clock()) then
			moveHead()
		end
		if checkDie() then
			status = "died"
		end
		refreshStatus(status)
	until status == "died"
	
	return getPoint()
end

function showPoint(nick, point)
	lcon.gotoXY(0, 0)
	lcon.cls_c(14, 8)
	io.write("\n\n\n\n\n\n\n\n\n\n\n\t\t\t\t   === Game Over ===\n\t\t\t\t   ", nick, ", \n\t\t\t\t       Your point: ", point, "\n\t\t\t\t       Your time : ", os.clock() - getStartTime(), "\n\n\t\t\t\t     Enter to back")
	waitEnter()
end

function recordPoint(nick, point)
	pcall(dofile, "Score.rec")			-- safe? no...
	if not recList then 		-- No Score Record or Changed by user
		recList = {
			{player = "---", points = 0},
			{player = "---", points = 0},
			{player = "---", points = 0},
			{player = "---", points = 0},
			{player = "---", points = 0}
		}
	end
	table.insert(recList, {player = nick, points = point})
	table.sort(recList, (function(a, b)
		return a.points > b.points
	end))
	table.remove(recList, 6)
	os.remove("Score.rec")
	local f = io.open("Score.rec", "a")
	f:write("recList = ")
	toLua(recList, f)
	f:close()
	os.execute("@bin\\luac.exe -o Score.rec Score.rec")
	lcon.cls_c(14, 8)
	lcon.gotoXY(35, 9)
	io.write("=== The Score List ===")
	lcon.gotoXY(28, 10)
	io.write(string.format("[lred | 1st | %-20s | %3s |]", recList[1].player, tostring(recList[1].points)))
	lcon.gotoXY(28, 11)
	io.write(string.format("[lyellow | 2nd | %-20s | %3s |]", recList[2].player, tostring(recList[2].points)))
	lcon.gotoXY(28, 12)
	io.write(string.format("[lblue | 3rd | %-20s | %3s |]", recList[3].player, tostring(recList[3].points)))
	lcon.gotoXY(28, 13)
	io.write(string.format("[white | 4th | %-20s | %3s |]", recList[4].player, tostring(recList[4].points)))
	lcon.gotoXY(28, 14)
	io.write(string.format("[white | 5th | %-20s | %3s |]", recList[5].player, tostring(recList[5].points)))
	lcon.gotoXY(33, 17)
	io.write("[lsgreen Try again? Enter to back.]")
	waitEnter()
end

function getPlayerNick()
	clearScrn()
	io.write([[
	
				
				
				[lred >>> The Snake <<<]
		         
				 
		
		
		
			[bwhite Please Enter] [lsgreen Your Nick] : ]])
	io.SetColor("lgreen")
	lcon.show_cursor()
	local nick = io.read(20, 3)
	lcon.hide_cursor()
	return nick
end

function main(flag)
	init()
	local nick = getNick()
	systemInit()
	if flag then
		showMenu()
	end
	local point = startGame(nick)
	showPoint(nick, point)
	recordPoint(nick, point)
	return main(true)
end

---------------- Start ----------------
setTitle()
lcon.hide_cursor()

showMenu()
local nick = getPlayerNick()
recordNick(nick)

main()
-- EOF --