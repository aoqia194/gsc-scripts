// Developed by lattemango

#include scripts\zm\chat_commands;

#include scripts\zm\util\debugprint;
#include scripts\zm\util\error;
#include scripts\zm\util\tostring;

updateBankData(value)
{
    value = int(value);
    debugPrint("^3Trying to update " + self getGuid() + "'s bank file!");

    if (!isDefined(value) || value < 0)
    {
        debugPrint("^1Failed to update bank file!\n\tReason: Undefined OR Negative\n\tData=" + value);
        self tell("^1An error occurred while trying to update your bank data!");
        return;
    }

    path = "playerData/" + self getGuid() + "/bank.txt";
    file = fopen(path, "w");
    fwrite(file, tostring(value));
    debugPrint("^2Bank file successfully wrote!");
    fclose(file);
}

depositBank(points)
{
    if (points == "all")
    {
        points = self.score;
    }

    points = int(points);

    if (points <= 0)
    {
        return;
    }
    if (self.score < points)
    {
        self tell("You don't have enough points!");
        return;
    }
    /*if ((self.pers["bank"] + points) == 1000000)
    {
        self tell("^6You^7 have reached your bank's maximum capacity!");
        return;
    }*/

    // Take the points from the player's score.
    self.score -= points;
    // Add the points to the player's bank.
    self.pers["bank"] += points;
    // Update the player's external bank data.
    self updateBankData(self.pers["bank"]);

    self tell("^6" + self.name + "^7 has deposited ^2$" + points);
}

depositBankCommand(args)
{
    // If we are not debugging, then don't display command errors.
    debug = level.pers["chat_commands_debug"];
    if (!(isDefined(debug) && debug))
    {
        depositBank(args[0]);
        return;
    }

    // Command error checking.
    if (args.size < 1) { return NotEnoughArgsError(1); }
    if (args.size > 1) { return TooManyArgsError(1); }
    error = depositBank(args[0]);
    if (IsDefined(error)) { return error; }
}

withdrawBank(points)
{
    if (points == "all")
    {
        points = self.pers["bank"];
    }

    points = int(points);

    if (points <= 0)
    {
        return;
    }
    if (self.pers["bank"] < points)
    {
        self tell("You don't have enough points!");
        return;
    }
    if ((self.score + points) > 1000000)
    {
        self tell("Your score will overflow if you withdraw that much!");
        return;
    }

    // For every 1000 points the player withdraws, there is fee of 100 points.
    bank_fee = 100 * int(points / 1000);
    // Take the points from the player's bank.
    self.pers["bank"] -= points;
    // Give the points to the player.
    self.score += (points - bank_fee);
    // Update the player's external bank data.
    self updateBankData(self.pers["bank"]);

    self tell("^6" + self.name + "^7 has withdrawn ^2$" + points + "^7 (Fee: ^1$" + bank_fee + "^7)");
}

withdrawBankCommand(args)
{
    // If we are not debugging, then don't display command errors.
    debug = level.pers["chat_commands_debug"];
    if (!(isDefined(debug) && debug))
    {
        withdrawBank(args[0]);
        return;
    }

    // Command error checking.
    if (args.size < 1) { return NotEnoughArgsError(1); }
    if (args.size > 1) { return TooManyArgsError(1); }
    error = withdrawBank(args[0]);
    if (IsDefined(error)) { return error; }
}

balanceBank()
{
    self tell("^6" + self.name + "^7 has ^2$" + self.pers["bank"] + "^7 in their bank.");
}

balanceBankCommand(args)
{
    // If we are not debugging, then don't display command errors.
    debug = level.pers["chat_commands_debug"];
    if (!(isDefined(debug) && debug))
    {
        balanceBank();
        return;
    }

    // Command error checking.
    if (args.size > 0) { return TooManyArgsError(0); }
    error = balanceBank();
    if (isDefined(error)) { return error; }
}

initBank()
{
    // End the thread when a player disconnects or when the server ends the game.
    // You don't want it running when the game is over or when the player isn't even playing the game.
    self endon("disconnect");
    level endon("end_game");
    
    // If the player already has an external bank file defined, just read from it instead.
    path = "playerData/" + self getGuid() + "/bank.txt";
    if (fileExists(path))
    {
        data = tostring(readFile(path));
        if (!(data == "" || data == " " || fileSize(path) == 0))
        {
            self.pers["bank"] = int(data);
            debugPrint("^2Bank file found!");
            return;
        }

        debugPrint("^1Bank file was invalid, reinitialising!");
    }

    // Try to create the player's external bank file.
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
    debugPrint("^2Bank file initialised.");

    // Initialise the player's bank to 0;
    self.pers["bank"] = 0;
}

onPlayerConnected()
{
    // For every player that is connected, we initialise their bank!
    for (;;)
    {
        level waittill("connected", player);
        player thread initBank();
    }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "deposit", "function", ::depositBankCommand, 3);
    CreateCommand(level.chat_commands["ports"], "withdraw", "function", ::withdrawBankCommand, 3);
    CreateCommand(level.chat_commands["ports"], "balance", "function", ::balanceBankCommand, 3);

    level thread onPlayerConnected();
}
