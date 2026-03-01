LibreSC:RegisterCommand("explode", function(self, Player, Arguments)
	local TargetData = Arguments[1]

	if not TargetData or string.len(TargetData) < 1 then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	local Found = LibreSC:FindPlayer(TargetData)

	if not Found then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	if Player:GetSocialCredits() < 1000 then
		Player:ChatPrint(string.format("You need at least 1000 %s to run this command!", LibreSC:GetDisplayName(1000)))
		return
	end

	if Found:IsAdmin() and Found:HasGodMode() then
		Player:ChatPrint("You can't explode godded administrators!")
		return
	end

	Player:SubtractSocialCredits(1000)

	local Origin = Found:GetPos()

	local Damage = DamageInfo()
	Damage:SetAttacker(Player)
	Damage:SetInflictor(Entity(0))
	Damage:SetDamage(100)
	Damage:SetDamageType(DMG_BLAST)
	Damage:SetDamagePosition(Origin)
	Damage:SetDamageForce(vector_origin)

	Found:SetHealth(1)
	Found:TakeDamageInfo(Damage)
	Found:Ignite(math.huge, 100)

	if Found:Alive() then
		Found:Kill()
	end

	local Effect = EffectData()
	Effect:SetOrigin(Origin)
	Effect:SetAngles(angle_zero)
	Effect:SetScale(1)
	Effect:SetAttachment(0)
	Effect:SetEntIndex(0)
	Effect:SetNormal(vector_up)
	Effect:SetRadius(0)
	util.Effect("Explosion", Effect, true, true)
end)
