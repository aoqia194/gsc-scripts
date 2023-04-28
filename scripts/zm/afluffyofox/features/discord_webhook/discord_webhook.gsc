// afluffyofox

#include scripts\zm\afluffyofox\features\discord_webhook\data\objects\author;
#include scripts\zm\afluffyofox\features\discord_webhook\data\objects\field;
#include scripts\zm\afluffyofox\features\discord_webhook\data\objects\footer;
#include scripts\zm\afluffyofox\features\discord_webhook\data\objects\image;
#include scripts\zm\afluffyofox\features\discord_webhook\data\objects\provider;
#include scripts\zm\afluffyofox\features\discord_webhook\data\objects\thumbnail;
#include scripts\zm\afluffyofox\features\discord_webhook\data\objects\video;

#include scripts\zm\afluffyofox\features\discord_webhook\data\allowed_mentions;
#include scripts\zm\afluffyofox\features\discord_webhook\data\avatar;
#include scripts\zm\afluffyofox\features\discord_webhook\data\content;
#include scripts\zm\afluffyofox\features\discord_webhook\data\embeds;
#include scripts\zm\afluffyofox\features\discord_webhook\data\thread;
#include scripts\zm\afluffyofox\features\discord_webhook\data\tts;
#include scripts\zm\afluffyofox\features\discord_webhook\data\username;

#include scripts\zm\afluffyofox\util\debugprintf;
#include scripts\zm\afluffyofox\util\httppost;
#include scripts\zm\afluffyofox\util\type;

send_webhook(message, is_command)
{
    data = [];
    headers = [];

    headers["Content-Type"] = "application/json";

    data += set_content(data, "");
    data += set_tts(data, false);

    if (is_command)
    {
        data += create_embed(data, self.pers["account_name"], ("Executed `" + message + "`"), undefined, undefined, 16218931, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
    }
    else
    {
        data += create_embed(data, self.pers["account_name"], ("`" + message + "`"), undefined, undefined, 6553419, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
    }

    send_post_request(level.server_data["discord_webhook_url"], jsonserialize(data, 0), headers);
}

on_player_message(message)
{
    is_command = (message[0] == self.pers["account_command_prefix"]);
    self send_webhook(message, is_command);
}

init()
{
    level.server_data["discord_webhook"] = false;

    file_path = (level.server_data["path"] + "discord_webhook.txt");
    if (fileexists(file_path))
    {
        file = fopen(file_path, "r");
        webhook_url = fread(file);
        fclose(file);

        if (bad_string(webhook_url))
        {
            debugprintf("^3Webhook URL not found.");
            return;
        }

        level.server_data["discord_webhook_url"] = webhook_url;
    }
    else
    {
        writefile(file_path, "");

        debugprintf("^3Webhook file not found.");
        return;
    }
    debugprintf("^2Webhook found.");

    level.server_data["discord_webhook"] = true;
}
