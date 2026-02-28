--- @param Data string Name, SteamID, SteamID64
--- @return Player|nil
function LibreSC:FindPlayer(Data)
	local Found = player.GetBySteamID(Data) or player.GetBySteamID64(Data)

	if Found then
		--- @cast Found Player
		return Found
	end

	local Converted = string.Trim(string.lower(Data))

	for _, Player in player.Iterator() do
		local Name = string.Trim(string.lower(Player:Nick()))

		if string.find(Converted, Name) then
			return Player
		end
	end

	return nil
end

--- @param String string
--- @param Amount number
--- @param Suffix string|nil
--- @return string
function LibreSC:Pluralize(String, Amount, Suffix)
	if Amount == 1 then
		return String
	else
		if not Suffix then
			Suffix = "s"
		end

		return String .. Suffix
	end
end
