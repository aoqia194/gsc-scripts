// afluffyofox

#include scripts\zm\afluffyofox\util\database;
#include scripts\zm\afluffyofox\util\debugprintf;
#include scripts\zm\afluffyofox\util\type;

#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_utility;

bank_deposit(points)
{
    if (points == "all")
    {
        points = self.score;
    }

    if (int64_op(points, "<=", 0))
    {
        return;
    }

    if (int64_op(self.score, "<", points))
    {
        self thread do_player_general_vox("general", "exert_sigh", 10, 50);
        self tell("^1You don't have enough points!");
        return;
    }

    /*if (int64_op((self.pers["account_bank"] + points), "==", 1000000))
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
    self update_playerdata_cache();
    // Set the player's physical bank stats to the chat bank.
    self set_map_stat("depositBox", self.account_value);
    // Play the vox
    if (isdefined(level.custom_bank_deposit_vo))
    {
        self thread [[level.custom_bank_deposit_vo]]();
    }

    say("^6" + self.pers["account_name"] + "^7 has deposited ^2$" + points);
}

bank_withdraw(points)
{
    if (points == "all")
    {
        points = self.pers["account_bank"];
    }

    if (int64_op(points, "<=", 0))
    {
        return;
    }

    if (int64_op(self.pers["account_bank"], "<", points))
    {
        self thread do_player_general_vox("general", "exert_sigh", 10, 50);
        self tell("^1You don't have enough points!");
        return;
    }

    if (int64_op((self.score + points), ">", 1000000))
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
    self update_playerdata_cache();
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

    say("^6" + self.pers["account_name"] + "^7 has withdrawn ^2$" + points + "^7 (Fee: ^1$" + bank_fee + "^7)");
}

bank_balance()
{
    playername = self.pers["account_name"];
    account_bank = self.pers["account_bank"];

    if (!isdefined(playername) || !isdefined(account_bank))
    {
        debugprintf("BANK", "^1HOW DID WE GET HERE? THIS IS CRITICAL!!!");
        return;
    }

    say("^6" + playername + "^7 has ^2$" + account_bank + "^7 in their bank.");
}
