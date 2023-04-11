#include scripts\zm\lattemango\util\debugprintf;

init()
{
    file_path = (level.server_data["path"] + "discord_webhook.json");
    if (fileExists(file_path))
    {
        file = fopen(file_path, "r");
        webhook_url = fread(file);
        fclose(file);

        if (webhook_url == "")
        {
            debugprintf("WEBHOOK", "^3NOT_FOUND CONTINUE");
            return;
        }

        level.server_data["discord_webhook_url"] = webhook_url;
    }
    else
    {
        writefile(file_path, "");

        debugprintf("WEBHOOK", "^3NOT_FOUND CONTINUE");
        return;
    }
    debugprintf("WEBHOOK", "^2FOUND SUCCESS");

    scripts\zm\lattemango\features\discord_webhook\chat_listener::init();
}
