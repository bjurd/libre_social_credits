--- @param Amount number|nil
--- @return string
function LibreSC:GetDisplayName(Amount)
	return LibreSC:Pluralize(LibreSC.Config.display, Amount or 1)
end

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

		if string.find(Name, Converted) then
			return Player
		end
	end

	return nil
end

--- @param Data string
--- @return string|nil
function LibreSC:FindSteamID(Data)
	if util.SteamIDTo64(Data) ~= "0" then
		return Data
	end

	local Player = self:FindPlayer(Data)

	if Player then
		return Player:SteamID()
	end
	if util.SteamIDFrom64(Data) ~= "STEAM_0:0:0" then
		return util.SteamIDFrom64(Data)
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
