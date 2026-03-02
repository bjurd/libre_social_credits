LibreSC:RegisterCommand("leaderboard", function(self, Player, Arguments)
	local Data = LibreSC:DumpDatabase()

	local TotalRows = #Data
	for i = 1, TotalRows do
		local Row = Data[i]
		Row.Amount = tonumber(Row.Amount)
	end

	table.sort(Data, function(A, B)
		return A.Amount > B.Amount
	end)

	local Rows = 10
	-- local Results = {}

	for i = 1, Rows do
		local Row = Data[i]

		-- table.insert(Results, string.format("%s - %d", Row.SteamID, Row.Amount))
		local Found = LibreSC:FindPlayer(Row.SteamID)
		local DisplayName = Found and Found:Nick() or Row.SteamID

		Player:ChatPrint(string.format("%s - %d", DisplayName, Row.Amount))
	end
end)
