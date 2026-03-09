gameevent.Listen("entity_killed")
hook.Add("entity_killed", "LibreSocialCredits:Earn", function(Data)
	local AttackerIndex = Data.entindex_attacker --[[@as number]] or 0
	local InflictorIndex = Data.entindex_inflictor --[[@as number]] or 0
	local VictimIndex = Data.entindex_killed --[[@as number]] or 0

	local Attacker = Entity(AttackerIndex)
	local Inflictor = Entity(InflictorIndex)
	local Victim = Entity(VictimIndex)

	if not Victim:IsValid() or not Victim:IsPlayer() then
		return
	end
	--- @cast Victim Player

	local IsSuicide = Attacker == Victim -- Don't kill yourself, loser

	local DeathValue = tonumber(LibreSC.Config.earn.death_value) or 0
	local SuicideMultiplier = tonumber(LibreSC.Config.earn.suicide_multiplier) or 0

	if SuicideMultiplier > 0 then
		DeathValue = DeathValue * SuicideMultiplier
	end

	if DeathValue > 0 then
		Victim:SubtractSocialCredits(DeathValue)
		Victim:ChatPrint(string.format("You died! -%d %s", DeathValue, LibreSC:GetDisplayName(DeathValue)))
	end

	if not Attacker:IsValid() or not Attacker:IsPlayer() then -- Player on player only
		return
	end
	--- @cast Attacker Player

	if IsSuicide then
		return
	end

	if Victim:IsBot() and not tobool(LibreSC.Config.earn.reward_bot_kills) then
		return
	end

	local BaseValue = tonumber(LibreSC.Config.earn.kill_value) or 0
	if BaseValue <= 0 then
		return
	end

	local Amount = BaseValue

	if Inflictor:IsValid() and Inflictor:IsWeapon() and Victim:LastHitGroup() == HITGROUP_HEAD then
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
