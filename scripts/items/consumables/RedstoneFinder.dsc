RedstoneFinderBooster2x:
    type: item
    material: potion[flags=li@HIDE_ENCHANTS|HIDE_POTION_EFFECTS;nbt=li@uncraftable/true;color=co@255,0,0;lore=<proc[lineWrap].context[<&6>This brew is radiating pure magical energy. Rumor has it that drinking it will attune you to the forces of magic.|40]>]
    display name: "<&a>Magic-Leeching Brew"
    enchantments:
    - MENDING:1
RedstoneFinderBooster4x:
    type: item
    material: potion[flags=li@HIDE_ENCHANTS|HIDE_POTION_EFFECTS;nbt=li@uncraftable/true;color=co@255,0,0;lore=<proc[lineWrap].context[<&6>This brew is radiating pure magical energy. Rumor has it that drinking it will greatly attune you to the forces of magic.|40]>]
    display name: "<&a>Improved Magic-Leeching Brew"
    enchantments:
    - MENDING:1
redstone_finder_booster_handler:
    type: world
    debug: true
    events:
        on player consumes RedstoneFinderBooster2x:
        - take RedstoneFinderBooster2x
        - narrate "<&6>You consume the potion and become attuned to the forces of magic! Foes you slay may drop redstone."
        - flag player player_redstone_finder_rate:2 duration:30m
        - flag player has_buff:true duration:30m
        - wait 30m
        - narrate "<&6>The attunement to magic wears off..."
        on player consumes RedstoneFinderBooster4x:
        - take RedstoneFinderBooster4x
        - narrate "<&6>You consume the potion and become greatly attuned to the forces of magic! Foes you slay may drop redstone."
        - flag player player_redstone_finder_rate:4 duration:30m
        - flag player has_buff:true duration:30m
        - wait 30m
        - narrate "<&6>The attunement to magic wears off..."