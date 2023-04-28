// afluffyofox

chat_listener()
{
    for (;;)
    {
        level waittill("say", message, player);

        player thread scripts\zm\afluffyofox\util\commands::on_player_message(message);

        if (level.server_data["discord_webhook"])
        {
            player thread scripts\zm\afluffyofox\features\discord_webhook\discord_webhook::on_player_message(message);
        }
    }
}

init()
{
    level thread chat_listener();
}
