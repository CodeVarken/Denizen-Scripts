config:
    availability:
        offering_npc: 23
    reset:
        period: 1d
        time: "19:00"
    rewards:
        money: 50
        quest_points: 1
messages:
    offer: "<gray>Wil Wheaton<white>: Please bring me 5 stacks of wheat today so we can feed the people of Dawn's Landing."
    completion: "<gray>Wil Wheaton<white>: Wow, thank you so much for your generosity! Time to get baking."
player_data:
    DailyGathering_Wheat:
        name: Wheat for the wanting (Daily)
        description: "Wil Wheaton needs wheat for the people of Dawn's Landing!"
        stages:
            1:
                description: "Bring wheat to Wil Wheaton in the Questing Hall."
                objectives:
                    1:
                        name: "Deliver 320 wheat"
                        progress: 0
                        total: 320