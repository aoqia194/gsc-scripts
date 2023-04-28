// afluffyofox

// function: Enables text-to-speech for the current message.
// data: array (HTTP)
// state: bool
set_tts(data, state)
{
    data["tts"] = state;
    return data;
}
