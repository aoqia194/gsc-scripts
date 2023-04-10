#include scripts\zm\lattemango\util\debugprintf;

init()
{
    debugprintf("^3Trying to get Discord webhook...");

    file_path = (level.server_data["path"] + "discord_webhook.json");
    if (fileExists(file_path))
    {
        file = fopen(file_path, "r");
        webhook_url = fread(file);
        fclose(file);

        level.server_data["discord_webhook_url"] = webhook_url;
    }
    else
    {
        debugprintf("^3Discord webhook not found. Continuing...");
        return;
    }
    debugprintf("^2Discord webhook found!");

    scripts\zm\lattemango\features\discord_webhook\chat_listener::init();
}
