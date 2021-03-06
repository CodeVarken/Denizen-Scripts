# Script for linking items in chat
# For Discord compatibility, replace Discord ID and Discord Channel
link_inventorysnapshot:
    type: command
    name: inventorysnapshot
    description: Views a snapshot of an inventory.
    usage: /inventorysnapshot <&lt>ID<&gt>
    script:
    - if <context.server>:
        - queue clear
    - inventory open 'destination:in@generic[title=<el@link_cmd.to_itemscript_hash><&r><server.flag[link_cmd.<context.args.first||>.player].as_player.name><&sq>s Linked Inventory;size=45;contents=<server.flag[link_cmd.<context.args.first||>.inventory]>]'

link_command:
    type: command
    name: link
    description: Link an item, your hotbar, your equipment, or your full inventory in chat.
    usage: /link <&lt>hand_item/hotbar/equipment/inventory<&gt>
    permission: denizen.link
    permission message: "Sorry, you don't have permission to link items!"
    tab complete:
    - determine <li@hand_item|hotbar|equipment|inventory.filter[starts_with[<context.args.first||>]]>
    script:
    - if <context.server>:
        - queue clear
    - choose <context.args.first||null>:
        - case hotbar:
            - if <player.inventory.list_contents.get[1].to[9].exclude[i@air].is_empty>:
                - narrate '<&c>You cannot link an empty hotbar!'
                - queue clear
            - foreach <player.inventory.list_contents.get[1].to[9].exclude[i@air]>:
                - execute as_server 'tellraw @a ["",{"text":"<player.chat_prefix.parse_color> <player.name.display><&r> has linked their hotbar item<&co> "},{"text":"<&lb><def[value].display||<def[value].formatted.to_titlecase>><&r><&rb>","hoverEvent":{"action":"show_item","value":"{<def[value].json>}"}},{"text":"!"}]'
                - run link_messagetodiscord 'def:<def[value]>|hotbar item'
        - case equipment:
            - if <player.equipment.exclude[i@air].is_empty>:
                - narrate '<&c>You<&sq>re wearing nothing! You must be wearing equipment in order to link it.'
                - queue clear
            - foreach <player.equipment>:
                - if <def[value]> == i@air:
                    - foreach next
                - execute as_server 'tellraw @a ["",{"text":"<player.chat_prefix.parse_color> <player.name.display><&r> has linked their <li@boots|leggings|chestplate|helmet.get[<def[loop_index]>]><&co> "},{"text":"<&lb><def[value].display||<def[value].formatted.to_titlecase>><&r><&rb>","hoverEvent":{"action":"show_item","value":"{<def[value].json>}"}},{"text":"!"}]'
            - foreach <player.equipment>:
                - if <def[value]> == i@air:
                    - foreach next
                - run link_messagetodiscord def:<def[value]>|<li@boots|leggings|chestplate|helmet.get[<def[loop_index]>]>
                - wait 5t
        - case inventory:
            - define id <util.random.uuid>
            - flag server link_cmd.<def[id]>.inventory:|:<player.inventory.list_contents.get[10].to[36].pad_right[27].with[i@air]||<li@.pad_right[27].with[i@air]>> duration:30m
            - flag server link_cmd.<def[id]>.inventory:|:<player.inventory.list_contents.get[1].to[9].pad_right[9].with[i@air]||<li@.pad_right[9].with[i@air]>> duration:30m
            - flag server link_cmd.<def[id]>.inventory:|:<player.equipment.reverse> duration:30m
            - flag server link_cmd.<def[id]>.inventory:|:<player.item_in_offhand> duration:30m
            - flag server link_cmd.<def[id]>.player:<player> duration:30m
            - execute as_server 'tellraw @a ["",{"text":"<player.chat_prefix.parse_color> <player.name.display><&r> has linked their<&co> "},{"text":"<&b>inventory","clickEvent":{"action":"run_command","value":"/inventorysnapshot <def[id]>"},"hoverEvent":{"action":"show_text","value":"<&e>Click to view a snapshot of <player.name><&sq>s inventory!"}},{"text":"! The inventory snapshot will expire in 30 minutes!"}]'
            - discord id:sxr message channel:191040977652285450 "<player.name> linked a snapshot of their inventory in the in-game chat! The snapshot will expire in 30 minutes."
        - default:
            - if <player.item_in_hand> == i@air:
                - narrate '<&c>You cannot link air! You must be holding an item.'
                - queue clear
            - execute as_server 'tellraw @a ["",{"text":"<player.chat_prefix.parse_color> <player.name.display><&r> has linked their item<&co> "},{"text":"<&lb><player.item_in_hand.display||<player.item_in_hand.formatted.to_titlecase>><&r><&rb>","hoverEvent":{"action":"show_item","value":"{<player.item_in_hand.json>}"}},{"text":"!"}]'
            - run link_messagetodiscord def:<player.item_in_hand>

link_messagetodiscord:
    type: task
    speed: 0
    definitions: item|type
    script:
    - if <def[item]||i@air> == i@air:
        - queue clear
    - define item_info '<def[item].formatted.to_titlecase>'
    - if <def[item].quantity> == 1:
        - define item_info '<def[item_info].after[ ]>'
    - if <def[type]||null> == null:
        - discord id:sxr message channel:191040977652285450 '<player.name> is linking their **<def[item].display.strip_color||<def[item_info]>>** (<def[item].quantity>x<tern[<def[item].has_display>]: <def[item_info]>||>)!'
    - else:
        - discord id:sxr message channel:191040977652285450 '<player.name> is linking their <def[type]> **<def[item].display.strip_color||<def[item_info]>>** (<def[item].quantity>x<tern[<def[item].has_display>]: <def[item_info]>||>)!'
    - if !<def[item].flags.contains[HIDE_ENCHANTS]>:
        - define ench_list li@
        - foreach <def[item].enchantments.with_levels>:
            - define ench_list '<def[ench_list].include[<s@translation_data.yaml_key[enchantments.<def[value].before[,]>]> <def[value].after[,]>]>'
        - define disc_message_enchants '<&nl><&nl>__**Enchantments**__<&nl><def[ench_list].comma_separated>'
    - if !<def[item].flags.contains[HIDE_ATTRIBUTES]>:
        - define attrb_list li@
        - foreach <def[item].nbt_attributes>:
            - define name '<def[value].before[/].replace[&dot].with[_]>'
            - define slot '<def[value].after[/].before[/]>'
            - define operation '<def[value].before_last[/].after_last[/]>'
            - define atr_value '<def[value].after_last[/]>'
            - define attrb_list '<def[attrb_list].include[<tern[<def[atr_value].is[OR_MORE].than[0]>]:+||-><def[atr_value]><tern[<def[operation].is[EQUALS].to[0]>]:||<&pc>> <s@translation_data.yaml_key[attribute.<def[name]>]> (<def[slot].to_titlecase>)]>'
        - define disc_message_attributes '<&nl><&nl>__**Attributes**__<&nl><def[attrb_list].separated_by[<&nl>]>'
    - discord id:sxr message channel:191040977652285450 '<def[disc_message_enchants]||><&nl><&nl>__**Description**__<&nl><def[item].lore.parse[strip_color].separated_by[<&nl>]><def[disc_message_attributes]||>'

translation_data:
    type: yaml data
    attribute:
        generic_attackDamage: 'Attack Damage'
        generic_maxHealth: 'Health'
        generic_knockbackResistance: 'Knockback Resistance'
        generic_movementSpeed: 'Movement Speed'
        generic_armor: 'Armor'
        generic_armorToughness: 'Armor Toughness'
        generic_attackSpeed: 'Attack Speed'
        generic_luck: 'Luck'
        horse_jumpStrength: 'Jump Strength (Horses)'
        generic_flyingSpeed: 'Flying Speed (Parrots)'
        zombie_spawnReinforcements: 'Reinforcement Chance (Zombies)'
    enchantments:
        ARROW_DAMAGE: 'Power'
        ARROW_FIRE: 'Flame'
        ARROW_INFINITE: 'Infinity'
        ARROW_KNOCKBACK: 'Punch'
        BINDING_CURSE: 'Curse of Binding'
        CHANNELING: 'Channeling'
        DAMAGE_ALL: 'Sharpness'
        DAMAGE_ARTHROPODS: 'Bane of Arthropods'
        DAMAGE_UNDEAD: 'Smite'
        DEPTH_STRIDER: 'Depth Strider'
        DIG_SPEED: 'Efficiency'
        DURABILITY: 'Unbreaking'
        FIRE_ASPECT: 'Fire Aspect'
        FROST_WALKER: 'Frost Walker'
        IMPALING: 'Impaling'
        KNOCKBACK: 'Knockback'
        LOOT_BONUS_BLOCKS: 'Fortune'
        LOOT_BONUS_MOBS: 'Looting'
        LOYALTY: 'Loyalty'
        LUCK: 'Luck of the Sea'
        LURE: 'Lure'
        MENDING: 'Mending'
        OXYGEN: 'Respiration'
        PROTECTION_ENVIRONMENTAL: 'Protection'
        PROTECTION_EXPLOSIONS: 'Blast Protection'
        PROTECTION_FALL: 'Feather Falling'
        PROTECTION_FIRE: 'Fire Protection'
        PROTECTION_PROJECTILE: 'Projectile Protection'
        RIPTIDE: 'Riptide'
        SILK_TOUCH: 'Silk Touch'
        SWEEPING_EDGE: 'Sweeping Edge'
        THORNS: 'Thorns'
        VANISHING_CURSE: 'Curse of Vanishing'
        WATER_WORKER: 'Aqua Affinity'

link_inventory_events:
    type: world
    debug: false
    events:
        on player clicks in inventory:
        - if !<context.inventory.title.starts_with[<el@link_cmd.to_itemscript_hash>]>:
            - queue clear
        - determine passively cancelled
        - wait 1t
        - inventory update
        on player drags in inventory:
        - inject locally 'events.on player clicks in inventory' instantly

#link_chat_events:
#    type: world
#    debug: true
#    events:
#        on player chats:
#        - if <player.item_in_hand> == i@air:
#            - narrate '<&c>You cannot link air! You must be holding an item.'
#            - queue clear
#        - if <player.has_permission[denizen.link]> && <context.message.contains_text[<&pc>item<&pc>]>:
#            - run link_messagetodiscord def:<player.item_in_hand>
#            - determine <context.message.replace[<&pc>item<&pc>].with[<&r><&ss>^item_linkplayer<player><&r>]>
#
#        on player receives message ignorecancelled:true:
#        - if !<context.message.contains_text[<&ss>^item_linkplayer]>:
#            - queue clear
#        - define message <context.raw_json.after[<&lb>].before_last[<&rb>]>
#        - foreach <def[message].after[<&lc>].before_last[<&rc>].split_by[<&rc>,<&lc>].escape_contents>:
#            - foreach <def[value].split_by[&quo,&quo]>:
#                - define attr_name <def[value].before[&co]>
#                - define attr_value <def[value].after[&co]>
#                - if <def[attr_name]> != "&quotext&quo" || !<def[attr_value].starts_with[&quo&ss^item_linkplayer]>:
#                    - foreach next
#                - define player '<def[attr_value].after[&quo&ss^item_linkplayer].before[&quo].unescaped>'
#                - if <def[player]> !matches PLAYER:
#                    - foreach next
#                - define text '"text":"<def[player].item_in_hand.display||<def[player].item_in_hand.formatted.to_titlecase>>","hoverEvent":{"action":"show_item","value":"{<def[player].item_in_hand.json>}"}'
#                - define message <def[message].before[<def[value].unescaped>]><def[text]><def[message].after[<def[value].unescaped>]>
#        - determine 'RAW_JSON:{"extra":[<def[message]>],"text":""}'
