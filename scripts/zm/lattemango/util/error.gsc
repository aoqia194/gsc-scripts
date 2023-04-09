// Developed by lattemango

#include scripts\zm\chat_commands;

CommandDoesNotExistError(commandName) { return array("The command " + commandName + " doesn't exist", "Type " + GetDvar("cc_prefix") + "commands to get a list of commands"); }
CommandHelpDoesNotExistError(commandName) { return array("The command " + commandName + " doesn't have any help message"); }
InsufficientPermissionError(playerPermissionLevel, commandName, requiredPermissionLevel) { if (playerPermissionLevel == 0) { return array("You don't have the permissions to run any command"); } return array("Access to the ^5" + commandName + " ^7command refused", "Your permission level is ^5" + playerPermissionLevel + " ^7and the minimum permission level for this command is ^5" + requiredPermissionLevel); }
InvalidPermissionLevelError(requestedPermissionLevel) { return array("^5" + requestedPermissionLevel + " ^7is not a valid permission level", "Permission levels range from ^50 ^7to ^5" + GetDvarInt("cc_permission_max")); }
NotEnoughArgsError(minimumArgs) { return array("Not enough arguments supplied", "At least " + minimumArgs + " arguments expected"); }
TooManyArgsError(maximumArgs) { return array("Too many arguments supplied", "At least " + maximumArgs + "arguments expected."); }
PlayerDoesNotExistError(playerName) { return array("Player " + playerName + " was not found"); }
DvarDoesNotExistError(dvarName) { return array("The dvar " + dvarName + " doesn't exist"); }
