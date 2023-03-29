// Developed by lattemango

#include scripts\zm\chat_commands;

#include scripts\zm\util\error;
#include scripts\zm\util\tostring;

updateBankData(value)
{
    path = "playerData/" + self getGuid() + "/bank.txt";
    file = fopen(path, "w");
    fwrite(file, value);
    fclose(file);
}

depositBank(points)
{
    points = int(points);
    if (points < 1)
    {
        return;
    }

    self.pers["bank"] += points;
    self.score -= points;
    self updateBankData((self.pers["bank"] + points));

    self tell("^6" + self.name + "^7 has deposited ^2$" + points);
}

depositBankCommand(args)
{
    if (args.size < 1)
    {
        return NotEnoughArgsError(1);
    }
    if (args.size > 1)
    {
        return TooManyArgsError(1);
    }

    error = depositBank(args[0]);
    if (IsDefined(error))
    {
        return error;
    }
}

withdrawBank(points)
{
    points = int(points);
    if (points < 1)
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
        self tell("Your score has already reached maximum!");
        return;
    }

    bank_fee = 100 * int(points / 1000);
    self.pers["bank"] -= points;
    self.score += (points - bank_fee);
    self updateBankData((self.pers["bank"] - points));

    self tell("^6" + self.name + "^7 has withdrawn ^2$" + points + "^7 (Fee: ^1$" + bank_fee + "^7)");
}

withdrawBankCommand(args)
{
    if (args.size < 1)
    {
        return NotEnoughArgsError(1);
    }
    if (args.size > 1)
    {
        return TooManyArgsError(1);
    }

    error = withdrawBank(args[0]);
    if (IsDefined(error))
    {
        return error;
    }
}

balanceBank()
{
    self tell("^6" + self.name + "^7 has ^2$" + self.pers["bank"] + "^7 in their bank.");
}

balanceBankCommand(args)
{
    if (args.size > 0)
    {
        return TooManyArgsError(0);
    }

    error = balanceBank();
    if (isDefined(error))
    {
        return error;
    }
}

initBank()
{
    // End the thread when a player disconnects or when the server ends the game.
    // You don't want it running when the game is over or when the player isn't even playing the game.
    self endon("disconnect");
    level endon("end_game");
    
    // If the player already has a bank defined, just read from that instead.
    path = "playerData/" + self getGuid() + "/bank.txt";
    if (fileExists(path))
    {
        self.pers["bank"] = int(readFile(path));
        return;
    }

    // Try to create bank.txt
    // If it doesn't exist, we retry infinitely until it does exist.
    while(!fileExists(path))
    {
        writeFile(path, "");
        print("trying to write bank file!");
        wait 0.5;
    }
    print("bank file successfully wrote!");

    // Open the file we just created and initialise it with 0.
    file = fopen(path, "a");
    fwrite(file, "0");
    fclose(file);
    print("bank file initialised.");

    // Set the player's bank to 0;
    self.pers["bank"] = 0;  
}

onPlayerConnected()
{
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
