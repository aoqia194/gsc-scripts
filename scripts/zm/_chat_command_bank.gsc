// Developed by lattemango

// Resxt's base chat commands script.
#include scripts\chat_commands;
// My utility classes.
#include scripts\zm\lattemango_chatcommands\util\_database;
#include scripts\zm\lattemango_chatcommands\util\_debugprint;
#include scripts\zm\lattemango_chatcommands\util\_error;
#include scripts\zm\lattemango_chatcommands\util\_tostring;

// Used with set_map_stat(), get_map_stat()
#include maps\mp\zombies\_zm_stats;
// Used with do_player_general_vox()
#include maps\mp\zombies\_zm_utility;

deposit_bank(points)
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
        self thread do_player_general_vox("general", "exert_sigh", 10, 50);
        self tell("You don't have enough points!");
        return;
    }
    /*if ((self.pers["account_bank"] + points) == 1000000)
    {
        self tell("^6You^7 have reached your bank's maximum capacity!");
        return;
    }*/

    // Play the deposit sound because why not!
    self playsoundtoplayer("zmb_vault_bank_deposit", self);
    // Take the points from the player's score.
    self.score -= points;
    // Add the points to the player's bank.
    self.pers["account_bank"] += points;
    self.account_value = (self.pers["account_bank"] / 1000);
    // Update the player's external bank data.
    self database_update_playerdata();
    // Set the player's physical bank stats to the chat bank.
    self set_map_stat("depositBox", self.account_value);
    // Play the vox
    if (isdefined(level.custom_bank_deposit_vo))
    {
        self thread [[level.custom_bank_deposit_vo]]();
    }

    self tell("^6" + self.name + "^7 has deposited ^2$" + points);
}

deposit_bank_command(args)
{
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!(isdefined(debug) && debug))
    {
        deposit_bank(args[0]);
        return;
    }

    // Command error checking.
    if (args.size < 1) { return NotEnoughArgsError(1); }
    if (args.size > 1) { return TooManyArgsError(1); }
    error = deposit_bank(args[0]);
    if (isdefined(error)) { return error; }
}

withdraw_bank(points)
{
    if (points == "all")
    {
        points = self.pers["account_bank"];
    }

    points = int(points);

    if (points <= 0)
    {
        return;
    }
    if (self.pers["account_bank"] < points)
    {
        self thread do_player_general_vox("general", "exert_sigh", 10, 50);
        self tell("You don't have enough points!");
        return;
    }
    if ((self.score + points) > 1000000)
    {
        self tell("Your score will overflow if you withdraw that much!");
        return;
    }

    // Play the withdraw sound
    self playsoundtoplayer("zmb_vault_bank_withdraw", self);
    // For every 1000 points the player withdraws, there is fee of 100 points.
    bank_fee = 100 * int(points / 1000);
    // Take the points from the player's bank.
    self.pers["account_bank"] -= points;
    self.account_value = (self.pers["account_bank"] / 1000);
    // Give the points to the player.
    self.score += (points - bank_fee);
    level notify("bank_withdrawal");
    // Update the player's external bank data.
    self database_update_playerdata();
    // Set the player's physical bank stats to the chat bank.
    self set_map_stat("depositBox", self.account_value);
    // Play the vox
    if (isdefined(level.custom_bank_withdrawl_vo))
    {
        self thread [[level.custom_bank_withdrawl_vo]]();
    }
    else
    {
        self thread do_player_general_vox("general", "exert_laugh", 10, 50);
    }

    self tell("^6" + self.name + "^7 has withdrawn ^2$" + points + "^7 (Fee: ^1$" + bank_fee + "^7)");
}

withdraw_bank_command(args)
{
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!(isdefined(debug) && debug))
    {
        withdraw_bank(args[0]);
        return;
    }

    // Command error checking.
    if (args.size < 1) { return NotEnoughArgsError(1); }
    if (args.size > 1) { return TooManyArgsError(1); }
    error = withdraw_bank(args[0]);
    if (isdefined(error)) { return error; }
}

balance_bank()
{
    self tell("^6" + self.name + "^7 has ^2$" + self.pers["account_bank"] + "^7 in their bank.");
}

balance_bank_command(args)
{
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!(isdefined(debug) && debug))
    {
        balance_bank();
        return;
    }

    // Command error checking.
    if (args.size > 0) { return TooManyArgsError(0); }
    error = balance_bank();
    if (isdefined(error)) { return error; }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "deposit", "function", ::deposit_bank_command, 3);
    CreateCommand(level.chat_commands["ports"], "d", "function", ::deposit_bank_command, 3);

    CreateCommand(level.chat_commands["ports"], "withdraw", "function", ::withdraw_bank_command, 3);
    CreateCommand(level.chat_commands["ports"], "w", "function", ::withdraw_bank_command, 3);
    
    CreateCommand(level.chat_commands["ports"], "balance", "function", ::balance_bank_command, 3);
    CreateCommand(level.chat_commands["ports"], "b", "function", ::balance_bank_command, 3);
    
    printf("Executed \'scripts/zm/lattemango_chatcommands/_chat_command_bank::init\'");
}
