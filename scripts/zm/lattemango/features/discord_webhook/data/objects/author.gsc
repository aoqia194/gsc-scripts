// function: Creates a new author for use in embeds.
// name: string
// url?: string
// icon_url?: string
// proxy_icon_url?: string
author_new(name, url, icon_url, proxy_icon_url)
{
    author = [];

    if (isdefined(name))
    {
        author["name"] = name;

        if (isdefined(url))
        {
            author["url"] = url;
        }

        if (isdefined(icon_url))
        {
            author["icon_url"] = icon_url;
        }

        if (isdefined(proxy_icon_url))
        {
            author["proxy_icon_url"] = proxy_icon_url;
        }
    }

    return author;
}
