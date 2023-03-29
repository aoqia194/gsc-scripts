// Developed by lattemango

#include scripts\zm\chat_commands;

#include scripts\zm\util\debugprint;
#include scripts\zm\util\error;
#include scripts\zm\util\tostring;

updateRankData(value)
{
    value = int(value);
    debugPrint("^3Trying to update " + self getGuid() + "'s rank file!");

    if (!isDefined(value) || value < 0)
    {
        debugPrint("^1Failed to update rank file!\n\tReason: Undefined OR Negative\n\tData=" + value);
        self tell("^1An error occurred while trying to update your rank data!");
        return;
    }

    path = "playerData/" + self getGuid() + "/rank.txt";
    file = fopen(path, "w");
    fwrite(file, tostring(value));
    debugPrint("^2Rank file successfully wrote!");
    fclose(file);
}

rankup(levels)
{
    if (levels <= 0)
    {
        return;
    }

    // You can do all kinds of math to calculate the fee for ranking up per level.
    rankupFee = (levels * (self.pers["rank"] * 2000));

    // Making sure the player has the money either in the bank or in their score.
    if (self.pers["bank"] < rankupFee && self.score < rankupFee)
    {
        self tell("You don't have enough points! ^2Rank " + (self.pers["rank"] + levels) + "^7 requires ^1" + rankupFee + "^7 points!");
        return;
    }

    // If the player has the points to rankup, then use those, otherwise use the bank.
    if (self.score >= rankupFee)
    {
        self.score -= rankupFee;
    }
    else if (self.pers["bank"] >= rankupFee)
    {
        self.pers["bank"] -= rankupFee;
        self scripts\zm\chat_command_bank::updateBankData(self.pers["bank"]);
    }
    else
    {
        // No one should realisticly be able to get here!
        return;
    }

    // Update player rank!
    self.pers["rank"] += levels;
    self updateRankData(self.pers["rank"]);

    self tell("^6You^7 are now ^2Rank " + self.pers["rank"] + "^7 (Fee:^1 " + rankupFee + "^7)");
}

rankupCommand(args)
{
    // If we are not debugging, then don't display command errors.
    debug = level.pers["chat_commands_debug"];
    if (!(isDefined(debug) && debug))
    {
        if (!isDefined(args[0]))
        {
            rankup(1);
        }
        else
        {
            rankup(args[0]);
        }
        return;
    }

    // Command error checking.
    if (args.size > 1) { return TooManyArgsError(1); }
    if (args.size < 1) { error = rankup(1); }
    else { error = rankup(args[0]); }
    if (IsDefined(error)) { return error; }
}

rank()
{
    self tell("^6You^7 are ^2Rank " + self.pers["rank"] + "^7.");
}

rankCommand(args)
{
    // If we are not debugging, then don't display command errors.
    debug = level.pers["chat_commands_debug"];
    if (!(isDefined(debug) && debug))
    {
        rank();
        return;
    }

    // Command error checking.
    if (args.size > 0) { return; }
    error = rank();
    if (IsDefined(error)) { return error; }
}

initRank()
{
    // End the thread when a player disconnects or when the server ends the game.
    // You don't want it running when the game is over or when the player isn't even playing the game.
    self endon("disconnect");
    level endon("end_game");
    
    // If the player already has an external rank file defined, just read from it instead.
    path = "playerData/" + self getGuid() + "/rank.txt";
    if (fileExists(path))
    {
        data = tostring(readFile(path));
        if (!(data == "" || data == " " || fileSize(path) == 0))
        {
            self.pers["rank"] = int(data);
            return;
        }

        debugPrint("^1Rank file was invalid, reinitialising!");
    }

    // Try to create the player's external rank file.
    // If it doesn't exist, we retry infinitely until it does exist.
    while(!fileExists(path))
    {
        writeFile(path, "");
        wait 1;
    }

    // Open the file we just created and initialise it with 0.
    file = fopen(path, "w");
    fwrite(file, "0");
    fclose(file);
    debugPrint("^2Rank file initialised.");

    // Initialise the player's rank to 1;
    self.pers["rank"] = 1;
}

onPlayerConnected()
{
    for (;;)
    {
        level waittill("connecting", player);
        player thread initRank();
    }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "rank", "function", ::rankCommand, 3);
    CreateCommand(level.chat_commands["ports"], "rankup", "function", ::rankupCommand, 3);

    level thread onPlayerConnected();
}
