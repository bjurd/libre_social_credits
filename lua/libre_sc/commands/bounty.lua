LibreSC:RegisterCommand("bounty", function(self, Player, Arguments)
	local TargetData = Arguments[1]
	local Amount = tonumber(Arguments[2])

	if not TargetData or string.len(TargetData) < 1 then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	local Found = LibreSC:FindPlayer(TargetData)

	if not Found then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	if Found == Player then
		Player:ChatPrint("You can't place a bounty on your own head, loser.")
		return
	end

	if not Amount or Amount % 1 ~= 0 or Amount <= 0 then
		Player:ChatPrint("Invalid amount! Must be a positive integer.")
		return
	end

	if Amount > Player:GetSocialCredits() then
		Player:ChatPrint("Invalid amount! You don't have enough " .. LibreSC:GetDisplayName(Amount))
		return
	end

	Player:SubtractSocialCredits(Amount)
	Found:SetCreditBounty(Amount)

	LibreSC:ChatBroadcast(string.format("A bounty has been placed for %d %s on %s!", Amount, LibreSC:GetDisplayName(Amount), Found:Nick()))
end)
