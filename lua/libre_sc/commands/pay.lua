LibreSC:RegisterCommand("pay", function(self, Player, Arguments)
	local TargetData = Arguments[1]
	local Amount = tonumber(Arguments[2])

	if not TargetData or string.len(TargetData) < 1 then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	local Found = LibreSC:FindPlayer(TargetData)
	local Receiver = (Found and Found:IsValid()) and Found or false

	if Receiver then
		TargetData = Receiver:SteamID()
		goto Pay
	else
		if util.SteamIDTo64(TargetData) ~= "0" then
			goto Pay
		end
	end

	if true then
		Player:ChatPrint("Invalid target! You can use name, SteamID, or SteamID64.")
		return
	end

	::Pay::
	if not Amount or Amount % 1 ~= 0 or Amount <= 0 then
		Player:ChatPrint("Invalid amount! Must be a positive integer.")
		return
	end

	if Amount > Player:GetSocialCredits() then
		Player:ChatPrint("Invalid amount! You don't have enough " .. LibreSC:GetDisplayName(Amount))
		return
	end

	LibreSC:AddCreditsFor(TargetData, Amount)
	LibreSC:RemoveCreditsFor(Player:SteamID(), Amount)

	if Receiver then
		Receiver:ChatPrint(string.format("%s has sent you %d %s!", Player:Nick(), Amount, LibreSC:GetDisplayName(Amount)))
	end
	Player:ChatPrint(string.format("Sent %d %s to %s!", Amount, LibreSC:GetDisplayName(Amount), TargetData))
end)
