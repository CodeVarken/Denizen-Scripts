DropRateBooster2x:
    type: item
    material: potion[flags=li@HIDE_ENCHANTS|HIDE_POTION_EFFECTS;nbt=li@uncraftable/true;color=co@0,0,255;lore=<proc[lineWrap].context[<&6>Luck magic has been stopped inside this bottle. Release it to gain an aura improving your ability to find rare items from hunting monsters!|40]>]
    display name: "<&a>Bottled Luck"
    enchantments:
    - MENDING:1
DropRateBooster4x:
    type: item
    material: potion[flags=li@HIDE_ENCHANTS|HIDE_POTION_EFFECTS;nbt=li@uncraftable/true;color=co@0,0,255;lore=<proc[lineWrap].context[<&6>Luck magic has been stopped inside this bottle. Release it to gain an aura greatly improving your ability to find rare items from hunting monsters!|40]>]
    display name: "<&a>Improved Bottled Luck"
    enchantments:
    - MENDING:1
drop_rate_booster_handler:
    type: world
    debug: true
    events:
        on player consumes DropRateBooster2x:
        - take DropRateBooster2x
        - narrate "<&6>You consume the potion and are imbued with magical energy! Your ability to find rare items from hunting monsters is improved for the next 30 minutes."
        - flag player player_drop_rate:2 duration:30m
        - flag player has_buff:true duration:30m
        - wait 30m
        - narrate "<&6>The item-finding aura wears off..."
        on player consumes DropRateBooster4x:
        - take DropRateBooster4x
        - narrate "<&6>You consume the potion and are imbued with magical energy! Your ability to find rare items from hunting monsters is improved for the next 30 minutes."
        - flag player player_drop_rate:4 duration:30m
        - flag player has_buff:true duration:30m
        - wait 30m
        - narrate "<&6>The item-finding aura wears off..."