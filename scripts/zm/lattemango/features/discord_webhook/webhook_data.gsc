#include scripts\zm\lattemango\features\discord_webhook\data\objects\author;
#include scripts\zm\lattemango\features\discord_webhook\data\objects\field;
#include scripts\zm\lattemango\features\discord_webhook\data\objects\footer;
#include scripts\zm\lattemango\features\discord_webhook\data\objects\image;
#include scripts\zm\lattemango\features\discord_webhook\data\objects\provider;
#include scripts\zm\lattemango\features\discord_webhook\data\objects\thumbnail;
#include scripts\zm\lattemango\features\discord_webhook\data\objects\video;

#include scripts\zm\lattemango\features\discord_webhook\data\allowed_mentions;
#include scripts\zm\lattemango\features\discord_webhook\data\avatar;
#include scripts\zm\lattemango\features\discord_webhook\data\content;
#include scripts\zm\lattemango\features\discord_webhook\data\embeds;
#include scripts\zm\lattemango\features\discord_webhook\data\thread;
#include scripts\zm\lattemango\features\discord_webhook\data\tts;
#include scripts\zm\lattemango\features\discord_webhook\data\username;

#include scripts\zm\lattemango\util\debugprintf;
#include scripts\zm\lattemango\util\httppost;
#include scripts\zm\lattemango\util\playername;

webhook_send_command(message)
{
    data = [];

    headers = [];
    headers["Content-Type"] = "application/json";

    data = content_set(data, "");
    data = tts_set(data, false);
    data = embed_new(data, self playername_get(), ("Executed `" + message + "`"), undefined, undefined, 16218931, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

    request = post_data(level.server_data["discord_webhook_url"], jsonSerialize(data, 0), headers);
}

webhook_send_chat(message)
{
    debugprintf("^5chat message!!!");

    data = [];

    headers = [];
    headers["Content-Type"] = "application/json";

    data = content_set(data, "");
    data = tts_set(data, false);
    data = embed_new(data, self playername_get(), ("`" + message + "`"), undefined, undefined, 6553419, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

    debugprintf("^4data=" + jsonSerialize(data, 4));
    debugprintf("^4headers=" + jsonSerialize(headers, 4));

    request = post_data(level.server_data["discord_webhook_url"], jsonSerialize(data, 0), headers);
}
