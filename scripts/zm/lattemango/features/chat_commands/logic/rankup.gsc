// afluffyofox

#include scripts\zm\afluffyofox\util\database;
#include scripts\zm\afluffyofox\util\debugprintf;
#include scripts\zm\afluffyofox\util\type;

#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_utility;

update_rank()
{
    while (!isdefined(self.pers["account_rank"]))
    {
        debugprintf("^3account_rank wasn't found! Waiting...");
        wait 1;
    }

    self setclantag("^1R" + self.pers["account_rank"]);
}

player_rankup(levels)
{
    levels = int(levels);

    if (levels <= 0)
    {
        return;
    }

    // You can do all kinds of math to calculate the fee for ranking up per level.
    rankupFee = int(levels * 1000);

    // Making sure the player has the money either in the bank or in their score.
    if (int64_op(self.pers["account_bank"], "<", rankupFee) && int64_op(self.score, "<", rankupFee))
    {
        self thread do_player_general_vox("general", "exert_sigh", 10, 50);
        self tell("^1You don't have enough points! ^2Rank " + (self.pers["account_rank"] + levels) + "^7 requires ^1" + rankupFee + "^7 points!");
        return;
    }

    self playsoundtoplayer("zmb_vault_bank_withdraw", self);

    // If the player has the points to rankup, then use those, otherwise use the bank.
    if (int64_op(self.score, ">=", rankupFee))
    {
        self.score -= rankupFee;
    }
    else if (int64_op(self.pers["account_bank"], ">=", rankupFee))
    {
        self.pers["account_bank"] -= rankupFee;
        self.account_value = (self.pers["account_bank"] / 1000);
        // Set the player's physical bank stats to the chat bank.
        self set_map_stat("depositBox", self.account_value);
    }
    else
    {
        return;
    }

    self.pers["account_rank"] += levels;
    self update_playerdata_cache();
    self update_rank();

    say("^6" + self.pers["account_name"] + "^7 is now ^2Rank " + self.pers["account_rank"] + "^7 (Fee:^1 " + rankupFee + "^7)");
}

display_rank()
{
    say("^6" + self.pers["account_name"] + "^7 is ^2Rank " + self.pers["account_rank"] + "^7.");
}

on_player_connected()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread update_rank();
    }
}

init()
{
    level thread on_player_connect();
}
