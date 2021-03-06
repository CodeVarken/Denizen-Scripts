LeatherArmorCompletion:
    type: task
    debug: false
    script:
    - zap FindReinwaldOffer s@QuestMasterInteract

LeatherArmorQuestCraftingHandler:
    type: world
    debug: false
    events:
        on player crafts leather_*:
        - define data <player.uuid>_quest_data
        - define quest_internalname:LeatherArmor
        - define stage:1
        - if <yaml[<[data]>].contains[quests.active.LeatherArmor].not>:
            - stop
        - choose <context.item.material.name>:
            - case leather_helmet:
                - define objective:1
                - if <yaml[<[data]>].read[quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                    - narrate "<green>You crafted a leather helmet!"
                    - yaml id:<[data]> set quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress:1
                    - run QuestStageProgressHandler def:LeatherArmor|<[objective]>
            - case leather_chestplate:
                - define objective:2
                - if <yaml[<[data]>].read[quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                    - narrate "<green>You crafted a leather chesplate!"
                    - yaml id:<[data]> set quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress:1
                    - run QuestStageProgressHandler def:LeatherArmor|<[objective]>
            - case leather_leggings:
                - define objective:3
                - if <yaml[<[data]>].read[quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                    - narrate "<green>You crafted some leather leggings!"
                    - yaml id:<[data]> set quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress:1
                    - run QuestStageProgressHandler def:LeatherArmor|<[objective]>
            - case leather_boots:
                - define objective:4
                - if <yaml[<[data]>].read[quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                    - narrate "<green>You crafted some leather boots!"
                    - yaml id:<[data]> set quests.active.LeatherArmor.stages.<[stage]>.objectives.<[objective]>.progress:1
                    - run QuestStageProgressHandler def:LeatherArmor|<[objective]>

LeatherArmorQuestDeliveryHandler:
    type: task
    debug: false
    script:
    - define stage:2
    - define quest_internalname:LeatherArmor
    - choose <player.item_in_hand.material.name>:
        - case leather_helmet:
            - define objective:1
            - if <yaml[<[data]>].read[quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                - take leather_helmet
                - narrate format:QuestMasterFormat "A leather helmet! Gotta keep that noggin safe."
                - yaml id:<[data]> set quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress:1
                - run QuestStageProgressHandler def:<[quest_internalname]>|<[objective]>
        - case leather_chestplate:
            - define objective:2
            - if <yaml[<[data]>].read[quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                - take leather_chestplate
                - narrate format:QuestMasterFormat "A leather chestplate! Chestplates offer the greatest armor value of any single piece of armor."
                - yaml id:<[data]> set quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress:1
                - run QuestStageProgressHandler def:<[quest_internalname]>|<[objective]>
        - case leather_leggings:
            - if <yaml[<[data]>].read[quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                - take leather_leggings
                - narrate format:QuestMasterFormat "Leather leggings! They look like they'll fit you just right."
                - yaml id:<[data]> set quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress:1
                - run QuestStageProgressHandler def:<[quest_internalname]>|<[objective]>
        - case leather_boots:
            - if <yaml[<[data]>].read[quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress]> == 0:
                - take leather_boots
                - narrate format:QuestMasterFormat "Leather boots! They won't help you run any faster, but you'll be glad you have them."
                - yaml id:<[data]> set quests.active.<[quest_internalname]>.stages.<[stage]>.objectives.<[objective]>.progress:1
                - run QuestStageProgressHandler def:<[quest_internalname]>|<[objective]>
        - case default:
            - narrate format:QuestMasterFormat "Bring me that leather armor!"
            - run QuestProgressHandler def:<[quest_internalname]>