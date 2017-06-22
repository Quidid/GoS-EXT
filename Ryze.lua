class "Ryze"

print("// Doge Series | Ryze Loaded - //"..myHero.charName.."")
print("// Version: Test 0.1")
print("such wow ryze")
print("Good luck, have fun! -Doge")

function Ryze:__init()
	self:LoadSpells()
	self:LoadMenu()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Ryze:LoadSpells()
	Q = {range = myHero:GetSpellData(_Q).range, delay = myHero:GetSpellData(_Q).delay, speed = myHero:GetSpellData(_Q).speed, width = myHero:GetSpellData(_Q).width}
	W = {range = myHero:GetSpellData(_W).range, delay = myHero:GetSpellData(_W).delay, speed = myHero:GetSpellData(_W).speed, width = myHero:GetSpellData(_W).width}
	E = {range = myHero:GetSpellData(_E).range, delay = myHero:GetSpellData(_E).delay, speed = myHero:GetSpellData(_E).speed, width = myHero:GetSpellData(_E).width}
	R = {range = myHero:GetSpellData(_R).range, delay = myHero:GetSpellData(_R).delay, speed = myHero:GetSpellData(_R).speed, width = myHero:GetSpellData(_R).width}
end

function Ryze:LoadMenu()
	-------Main Menu------
	self.Menu = MenuElement({type = MENU, id = "Menu", name = "Doge Series: Ryze", leftIcon = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/2/28/RyzeSquare.png"})
	-------Doge Series-------
	self.Menu:MenuElement({type = MENU, id = "Mode", name = "Doge Series Menu: Ryze", leftIcon = "https://s-media-cache-ak0.pinimg.com/originals/a3/82/a3/a382a3eca248fe1b7c4bd5527917c27b.png"})
	-------Combo---------
	self.Menu.Mode:MenuElement({type = MENU, id = "Combo", name = "Combo"})
	self.Menu.Mode.Combo:MenuElement({id = "Q", name = "Use Q", value = true, leftIcon = "http://news.cdn.leagueoflegends.com/public/images/articles/2015/april_2015/RUP/Q.jpg"})
	self.Menu.Mode.Combo:MenuElement({id = "W", name = "Use W", value = true, leftIcon = "http://news.cdn.leagueoflegends.com/public/images/articles/2015/april_2015/RUP/W.jpg"})
	self.Menu.Mode.Combo:MenuElement({id = "E", name = "Use E", value = true, leftIcon = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/8/81/Spell_Flux.png"})
	-------Harass---------
	self.Menu.Mode:MenuElement({type = MENU, id = "Harass", name = "Harass (60% working)"})
	self.Menu.Mode.Harass:MenuElement({id = "Q", name = "Use Q", value = true, leftIcon = "http://news.cdn.leagueoflegends.com/public/images/articles/2015/april_2015/RUP/Q.jpg"})
	self.Menu.Mode.Harass:MenuElement({id = "W", name = "Use W", value = true, leftIcon = "http://news.cdn.leagueoflegends.com/public/images/articles/2015/april_2015/RUP/W.jpg"})
	self.Menu.Mode.Harass:MenuElement({id = "E", name = "Use E", value = true, leftIcon = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/8/81/Spell_Flux.png"})
	self.Menu.Mode.Harass:MenuElement({type = MENU, id = "MM", name = "Mana Manager"})
	self.Menu.Mode.Harass.MM:MenuElement({id = "Mana", name = "Min Mana to Harass(%)", value = 50, min = 0, max = 100, step = 1})
	-------Draw---------
	self.Menu:MenuElement({type = MENU, id = "Drawing", name = "DogeSeries: Drawings", leftIcon = "https://s-media-cache-ak0.pinimg.com/originals/a3/82/a3/a382a3eca248fe1b7c4bd5527917c27b.png"})
	self.Menu.Drawing:MenuElement({id = "Q", name = "Draw Q Range", value = true, leftIcon = "http://news.cdn.leagueoflegends.com/public/images/articles/2015/april_2015/RUP/Q.jpg"})
	self.Menu.Drawing:MenuElement({id = "W", name = "Draw W Range", value = true, leftIcon = "http://news.cdn.leagueoflegends.com/public/images/articles/2015/april_2015/RUP/W.jpg"})
	self.Menu.Drawing:MenuElement({id = "E", name = "Draw E Range", value = true, leftIcon = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/8/81/Spell_Flux.png"})

end

function Ryze:Tick()
	local Combo = (_G.SDK and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO]) or (_G.GOS and _G.GOS:GetMode() == "Combo") or (_G.EOWLoaded and EOW:Mode() == "Combo")
	local Clear = (_G.SDK and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR]) or (_G.SDK and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR]) or (_G.GOS and _G.GOS:GetMode() == "Clear") or (_G.EOWLoaded and EOW:Mode() == "LaneClear")
	local Harass = (_G.SDK and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS]) or (_G.GOS and _G.GOS:GetMode() == "Harass") or (_G.EOWLoaded and EOW:Mode() == "Harass")
	if Combo then
		self:Combo()
	elseif Clear then
		self:Clear()
	elseif Harass then
		self:Harass()		
	end	
end

local function Ready(spell)
	return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana
end

function CountAlliesInRange(point, range)
	if type(point) ~= "userdata" then error("{CountAlliesInRange}: bad argument #1 (vector expected, got "..type(point)..")") end
	local range = range == nil and math.huge or range 
	if type(range) ~= "number" then error("{CountAlliesInRange}: bad argument #2 (number expected, got "..type(range)..")") end
	local n = 0
	for i = 1, Game.HeroCount() do
		local unit = Game.Hero(i)
		if unit.isAlly and not unit.isMe and IsValidTarget(unit, range, false, point) then
			n = n + 1
		end
	end
	return n
end

local function CountEnemiesInRange(point, range)
	if type(point) ~= "userdata" then error("{CountEnemiesInRange}: bad argument #1 (vector expected, got "..type(point)..")") end
	local range = range == nil and math.huge or range 
	if type(range) ~= "number" then error("{CountEnemiesInRange}: bad argument #2 (number expected, got "..type(range)..")") end
	local n = 0
	for i = 1, Game.HeroCount() do
		local unit = Game.Hero(i)
		if IsValidTarget(unit, range, true, point) then
			n = n + 1
		end
	end
	return n
end

local _AllyHeroes
function GetAllyHeroes()
	if _AllyHeroes then return _AllyHeroes end
	_AllyHeroes = {}
	for i = 1, Game.HeroCount() do
		local unit = Game.Hero(i)
		if unit.isAlly then
			table.insert(_AllyHeroes, unit)
		end
	end
	return _AllyHeroes
end

local _EnemyHeroes
function GetEnemyHeroes()
	if _EnemyHeroes then return _EnemyHeroes end
	_EnemyHeroes = {}
	for i = 1, Game.HeroCount() do
		local unit = Game.Hero(i)
		if unit.isEnemy then
			table.insert(_EnemyHeroes, unit)
		end
	end
	return _EnemyHeroes
end

function GetPercentHP(unit)
	if type(unit) ~= "userdata" then error("{GetPercentHP}: bad argument #1 (userdata expected, got "..type(unit)..")") end
	return 100*unit.health/unit.maxHealth
end

function GetPercentMP(unit)
	if type(unit) ~= "userdata" then error("{GetPercentMP}: bad argument #1 (userdata expected, got "..type(unit)..")") end
	return 100*unit.mana/unit.maxMana
end

function GetBuffData(unit, buffname)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.name == buffname and buff.count > 0 then 
			return buff
		end
	end
	return {type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0}--
end

local function GetBuffs(unit)
	local t = {}
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.count > 0 then
			table.insert(t, buff)
		end
	end
	return t
end

local function GetDistance(p1,p2)
	return  math.sqrt(math.pow((p2.x - p1.x),2) + math.pow((p2.y - p1.y),2) + math.pow((p2.z - p1.z),2))
end

function HasBuff(unit, buffname)
	if type(unit) ~= "userdata" then error("{HasBuff}: bad argument #1 (userdata expected, got "..type(unit)..")") end
	if type(buffname) ~= "string" then error("{HasBuff}: bad argument #2 (string expected, got "..type(buffname)..")") end
	for i, buff in pairs(GetBuffs(unit)) do
		if buff.name == buffname then 
			return true
		end
	end
	return false
end

function IsImmobileTarget(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 or buff.name == "recall") and buff.count > 0 then
			return true
		end
	end
	return false	
end

function IsImmune(unit)
	if type(unit) ~= "userdata" then error("{IsImmune}: bad argument #1 (userdata expected, got "..type(unit)..")") end
	for i, buff in pairs(GetBuffs(unit)) do
		if (buff.name == "KindredRNoDeathBuff" or buff.name == "UndyingRage") and GetPercentHP(unit) <= 10 then
			return true
		end
		if buff.name == "VladimirSanguinePool" or buff.name == "JudicatorIntervention" then 
			return true
		end
	end
	return false
end

function IsValidTarget(unit, range, checkTeam, from)
	local range = range == nil and math.huge or range
	if type(range) ~= "number" then error("{IsValidTarget}: bad argument #2 (number expected, got "..type(range)..")") end
	if type(checkTeam) ~= "nil" and type(checkTeam) ~= "boolean" then error("{IsValidTarget}: bad argument #3 (boolean or nil expected, got "..type(checkTeam)..")") end
	if type(from) ~= "nil" and type(from) ~= "userdata" then error("{IsValidTarget}: bad argument #4 (vector or nil expected, got "..type(from)..")") end
	if unit == nil or not unit.valid or not unit.visible or unit.dead or not unit.isTargetable or IsImmune(unit) or (checkTeam and unit.isAlly) then 
		return false 
	end 
	return unit.pos:DistanceTo(from.pos and from.pos or myHero.pos) < range 
end

function Ryze:GetValidEnemy(range)
    for i = 1,Game.HeroCount() do
        local enemy = Game.Hero(i)
        if  enemy.team ~= myHero.team and enemy.valid and enemy.pos:DistanceTo(myHero.pos) < range then
            return true
        end
    end
    return false
end

function Ryze:GetValidMinion(range)
    for i = 1,Game.MinionCount() do
        local minion = Game.Minion(i)
        if  minion.team ~= myHero.team and minion.valid and minion.pos:DistanceTo(myHero.pos) < range then
            return true
        end
    end
    return false
end

function Ryze:CountEnemyMinions(range)
	local minionsCount = 0
    for i = 1,Game.MinionCount() do
        local minion = Game.Minion(i)
        if  minion.team ~= myHero.team and minion.valid and minion.pos:DistanceTo(myHero.pos) < range then
            minionsCount = minionsCount + 1
        end
    end
    return minionsCount
end

local function HpPred(unit, delay)
	if _G.GOS then
	hp =  GOS:HP_Pred(unit,delay)
	else
	hp = unit.health
	end
	return hp
end

function Ryze:Combo(target)
if self:GetValidEnemy(1000) == false then return end
if (not _G.SDK and not _G.GOS and not _G.EOWLoaded) then return end
	local target =  (_G.SDK and _G.SDK.TargetSelector:GetTarget(1000, _G.SDK.DAMAGE_TYPE_PHYSICAL)) or (_G.GOS and _G.GOS:GetTarget(1100,"AD")) or ( _G.EOWLoaded and EOW:GetTarget())
	if Ready(_Q) and self.Menu.Mode.Combo.Q:Value() then
		if Ready(_Q) and IsValidTarget(target, myHero:GetSpellData(_Q).range, true, myHero) then
			if target:GetCollision(myHero:GetSpellData(_Q).width, myHero:GetSpellData(_Q).speed, myHero:GetSpellData(_Q).delay) == 0 then
				local castPos = target:GetPrediction(myHero:GetSpellData(_Q).speed, myHero:GetSpellData(_Q).delay)
				if castPos then
					Control.CastSpell(HK_Q, castPos)
				end
			end
		end
		if Ready(_E) and self.Menu.Mode.Combo.E:Value() and IsValidTarget(target, myHero:GetSpellData(_E).range, true, myHero) then
			Control.CastSpell(HK_E, target)
		end
		if Ready(_W) and self.Menu.Mode.Combo.W:Value() and IsValidTarget(target, myHero:GetSpellData(_W).range, true, myHero) then
			Control.CastSpell(HK_W, target)
		end
		if Ready(_W) and self.Menu.Mode.Combo.W:Value() then
			if Ready(_W) and IsValidTarget(target, myHero:GetSpellData(_W).range, true, myHero) then
				Control.CastSpell(HK_W, target)
			end
		end
		if Ready(_E) and self.Menu.Mode.Combo.E:Value() and IsValidTarget(target, myHero:GetSpellData(_E).range, true, myHero) then
			Control.CastSpell(HK_E, target)
		end
		if Ready(_Q) and self.Menu.Mode.Combo.Q:Value() and IsValidTarget(target, myHero:GetSpellData(_Q).range, true, myHero) then
			Control.CastSpell(HK_Q, target)
		end
	end
end

function Ryze:Harass(target)
if self:GetValidEnemy(1000) == false then return end
if (not _G.SDK and not _G.GOS and not _G.EOWLoaded) then return end
	local target =  (_G.SDK and _G.SDK.TargetSelector:GetTarget(1000, _G.SDK.DAMAGE_TYPE_PHYSICAL)) or (_G.GOS and _G.GOS:GetTarget(1100,"AD")) or ( _G.EOWLoaded and EOW:GetTarget())
	if (myHero.mana/myHero.maxMana >= self.Menu.Mode.Harass.MM.Mana:Value() / 100) then
	if Ready(_Q) and self.Menu.Mode.Harass.Q:Value() then
		if Ready(_Q) and IsValidTarget(target, myHero:GetSpellData(_Q).range, true, myHero) then
			if target:GetCollision(myHero:GetSpellData(_Q).width, myHero:GetSpellData(_Q).speed, myHero:GetSpellData(_Q).delay) == 0 then
				local castPos = target:GetPrediction(myHero:GetSpellData(_Q).speed, myHero:GetSpellData(_Q).delay)
				if castPos then
					Control.CastSpell(HK_Q, castPos)
				end
			end
		end
	end
end
		if Ready(_Q) and self.Menu.Mode.Harass.Q:Value() then
			if Ready(_Q) and IsValidTarget(target, myHero:GetSpellData(_Q).range, true, myHero) then
				Control.CastSpell(HK_Q, target)
		end
	end
		if Ready(_W) and self.Menu.Mode.Harass.W:Value() then
			if Ready(_W) and IsValidTarget(target, myHero:GetSpellData(_W).range, true, myHero) then
				Control.CastSpell(HK_W, target)
		end
	end
		if Ready(_E) and self.Menu.Mode.Harass.E:Value() then
			if Ready(_E) and IsValidTarget(target, myHero:GetSpellData(_E).range, true, myHero) then
				Control.CastSpell(HK_E, target)
		end
	end
end

function Ryze:Draw()
	if myHero.dead then return end
	if self.Menu.Drawing.Q:Value() then Draw.Circle(myHero.pos,Q.range,1,Draw.Color(255, 255, 255, 255)) end
	if self.Menu.Drawing.W:Value() then Draw.Circle(myHero.pos,W.range,1,Draw.Color(255, 255, 255, 255)) end		
	if self.Menu.Drawing.E:Value() then Draw.Circle(myHero.pos,E.range,1,Draw.Color(220, 255, 255, 255)) end	
end

function OnLoad()
	if myHero.charName ~= "Ryze" then return end
	Ryze()
end
