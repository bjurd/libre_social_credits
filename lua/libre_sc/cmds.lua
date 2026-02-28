--- @alias LibreSCCommand_Callback fun(self: LibreSCCommand, Player: Player, Arguments: string[])

--- @class LibreSCCommand
--- @field Name string
--- @field DisplayName string
--- @field Description string
--- @field Callback LibreSCCommand_Callback
LibreSC.Commands = {}



--- @param Name string
--- @return LibreSCCommand|nil, number|nil
function LibreSC:FindCommand(Name)
	local Count = #self.Commands

	for i = 1, Count do
		-- Not exactly the most efficient lookup :P
		local Command = self.Commands[i]

		if Command.Name == Name then
			return Command, i
		end
	end

	return nil, nil
end

--- @return string
function LibreSC:GetCommandPrefix()
	local Prefix = self.Config.commands.prefix
	Prefix = string.Trim(string.lower(Prefix))

	return Prefix
end

--- @param Name string
--- @param Callback LibreSCCommand_Callback
function LibreSC:RegisterCommand(Name, Callback)
	Name = string.Trim(string.lower(Name))

	local Existing, Index = self:FindCommand(Name)
	if Existing then
		MsgN("[", self.Config.display, "] Overriding command ", self:GetCommandPrefix(), Name)

		table.remove(self.Commands, Index)
	end

	--- @type string|nil
	local ConfigName = self.Config.commands[Name]

	if not ConfigName then
		return
	else
		ConfigName = string.Trim(string.lower(ConfigName))
	end

	--- @type LibreSCCommand
	local Command = {
		Name = Name,
		DisplayName = ConfigName,
		Description = "", -- TODO:
		Callback = Callback
	}
	table.insert(self.Commands, Command)
end

--- @param Command LibreSCCommand
--- @param Player Player
--- @param Arguments string[]
function LibreSC:RunCommand(Command, Player, Arguments)
	Command:Callback(Player, Arguments)
end



gameevent.Listen("player_say")
hook.Add("player_say", "LibreSocialCredits:Commands", function(Data)
	local Player = Player(Data.userid --[[@as number]])
	if not Player:IsValid() then
		return
	end

	local Text = Data.text --[[@as string]]

	local Blocks = string.Split(Text, " ")
	local CommandBlock = Blocks[1]

	local Prefix = LibreSC:GetCommandPrefix()
	if not string.StartsWith(CommandBlock, Prefix) then
		return
	else
		table.remove(Blocks, 1)
	end

	local CommandName = string.sub(CommandBlock, string.len(Prefix) + 1)
	CommandName = string.lower(CommandName)

	local Command = LibreSC:FindCommand(CommandName)
	if not Command then
		return
	end

	LibreSC:RunCommand(Command, Player, Blocks)
end)

-- File time!
include("commands/pay.lua")
include("commands/bal.lua")
