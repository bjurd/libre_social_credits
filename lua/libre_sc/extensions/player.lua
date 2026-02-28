--- @class Player
--- @field GetSocialCredits fun(self: Player): number
--- @field SetSocialCredits fun(self: Player, Credits: number)
--- @field AddSocialCredits fun(self: Player, Amount: number)
--- @field SubtractSocialCredits fun(self: Player, Amount: number)

local PLAYER = FindMetaTable("Player")

if not istable(PLAYER) then
	error("Can't find Player metatable") -- Should never happen
	return
end
--- @cast PLAYER table



--- @return number
function PLAYER:GetSocialCredits()
	return LibreSC:GetCreditsFor(self:SteamID())
end

--- @param Credits number
function PLAYER:SetSocialCredits(Credits)
	LibreSC:SetCreditsFor(self:SteamID(), Credits)
end

--- @param Amount number
function PLAYER:AddSocialCredits(Amount)
	LibreSC:AddCreditsFor(self:SteamID(), Amount)
end

--- @param Amount number
function PLAYER:SubtractSocialCredits(Amount)
	LibreSC:RemoveCreditsFor(self:SteamID(), Amount)
end
