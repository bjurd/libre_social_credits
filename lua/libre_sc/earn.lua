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

	-- TODO: Kill types that award different amounts
	Attacker:AddSocialCredits(10)
	Attacker:ChatPrint("You got a kill! +10 " .. LibreSC:GetDisplayName(10))
end)
