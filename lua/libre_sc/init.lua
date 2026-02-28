--- @class LibreSCConfig
--- @field display string

--- @class LibreSocialCredits
--- @field Config LibreSCConfig
LibreSC = LibreSC or {}



function LibreSC:EnsureDatabase()
	if not sql.TableExists("libre_social_credits") then
		sql.Query([[
			CREATE TABLE IF NOT EXISTS `libre_social_credits` (
				`SteamID` TEXT PRIMARY KEY,
				`Amount` INTEGER NOT NULL
					CHECK ( `Amount` >= 0 )
			);
		]])
	end
end

--- @param SteamID string
--- @return number
function LibreSC:GetCreditsFor(SteamID)
	LibreSC:EnsureDatabase()

	local CreditsStr = sql.QueryValue(string.format([[
		SELECT `Amount` FROM `libre_social_credits` WHERE `SteamID` = '%s';
	]], sql.SQLStr(SteamID, true)))

	local Credits = tonumber(CreditsStr) or 0
	return Credits
end

--- @param SteamID string
--- @param Credits number
function LibreSC:SetCreditsFor(SteamID, Credits)
	LibreSC:EnsureDatabase()

	Credits = tonumber(Credits) or 0

	sql.Query(string.format([[
		INSERT OR REPLACE INTO `libre_social_credits` ( `SteamID`, `Amount` ) VALUES ( '%s', %d );
	]], sql.SQLStr(SteamID, true), Credits))
end

--- @param SteamID string
--- @param Amount number
function LibreSC:AddCreditsFor(SteamID, Amount)
	local Current = LibreSC:GetCreditsFor(SteamID)
	local New = Current + Amount

	LibreSC:SetCreditsFor(SteamID, New)
end

--- @param SteamID string
--- @param Amount number
function LibreSC:RemoveCreditsFor(SteamID, Amount)
	local Current = LibreSC:GetCreditsFor(SteamID)
	local New = Current - Amount

	LibreSC:SetCreditsFor(SteamID, New)
end

function LibreSC:LoadConfig()
	local ConfigData = file.Read("data_static/libre_sc/config.txt", "GAME")

	if not ConfigData or string.len(ConfigData) < 1 then
		ErrorNoHaltWithStack("Invalid configuration file for Social Credits!")
		return
	end

	local Config = util.KeyValuesToTable(ConfigData, false, true)
	LibreSC.Config = Config
end



function LibreSC.InitPostEntity()
	include("libre_sc/extensions/player.lua")

	LibreSC:LoadConfig()
end
hook.Add("InitPostEntity", "LibreSocialCredits", LibreSC.InitPostEntity)
