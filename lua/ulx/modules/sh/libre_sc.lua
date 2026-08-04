local comma = string.Comma

// these would be variables but leme decided to populate the config during initpostentity
local function creditname()
	return LibreSC and LibreSC.Config and LibreSC.Config.display or "Social Credit"
end

local function creditnameplural()
	return creditname() .. "s"
end



if SERVER then
	local function possession(name)
		if !isstring(name) or name == "" then return end

		name = string.Trim(name)

		local last = string.lower(string.sub(name, -1))

		if last == "s" then
			return name .. "'"
		else
			return name .. "'s"
		end
	end



	function ulx.getcredits(calling, targets)
		for ligma, v in ipairs(targets) do
			local name = v:Nick()
			local credits = v:GetSocialCredits()

			//ulib handles sserver console automatically
			ULib.tsay(calling, name .. " has " .. comma(credits) .. " " .. LibreSC:GetDisplayName(credits))

			// who would log this
		end
	end



	function ulx.setcredits(calling, targets, amount)
		for ligma, v in ipairs(targets) do

			
			v:SetSocialCredits(amount)

			// you set james' social credit to 50! see it doesnt make sense

			ULib.tsay(calling, "You set " .. possession(v:Nick()) .. " " .. creditnameplural() .. " to " .. comma(amount))

			ulx.fancyLogAdmin(calling, "#A set #T's " .. creditnameplural() .. " to " .. comma(amount), v)
		end
	end



	function ulx.addcredits(calling, targets, amount)
		for ligma, v in ipairs(targets) do
			v:AddSocialCredits(amount)

			ULib.tsay(calling, "You added " .. comma(amount) .. " " .. LibreSC:GetDisplayName(amount) .. " to " .. v:Nick())

			ulx.fancyLogAdmin(calling, "#A added " .. comma(amount) .. " " .. LibreSC:GetDisplayName(amount) .. " to #T", v)
		end
	end



	function ulx.takecredits(calling, targets, amount)
		for ligma, v in ipairs(targets) do
			v:SubtractSocialCredits(amount)

			ULib.tsay(calling, "You took " .. comma(amount) .. " " .. LibreSC:GetDisplayName(amount) .. " from " .. v:Nick())

			ulx.fancyLogAdmin(calling, "#A took " .. comma(amount) .. " " .. LibreSC:GetDisplayName(amount) .. " from #T", v)
		end
	end
end



do
	local getcredits = ulx.command("Utility", "ulx getcredits", ulx.getcredits, "!getcredits")

	getcredits:addParam{type = ULib.cmds.PlayersArg}
	getcredits:defaultAccess(ULib.ACCESS_ALL)
	getcredits:help("Check a player's " .. creditnameplural())



	local setcredits = ulx.command("Utility", "ulx setcredits", ulx.setcredits, "!setcredits")

	setcredits:addParam{type = ULib.cmds.PlayersArg}
	setcredits:addParam{type = ULib.cmds.NumArg, hint = "amount", min = 0, max = 1000000, ULib.cmds.round}
	setcredits:defaultAccess(ULib.ACCESS_ADMIN)
	setcredits:help("Set a player's " .. creditnameplural() .. " to a value.")



	local addcredits = ulx.command("Utility", "ulx addcredits", ulx.addcredits, "!addcredits")

	addcredits:addParam{type = ULib.cmds.PlayersArg}
	addcredits:addParam{type = ULib.cmds.NumArg, hint = "amount", min = 0, max = 1000000, ULib.cmds.round}
	addcredits:defaultAccess(ULib.ACCESS_ADMIN)
	addcredits:help("Add " .. creditnameplural() .. " to a player.")



	local takecredits = ulx.command("Utility", "ulx takecredits", ulx.takecredits, "!takecredits")

	takecredits:addParam{type = ULib.cmds.PlayersArg}
	takecredits:addParam{type = ULib.cmds.NumArg, hint = "amount", min = 0, max = 1000000, ULib.cmds.round}
	takecredits:defaultAccess(ULib.ACCESS_ADMIN)
	takecredits:help("Take " .. creditnameplural() .. " away from a player.")
end