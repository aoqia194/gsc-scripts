init()
{
    level.server_data["path"] = "server_data/";

    scripts\zm\afluffyofox\util\chat_listener::init();
    scripts\zm\afluffyofox\util\database::init();
    scripts\zm\afluffyofox\features\chat_commands\chat_commands::init();
    scripts\zm\afluffyofox\features\discord_webhook\discord_webhook::init();
}
