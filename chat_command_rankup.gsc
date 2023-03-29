// Developed by lattemango

#include scripts\zm\chat_commands;

#include scripts\zm\util\error;
#include scripts\zm\util\tostring;

updateRankData(value)
{
    path = "playerData/" + self getGuid() + "/rank.txt";
    file = fopen(path, "w");
    fwrite(file, value);
    fclose(file);
}

rankup(levels)
{
    // Change this number accordingly.
    // You can do all kinds of math to calculate the fee for ranking up per level.
    // Update player bank!
    rankupFee = self.pers["rank"] * 1000;
    scripts\zm\chat_command_bank::updateBankData(self.pers["bank"] - rankupFee);

    // Update player rank!
    newRank = self.pers["rank"] + 1;
    updateRankData(newRank);

    self tell("^6You^7 are now ^2Rank " + newRank + "^7 (Fee:^1 " + rankupFee + "^7)");
}

rankupCommand(args)
{
    if (args.size > 1)
    {
        return TooManyArgsError(1);
    }
    if (args.size < 1)
    {
        error = rankup(1);
    }
    else
    {
        error = rankup(args[0]);
    }

    if (IsDefined(error))
    {
        return error;
    }
}

rank()
{
    self tell("^6You^7 are ^2Rank " + self.pers["rank"] + "^7.");
}

rankCommand(args)
{
    if (args.size > 0)
    {
        return;
    }
    error = rank();

    if (IsDefined(error))
    {
        return error;
    }
}

initRank()
{
    self endon("disconnect");
    level endon("end_game");
    
    path = "playerData/" + self getGuid() + "/rank.txt";
    if (fileExists(path))
    {
        self.pers["rank"] = int(readFile(path));
        return;
    }

    writeFile(path, "");
    while(!fileExists(path)) wait 0.5;

    file = fopen(path, "a");
    fwrite(file, "1");
    fclose(file);

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
