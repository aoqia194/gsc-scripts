// function: Enables text-to-speech for the current message.
// data: array (HTTP)
// state: bool
tts_set(data, state)
{
    data["tts"] = state;
    return data;
}
