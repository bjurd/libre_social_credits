--- @class Player
--- @field jail table|nil ULX Jail
--- @field m_iSocialCreditBounty number
--- @field m_strSocialCreditBountyPlayer string
--- @field m_bDontClaimBounty boolean
--- @field m_strLastSocialCreditMessage string|nil
--- @field GetSocialCredits fun(self: Player): number
--- @field SetSocialCredits fun(self: Player, Credits: number)
--- @field AddSocialCredits fun(self: Player, Amount: number)
--- @field SubtractSocialCredits fun(self: Player, Amount: number)
--- @field GetCreditBounty fun(self: Player): number
--- @field SetCreditBounty fun(self: Player, Bounty: number, Placer: Player|nil)

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

--- @return number
function PLAYER:GetCreditBounty()
	return self.m_iSocialCreditBounty or 0
end

--- @param Bounty number
--- @param Placer Player|nil
function PLAYER:SetCreditBounty(Bounty, Placer)
	self.m_iSocialCreditBounty = Bounty
	self.m_bDontClaimBounty = false

	if Placer then
		self.m_strSocialCreditBountyPlayer = Placer:SteamID()
	end
end
