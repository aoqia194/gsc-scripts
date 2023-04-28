// afluffyofox

get_map_name()
{
    mapname = level.script;
    gametype = level.scr_zm_ui_gametype;
    location = level.scr_zm_map_start_location;

    if (mapname == "zm_transit")
    {
        return "zm_" + location + "_" + gametype;
    }

    return mapname + "_" + gametype;
}

get_map_name_fancy()
{
    mapname = get_map_name();
    switch(mapname)
    {
        case "zm_transit_zclassic":  return "Transit";
        case "zm_transit_zstandard": return "Transit (Survival)";
        case "zm_town_zstandard":    return "Town";
        case "zm_town_zgrief":       return "Town (Grief)";
        case "zm_farm_zstandard":    return "Farm";
        case "zm_farm_zgrief":       return "Farm (Grief)";
        case "zm_diner_zcleansed":   return "Diner (Turned)";
        case "zm_prison_zclassic":   return "MOTD";
        case "zm_prison_zgrief":     return "MOTD (Grief)";
        case "zm_nuked_zstandard":   return "Nuketown";
        case "zm_tomb_zclassic":     return "Origins";
        case "zm_buried_zclassic":   return "Buried";
        case "zm_buried_zgrief":     return "Buried (Grief)";
        case "zm_buried_zcleansed":  return "Buried (Turned)";
        case "zm_highrise_zclassic": return "Die Rise";
    }
}

get_map_names()
{
    return array("zm_transit_zclassic", "zm_transit_zstandard", "zm_town_zstandard", "zm_town_zgrief", "zm_farm_zstandard", "zm_farm_zgrief", "zm_diner_zcleansed", "zm_prison_zclassic", "zm_prison_zgrief", "zm_nuked_zstandard", "zm_tomb_zclassic", "zm_buried_zclassic", "zm_buried_zgrief", "zm_buried_zcleansed", "zm_highrise_zclassic");
}
