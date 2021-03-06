config:
    availability:
        offering_npc: 193
    requirements:
        quests_completed:
        - "UnlockBlink"
        permissions:
        - magicspells.learn.shadowstun
    rewards:
        money: 100
        quest_points: 3
    material: ender_pearl
messages:
    offer: "<darkgreen>Magnificent Mage<white>: The Shadow Stun spell allows you to briefly stun your foe and teleport behind them. When you're ready to learn it, bring me what I need so that I can teach you."
    completion: "<darkgreen>Magnificent Mage<white>: Congratulations, you're ready to learn Shadow Stun! Give it a try with <&dq>/cast shadowstun.<&dq>"
player_data:
    UnlockShadowStun:
        name: Learn the Shadow Stun spell
        description: "Bring reagents to the Magnificent Mage and learn the Shadow Stun spell!"
        stages:
            1:
                description: "Bring magical reagents to the Magnificent Mage."
                objectives:
                    1:
                        name: "Deliver redstone"
                        progress: 0
                        total: 1024
                    2:
                        name: "Deliver ender pearls"
                        progress: 0
                        total: 512
                    3:
                        name: "Deliver fermented spider eyes"
                        progress: 0
                        total: 2048
                    4:
                        name: "Deliver string"
                        progress: 0
                        total: 2048
                    5:
                        name: "Deliver gold ingots"
                        progress: 0
                        total: 512
            2:
                description: "Bring crystallized experience to the Magnificent Mage."
                objectives:
                    1:
                        name: "Deliver a bloom of crystallized experience"
                        progress: 0
                        total: 1