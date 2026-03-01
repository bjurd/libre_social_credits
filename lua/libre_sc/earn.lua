gameevent.Listen("entity_killed")
hook.Add("entity_killed", "LibreSocialCredits:Earn", function(Data)
	local Attacker = Entity(Data.entindex_attacker --[[@as number]])
	local Inflictor = Entity(Data.entindex_inflictor --[[@as number]])
	local Victim = Entity(Data.entindex_killed --[[@as number]])

	if not Victim:IsValid() or not Victim:IsPlayer() then
		return
	end
	--- @cast Victim Player

	local DeathValue = tonumber(LibreSC.Config.earn.death_value) or 0
	if DeathValue > 0 then
		Victim:SubtractSocialCredits(DeathValue)
		Victim:ChatPrint(string.format("You died! -%d %s", DeathValue, LibreSC:GetDisplayName(DeathValue)))
	end

	if not Attacker:IsValid() or not Attacker:IsPlayer() then -- Player on player only
		return
	end
	--- @cast Attacker Player

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

gameevent.Listen("player_activate")
hook.Add("player_activate", "LibreSocialCredits:Earn", function(Data)
	local Player = Player(Data.userid --[[@as number]])

	if not Player:IsValid() then
		return
	end

	local Value = tonumber(LibreSC.Config.earn.join_value) or 0
	if Value <= 0 then
		return
	end

	Player:AddSocialCredits(Value)
	Player:ChatPrint(string.format("Thanks for joining! +%d %s", Value, LibreSC:GetDisplayName(Value)))
end)
