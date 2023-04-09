mapname_get()
{
    if (level.script == "zm_transit")
    {
        return "zm_" + level.scr_zm_map_start_location;
    }

    return level.script;
}

mapname_get_fancy()
{
    mapname = mapname_get();

    switch(mapname)
    {
        case "zm_transit":  return "Transit";
        case "zm_town":     return "Town";
        case "zm_farm":     return "Farm";
        case "zm_prison":   return "MOTD";
        case "zm_nuked":    return "Nuketown";
        case "zm_tomb":     return "Origins";
        case "zm_buried":   return "Buried";
        case "zm_highrise": return "Die Rise";
    }
}
