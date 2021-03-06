"Player Login Checker":
    type: world
    debug: false
    events:
        on player joins:
        - announce to_console "Checking if player <player.name> has daily login flag, flag is <server.flag[daily-login.<player.uuid>]>"
        - if !<server.has_flag[daily-login.<player.uuid>]>:
            - announce to_console "Player <player.name> daily login flag did not exist, running "
            - announce to_console "Increasing login count for <player.name>, current count <server.flag[daily-login-count.<player.uuid>]>"
            - flag server daily-login-count.<player.uuid>:++
            - announce to_console "New login count for <player.name> is <server.flag[daily-login-count.<player.uuid>]>"
            - flag player daily-spin-available:1
            - flag server daily-login.<player.uuid>:1
            - announce to_console "Flagged daily spin available and login used, checking if login above 28 - current count for <player.name> is <server.flag[daily-login-count.<player.uuid>]>"
            - if <server.flag[daily-login-count.<player.uuid>]> > 28:
                - announce to_console "Daily login count for <player.name> above 28, setting to 1"
                - flag server daily-login-count.<player.uuid>:1
        - if <player.has_flag[daily-spin-available]>:
            - wait 4s
            - narrate "<&a>Your daily login reward is available, <proc[msgcommand].context[<&b>click here or type /dailylogin|dailylogin|<&a>/dailylogin]><&a> to get it!" targets:<player>
        on system time 19:00:
        - announce to_console "Daily rewards should be resetting"
        - flag server daily-login:!
        - announce "<&a>Daily server rewards have reset and will become available when you next log in!"
        - discord id:sxr message channel:343105813293826059 "<&lt><&at><&amp>223441207341219840<&gt>, daily login rewards have been reset!"

"DailyLogin":
    type: command
    name: dailylogin
    description: Receive your daily login reward, if available.
    usage: /dailylogin
    script:
    - if <player.has_flag[daily-spin-available]>:
        - flag player daily-spin-available:!
        - run daily-login-spinner
        - narrate "<&a>You are on day <&b><server.flag[daily-login-count.<player.uuid>]><&a> of <&b>28<&a> for daily login rewards!"
    - else:
        - narrate "<&c>Sorry, your daily login reward is unavailable!"
        - narrate "<&c>You are on day <&b><server.flag[daily-login-count.<player.uuid>]><&c> of <&b>28<&c> for daily login rewards!"
    - if <server.flag[daily-login-count.<player.uuid>]> >= 28:
        - flag server daily-login-count.<player.uuid>:0

VeteranBox:
    type: item
    debug: false
    material: blue_shulker_box[flags=li@HIDE_ENCHANTS;nbt=li@BonusBox/Veteran]
    display name: "<&9>Veteran Bonus Box"
    lore:
    - "<&6>A bonus box containing powerful gear!"
    enchantments:
    - MENDING:1

EliteBox:
    type: item
    debug: false
    material: pink_shulker_box[flags=li@HIDE_ENCHANTS;nbt=li@BonusBox/Elite]
    display name: "<&d>Elite Bonus Box"
    lore:
    - "<&6>A bonus box containing powerful gear!"
    enchantments:
    - MENDING:1

daily-login-spinner:
    type: task
    debug: true
    speed: 0
    script:
    # Create some cleared lists to work with
    - define daily-display-list li@
    - define daily-roll-list li@
    - define pick li@
    - flag <player> cannot_close_inv:1

    # Create your list of weighted items

    # Days 1-6
    - if <server.flag[daily-login-count.<player.uuid>]> >= 1 && <server.flag[daily-login-count.<player.uuid>]> <= 6:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/4|i@VeteranToken[quantity=32]/160|i@VeteranToken[quantity=64]/40|i@diamond[quantity=16]/20|i@diamond[quantity=8]/40|i@emerald_block[quantity=8]/20|i@emerald[quantity=16]/40

        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    - else if <server.flag[daily-login-count.<player.uuid>]> == 7:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/12|i@VeteranToken[quantity=32]/80|i@VeteranToken[quantity=64]/80|i@diamond[quantity=16]/40|i@diamond[quantity=8]/20|i@emerald_block[quantity=8]/40|i@emerald[quantity=16]/20

        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    - else if <server.flag[daily-login-count.<player.uuid>]> >= 8 && <server.flag[daily-login-count.<player.uuid>]> <= 13:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/8|i@VeteranToken[quantity=32]/150|i@VeteranToken[quantity=64]/50|i@diamond[quantity=32]/20|i@diamond[quantity=16]/40|i@emerald_block[quantity=16]/20|i@emerald[quantity=32]/40
        
        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    - else if <server.flag[daily-login-count.<player.uuid>]> == 14:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/16|i@VeteranToken[quantity=32]/50|i@VeteranToken[quantity=64]/150|i@diamond[quantity=32]/40|i@diamond[quantity=16]/20|i@emerald_block[quantity=16]/40|i@emerald[quantity=32]/20
        
        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>:
    - else if <server.flag[daily-login-count.<player.uuid>]> >= 15 && <server.flag[daily-login-count.<player.uuid>]> <= 20:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/12|i@VeteranToken[quantity=32]/140|i@VeteranToken[quantity=64]/60|i@diamond[quantity=48]/20|i@diamond[quantity=24]/40|i@emerald_block[quantity=24]/20|i@emerald[quantity=48]/40
        
        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    - else if <server.flag[daily-login-count.<player.uuid>]> == 21:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/24|i@VeteranToken[quantity=32]/60|i@VeteranToken[quantity=64]/140|i@diamond[quantity=48]/40|i@diamond[quantity=24]/20|i@emerald_block[quantity=24]/40|i@emerald[quantity=48]/20
        
        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    - else if <server.flag[daily-login-count.<player.uuid>]> >= 22 && <server.flag[daily-login-count.<player.uuid>]> <= 27:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/16|i@VeteranToken[quantity=32]/130|i@VeteranToken[quantity=64]/70|i@diamond[quantity=64]/20|i@diamond[quantity=32]/40|i@emerald_block[quantity=32]/20|i@emerald[quantity=64]/40
        
        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    - else if <server.flag[daily-login-count.<player.uuid>]> == 28:
        # A list of items, with their respective weights.
        - define itemlist li@i@VeteranBox/200|i@EliteBox/50
        
        # Assemble a usable list to take from.
        - foreach <def[itemlist]>:
            - define daily-display-list <def[daily-display-list].pad_left[<def[daily-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    # Pick 60 random items from the weighted list
    - define roll-size "60"
    - define daily-roll-list "<def[daily-display-list].random[60]>"
    - note "in@generic[title=<&6><&l>Daily Login Reward;size=27;contents=li@i@air|i@air|i@air|i@air|i@emerald|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@emerald]" as:daily-spinner.<player.uuid>
    - inventory open "d:in@daily-spinner.<player.uuid>"
    # Roll
    - repeat 50:
        - inventory set d:in@daily-spinner.<player.uuid> o:<def[daily-roll-list].get[<def[value]>].to[<def[value].add[8]>]> slot:10
        - wait <util.e.power[<def[value].mul[0.125].sub[3]>].round_up>t
    - if <player.open_inventory.slot[14].scriptname> == VETERANBOX:
        - flag player cannot_close_inv:!
        - inventory close
        - note remove as:daily-spinner.<player.uuid>
        - run Veteran-Spinner
        - queue clear
    - else if <player.open_inventory.slot[14].scriptname> == ELITEBOX:
        - flag player cannot_close_inv:!
        - inventory close
        - note remove as:daily-spinner.<player.uuid>
        - run Elite-Spinner
        - queue clear
    - else:
        - wait 1s
        - narrate "<&a>You got <&f><def[daily-roll-list].get[54].as_item.display||<def[daily-roll-list].get[54].as_item.formatted.to_titlecase>><&a>!"
        - announce to_console "<player.name> got <def[daily-roll-list].get[54].as_item.display||<def[daily-roll-list].get[54].as_item.formatted.to_titlecase>>"
        - give <def[daily-roll-list].get[54]>
        - note remove as:daily-spinner.<player.uuid>
        - flag player cannot_close_inv:!
        - inventory close

Veteran-Spinner:
    type: task
    debug: true
    speed: 0
    script:
    # Create some cleared lists to work with
    - define veteran-display-list li@
    - define veteran-roll-list li@
    - define pick li@
    - flag player cannot_close_inv:1
    - define itemlist li@i@EliteBox/20|<mythicitem@ImbuedSword.get_item>/20|<mythicitem@ImbuedBow.get_item>/20|<mythicitem@ImbuedShield.get_item>/20|<mythicitem@ImbuedHelm.get_item>/20|<mythicitem@ImbuedChest.get_item>/20|<mythicitem@ImbuedLegs.get_item>/20|<mythicitem@ImbuedBoots.get_item>/20|<mythicitem@ImbuedAxe.get_item>/20|<mythicitem@ImbuedPickaxe.get_item>/20|<mythicitem@ImbuedShovel.get_item>/20|<mythicitem@ImbuedHoe.get_item>/20|<mythicitem@ImbuedFishingRod.get_item>/20
    - foreach <def[itemlist]>:
        - define veteran-display-list <def[veteran-display-list].pad_left[<def[veteran-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    # Pick 60 random items from the weighted list
    - define roll-size "60"
    - define veteran-roll-list "<def[veteran-display-list].random[60]>"
    - note "in@generic[title=<&6><&l>Veteran BONUS ROUND!;size=27;contents=li@i@air|i@air|i@air|i@air|i@emerald|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@emerald]" as:veteran-spinner.<player.uuid>
    - inventory open "d:in@veteran-spinner.<player.uuid>"
    # Roll
    - repeat 50:
        - inventory set d:in@veteran-spinner.<player.uuid> o:<def[veteran-roll-list].get[<def[value]>].to[<def[value].add[8]>]> slot:10
        - wait <util.e.power[<def[value].mul[0.125].sub[3]>].round_up>t
    - if <player.open_inventory.slot[14].scriptname> == ELITEBOX:
        - flag player cannot_close_inv:!
        - note remove as:veteran-spinner.<player.uuid>
        - run Elite-Spinner
    - else:
        - wait 1s
        - narrate "<&a>You got <&f><def[veteran-roll-list].get[54].display||<def[veteran-roll-list].get[54].as_item.formatted.to_titlecase>><&a>!"
        - announce to_console "<player.name> got <def[veteran-roll-list].get[54].display||<def[veteran-roll-list].get[54].as_item.formatted.to_titlecase>>"
        - give <def[veteran-roll-list].get[54]>
        - flag player cannot_close_inv:!
        - note remove as:veteran-spinner.<player.uuid>
        - inventory close

Elite-Spinner:
    type: task
    debug: true
    speed: 0
    script:
    # Create some cleared lists to work with
    - define elite-display-list li@
    - define elite-roll-list li@
    - define pick li@
    - define itemlist li@<mythicitem@BurnishedSword.get_item>/20|<mythicitem@BurnishedBow.get_item>/20|<mythicitem@BurnishedShield.get_item>/20|<mythicitem@BountifulBlade.get_item>/20|<mythicitem@WitheringBlade.get_item>/20|<mythicitem@BurnishedHelm.get_item>/20|<mythicitem@BurnishedChest.get_item>/20|<mythicitem@BurnishedLegs.get_item>/20|<mythicitem@BurnishedBoots.get_item>/20|<mythicitem@BurnishedAxe.get_item>/20|<mythicitem@BurnishedPickaxe.get_item>/20|<mythicitem@BurnishedShovel.get_item>/20|<mythicitem@BurnishedHoe.get_item>/20|<mythicitem@BurnishedFishingRod.get_item>/20
    - foreach <def[itemlist]>:
        - define elite-display-list <def[elite-display-list].pad_left[<def[elite-display-list].size.add[<def[value].after_last[/]>]>].with[<def[value].before_last[/]>]>
    # Pick 60 random items from the weighted list
    - define roll-size "60"
    - define elite-roll-list "<def[elite-display-list].random[60]>"
    - note "in@generic[title=<&6><&l>Elite BONUS ROUND!;size=27;contents=li@i@air|i@air|i@air|i@air|i@emerald|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@emerald]" as:elite-spinner.<player.uuid>
    - inventory open "d:in@elite-spinner.<player.uuid>"
    - flag player cannot_close_inv:1
    # Roll
    - repeat 50:
        - inventory set d:in@elite-spinner.<player.uuid> o:<def[elite-roll-list].get[<def[value]>].to[<def[value].add[8]>]> slot:10
        - wait <util.e.power[<def[value].mul[0.125].sub[3]>].round_up>t

    - wait 1s
    - narrate "<&a>You got <&f><def[elite-roll-list].get[54].display||<def[elite-roll-list].get[54].as_item.formatted.to_titlecase>><&a>!"
    - announce to_console "<player.name> got <def[elite-roll-list].get[54].display||<def[elite-roll-list].get[54].as_item.formatted.to_titlecase>>"
    - give <def[elite-roll-list].get[54]>
    - flag player cannot_close_inv:!
    - note remove as:elite-spinner.<player.uuid>
    - inventory close

"Spinner Anti-Cheat":
    type: world
    debug: false
    events:
        on player clicks in inventory:
        - if <context.inventory.notable_name||null> == daily-spinner.<player.uuid>:
            - determine cancelled
        - else if <context.inventory.notable_name||null> == veteran-spinner.<player.uuid>:
            - determine cancelled
        - else if <context.inventory.notable_name||null> == elite-spinner.<player.uuid>:
            - determine cancelled
        on player drags in inventory:
        - if <context.inventory.notable_name||null> == daily-spinner.<player.uuid>:
            - determine cancelled
        - else if <context.inventory.notable_name||null> == veteran-spinner.<player.uuid>:
            - determine cancelled
        - else if <context.inventory.notable_name||null> == elite-spinner.<player.uuid>:
            - determine cancelled
        on player closes inventory:
        - if <context.inventory.notable_name||null> == daily-spinner.<player.uuid>:
            - if <player.has_flag[cannot_close_inv]>:
                - wait 1t
                - inventory open d:in@daily-spinner.<player.uuid>
                - queue clear
            - flag player cannot_close_inv:!
        - else if <context.inventory.notable_name||null> == veteran-spinner.<player.uuid>:
            - if <player.has_flag[cannot_close_inv]>:
                - wait 1t
                - inventory open d:in@veteran-spinner.<player.uuid>
                - queue clear
            - flag player cannot_close_inv:!
        - else if <context.inventory.notable_name||null> == elite-spinner.<player.uuid>:
            - if <player.has_flag[cannot_close_inv]>:
                - wait 1t
                - inventory open d:in@elite-spinner.<player.uuid>
                - queue clear
            - flag player cannot_close_inv:!