// function: Creates a new footer for use in embeds.
// text: string
// icon_url?: string
// proxy_icon_url?: string
footer_new(text, icon_url, proxy_icon_url)
{
    footer = [];

    if (isdefined(text))
    {
        field["text"] = text;
    }

    if (isdefined(icon_url))
    {
        field["icon_url"] = icon_url;
    }

    if (isdefined(proxy_icon_url))
    {
        field["proxy_icon_url"] = proxy_icon_url;
    }

    return footer;
}
