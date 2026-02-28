LibreSC:RegisterCommand("bal", function(self, Player, Arguments)
	local TargetData = Arguments[1]

	if not TargetData or string.len(TargetData) < 1 then
		local Amount = Player:GetSocialCredits()
		Player:ChatPrint(string.format("You have %d %s", Amount, LibreSC:GetDisplayName(Amount)))

		return
	end

	local Found = LibreSC:FindPlayer(TargetData)
	local Receiver = (Found and Found:IsValid()) and Found or false

	if Receiver then
		TargetData = Receiver:SteamID()
		goto Read
	else
		if util.SteamIDTo64(TargetData) ~= "0" then
			goto Read
		end
	end

	if true then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	::Read::
	local Amount = LibreSC:GetCreditsFor(TargetData)

	Player:ChatPrint(string.format("%s has %d %s", TargetData, Amount, LibreSC:GetDisplayName(Amount)))
end)
