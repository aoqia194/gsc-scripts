// function: This function sets the content of the message.
// data: array (HTTP)
// content: string
content_set(data, content)
{
    data["content"] = content;
    return data;
}
