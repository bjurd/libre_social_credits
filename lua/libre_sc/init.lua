--- @class LibreSCConfig
--- @field display string
--- @field commands LibreSCConfig_Commands
--- @field earn LibreSCConfig_Earn

--- @class LibreSCConfig_Commands
--- @field prefix string
--- The rest don't matter

--- @class LibreSCConfig_Earn
--- @field kill_value string
--- @field headshot_multiplier string
--- @field death_value string
--- @field join_value string

--- @class LibreSocialCredits
--- @field Config LibreSCConfig
--- @field Commands LibreSCCommand[]
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
	self:EnsureDatabase()

	local CreditsStr = sql.QueryValue(string.format([[
		SELECT `Amount` FROM `libre_social_credits` WHERE `SteamID` = '%s';
	]], sql.SQLStr(SteamID, true)))

	local Credits = tonumber(CreditsStr) or 0
	return Credits
end

--- @param SteamID string
--- @param Credits number
function LibreSC:SetCreditsFor(SteamID, Credits)
	self:EnsureDatabase()

	Credits = tonumber(Credits) or 0

	sql.Query(string.format([[
		INSERT OR REPLACE INTO `libre_social_credits` ( `SteamID`, `Amount` ) VALUES ( '%s', %d );
	]], sql.SQLStr(SteamID, true), Credits))
end

--- @param SteamID string
--- @param Amount number
function LibreSC:AddCreditsFor(SteamID, Amount)
	local Current = self:GetCreditsFor(SteamID)
	local New = Current + Amount

	self:SetCreditsFor(SteamID, New)
end

--- @param SteamID string
--- @param Amount number
function LibreSC:RemoveCreditsFor(SteamID, Amount)
	local Current = self:GetCreditsFor(SteamID)
	local New = Current - Amount

	self:SetCreditsFor(SteamID, New)
end

function LibreSC:LoadConfig()
	local ConfigData = file.Read("data_static/libre_sc/config.txt", "GAME")

	if not ConfigData or string.len(ConfigData) < 1 then
		ErrorNoHaltWithStack("Invalid configuration file for Social Credits!")
		return
	end

	local Config = util.KeyValuesToTable(ConfigData, false, true)
	self.Config = Config
end



function LibreSC.InitPostEntity()
	include("libre_sc/util.lua")
	include("libre_sc/extensions/player.lua")

	LibreSC:LoadConfig()

	include("libre_sc/cmds.lua")
	include("libre_sc/earn.lua")
end
hook.Add("InitPostEntity", "LibreSocialCredits", LibreSC.InitPostEntity)
