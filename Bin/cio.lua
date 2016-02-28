----------------------------------
-- Shadow RPG - IO
-- By Joshua
-- At 2013-01-28 14:20:24
----------------------------------
local lcon=lcon
local Audio=require("Audio")

io.Colors={
	["black"]=0,
	["blue"]=1,
	["green"]=2,
	["lgreen"]=3,
	["red"]=4,
	["purple"]=5,
	["yellow"]=6,
	["white"]=7,
	["gray"]=8,
	["lblue"]=9,
	["lgreen"]=10,
	["lsgreen"]=11,
	["lred"]=12,
	["lpurple"]=13,
	["lyellow"]=14,
	["bwhite"]=15
}
----------------------------------
-- IO - mread
-- By Joshua
-- At 2013-01-28 14:29:20
----------------------------------
io.mread=io.read
----------------------------------
-- IO - read
-- By Joshua
-- At 2013-01-29 19:57:50
----------------------------------
function io.read(Max, Min)
	Min = Min or 0
	lcon.show_cursor()
	if not Max then
		return io.mread()
	end
	local res={}
	local point=1
	local x,y=lcon.cur_x(),lcon.cur_y()
	while true do
		local key=lcon.getch()
		if key==13 then
			if #res>Min then
				break	
			else
				Audio.Beep("tip")
			end
		elseif key==8 then
			if point>=1 then
				if res[point-2] and res[point-2]:byte()>127 and res[point-1]:byte()>127 then
					point=point-1
					table.remove(res,point)
				end
				if point>1 then
					point=point-1
				end
				table.remove(res,point)
				lcon.gotoXY(x,y)
				io.mwrite(table.concat(res),"  ")
				lcon.gotoXY(x+point-1,y)
			end
		elseif key==224 or key==0 then
			local key2=lcon.getch()
			if key2==75 then
				if point>1 then
					if res[point-2] and res[point-2]:byte()>127 and res[point-1]:byte()>127 then
						point=point-1
					end
					point=point-1
					lcon.gotoXY(x+point-1,y)
				end
			elseif key2==77 then
				if point<=#res then
					if res[point+2] and res[point+2]:byte()>127 and res[point+1]:byte()>127 then
						point=point+1
					end
					point=point+1
					lcon.gotoXY(x+point-1,y)
				end
			elseif key2==71 then
				point=1
				lcon.gotoXY(x,y)
			elseif key2==79 then
				point=#res+1
				lcon.gotoXY(x+point-1,y)			
			elseif key2==83 then
				if res[point+1] and res[point+1]:byte()>127 and res[point]:byte()>127 then
					table.remove(res,point)
				end
				table.remove(res,point)
				lcon.gotoXY(x,y)
				io.mwrite(table.concat(res),"  ")
				lcon.gotoXY(x+point-1,y)
			elseif key2==72 or key2==80 or key2==82 or key2==81 or key2==73 then
			else
				if #res<Max then
					table.insert(res,point,string.char(key))
					point=point+1
					table.insert(res,point,string.char(key2))
					point=point+1
					lcon.gotoXY(x,y)
					io.mwrite(table.concat(res),"  ")
					lcon.gotoXY(x+point-1,y)
				end
			end
		else
			if #res<Max then
				table.insert(res,point,string.char(key))
				point=point+1
				lcon.gotoXY(x,y)
				io.mwrite(table.concat(res),"  ")
				lcon.gotoXY(x+point-1,y)
			end
		end
	end
	lcon.hide_cursor()
	return table.concat(res)
end
----------------------------------
-- IO - mwrite
-- By Joshua
-- At 2013-01-28 20:49:29
----------------------------------
io.mwrite=io.write
----------------------------------
-- IO - write
-- By Joshua
-- At 2013-01-28 14:28:54
----------------------------------
function io.write(...)
	if not table.concat{...}:find("%[(.-) (.-)%]") then
		return io.mwrite(...)
	end
	for i,v in pairs({...}) do
		local s,e,color,text=v:find("%[(.-) (.-)%]")
		while s do
			if s>1 then
				io.SetColor()
				io.mwrite(v:sub(1,s-1))
			end
			if io.Colors[color] then
				io.SetColor(color)
				io.mwrite(text)
				io.SetColor()
			else
				io.SetColor()
				io.mwrite(v:sub(s,e))
			end
			v=v:sub(e+1,#v)
			s,e,color,text=v:find("%[(.-) (.-)%]")
		end
		io.SetColor()
		io.mwrite(v)
	end
end
----------------------------------
-- IO - SetColor
-- By Joshua
-- At 2013-01-28 18:01:24
----------------------------------
function io.SetColor(color)
	lcon.set_color(io.Colors[color or "bwhite"])
end