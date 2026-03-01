LibreSC:RegisterCommand("bal", function(self, Player, Arguments)
	local TargetData = Arguments[1]

	if not TargetData or string.len(TargetData) < 1 then
		local Amount = Player:GetSocialCredits()
		Player:ChatPrint(string.format("You have %d %s", Amount, LibreSC:GetDisplayName(Amount)))

		return
	end

	local TargetID = LibreSC:FindSteamID(TargetData)

	if not TargetID then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	local Amount = LibreSC:GetCreditsFor(TargetID)

	Player:ChatPrint(string.format("%s has %d %s", TargetID, Amount, LibreSC:GetDisplayName(Amount)))
end)
