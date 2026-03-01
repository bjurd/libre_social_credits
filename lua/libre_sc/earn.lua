gameevent.Listen("entity_killed")
hook.Add("entity_killed", "LibreSocialCredits:Earn", function(Data)
	local Attacker = Entity(Data.entindex_attacker --[[@as number]])
	local Inflictor = Entity(Data.entindex_inflictor --[[@as number]])
	local Victim = Entity(Data.entindex_killed --[[@as number]])

	if (not Attacker:IsValid() or not Attacker:IsPlayer()) or (not Victim:IsValid() or not Victim:IsPlayer()) then -- Player on player only
		return
	end
	--- @cast Attacker Player
	--- @cast Victim Player
	if Attacker == Victim then
		-- Don't kill yourself, loser
		return
	end

	local BaseValue = tonumber(LibreSC.Config.earn.kill_value) or 0
	if BaseValue <= 0 then
		return
	end

	local Amount = BaseValue

	if Victim:LastHitGroup() == HITGROUP_HEAD then
		local HeadshotMultiplier = tonumber(LibreSC.Config.earn.headshot_multiplier) or 0

		if HeadshotMultiplier > 0 then
			Amount = BaseValue * HeadshotMultiplier
		end
	end

	Attacker:AddSocialCredits(Amount)
	Attacker:ChatPrint(string.format("You got a kill! +%d %s", Amount, LibreSC:GetDisplayName(Amount)))
end)
