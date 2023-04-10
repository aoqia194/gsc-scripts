#include scripts\zm\lattemango\util\debugprintf;

// function: This function allows a user to create a new embed for the webhook.
// data: array (HTTP)
// title: string
// description: string
// url: string
// timestamp: string (ISO8601)
// colour: int (decimal)
// footer: footer object
// image: image object
// thumbnail: thumbnail object
// video: video object
// provider: provider object
// author: author object
// fields: fields object
embed_new(data, title, description, url, timestamp, colour, footer, image, thumbnail, video, provider, author, fields)
{
    embed = [];

    if (!isdefined(data))
    {
        debugprintf("^1!!!Data wasn't defined when creating an embed. Uh-oh!!!");
        return;
    }

    if (isdefined(title))
    {
        embed["title"] = title;
    }

    if (isdefined(description))
    {
        embed["description"] = description;
    }

    if (isdefined(url))
    {
        embed["url"] = url;
    }

    if (isdefined(timestamp))
    {
        embed["timestamp"] = timestamp;
    }

    if (isdefined(colour))
    {
        embed["color"] = colour;
    }

    if (isdefined(footer))
    {
        embed["footer"] = footer;
    }

    if (isdefined(image))
    {
        embed["image"] = image;
    }

    if (isdefined(thumbnail))
    {
        embed["thumbnail"] = thumbnail;
    }

    if (isdefined(video))
    {
        embed["video"] = video;
    }

    if (isdefined(provider))
    {
        embed["provider"] = provider;
    }

    if (isdefined(author))
    {
        embed["author"] = author;
    }

    if (isdefined(fields))
    {
        embed["fields"] = fields;
    }

    debugprintf("^3embed json=" + embed);

    size = 0;
    if (isdefined(data["embeds"].size))
    {
        size = data["embeds"].size + 1;
    }

    data["embeds"][size] = embed;

    debugprintf("^3data json after embed=" + data);

    return data;
}