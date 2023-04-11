// My utility classes.
#include scripts\zm\lattemango\util\database;
#include scripts\zm\lattemango\util\debugprintf;
#include scripts\zm\lattemango\util\type;
// Used for map stats stuff.
#include maps\mp\zombies\_zm_stats;
// Used with vox stuff.
#include maps\mp\zombies\_zm_utility;

rank_update()
{
    while (!isdefined(self.pers["account_rank"]))
    {
        debugprintf("RANKUP", "^3ACCOUNT_RANK_NOT_FOUND WAIT");
        wait 1;
    }

    self setclantag("^5R" + self.pers["account_rank"]);
}

rank_rankup(levels)
{
    levels = int(levels);

    if (levels <= 0)
    {
        return;
    }

    // You can do all kinds of math to calculate the fee for ranking up per level.
    rankupFee = int(levels * (sqrt(self.pers["account_rank"] * 25) / 2));

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
        // No one should realisticly be able to get here!
        debugprintf("RANKUP", "^1IMPOSSIBLE_EXECUTION");
        return;
    }

    // Update player rank!
    self.pers["account_rank"] += levels;
    self database_cache_playerdata_update();

    self rank_update();
    say("^6" + self.pers["account_name"] + "^7 is now ^2Rank " + self.pers["account_rank"] + "^7 (Fee:^1 " + rankupFee + "^7)");
}

rank_display()
{
    say("^6" + self.pers["account_name"] + "^7 is ^2Rank " + self.pers["account_rank"] + "^7.");
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread rank_update();
    }
}

init()
{
    level thread on_player_connect();
}
