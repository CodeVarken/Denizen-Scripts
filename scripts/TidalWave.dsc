WaveShooter:
    type: task
    definitions: caster
    speed: 0
    script:
    - define source <def[caster].location.with_pitch[0]>
    - define forward <def[source].direction.vector>
    - define offset <def[forward].rotate_around_y[<util.pi.div[2]>].div[2]>
    - define source_position <def[caster].location>
    - define wave_width 5
    - define wave_total <def[wave_width].mul[2]>
    - define origin_list li@
    - define speed 1
    - define wave_length 30
    # origin repeat
    - repeat <def[wave_total]>:
        - define total_offset <def[offset].mul[<def[value].sub[0.5]>]>
        - define origin_list <def[origin_list].include[<def[source].add[<def[total_offset]>]>]>
        - define origin_list <def[origin_list].include[<def[source].sub[<def[total_offset]>]>]>
    # shooting repeat
    - repeat <def[wave_length]>:
        - define total_forward <def[forward].mul[<def[value]>].mul[<def[speed]>]>
        - foreach <def[origin_list]>:
            - shoot falling_block,concrete,11[fallingblock_drop_item=false] origin:<def[value].add[<def[total_forward]>]> speed:<def[speed]> save:Wave
            - foreach <entry[Wave].shot_entities>:
                - yaml id:WaveManager set <def[value].uuid>:RemoveOnLand
        - wait 1t
WaveFlagManager:
    type: world
    events:
        on server start:
        - yaml create id:WaveManager
RemoveWater:
    type: world
    events:
        on falling_block changes block:
        - if <yaml[WaveManager].read[<context.entity.uuid>]> == RemoveOnLand:
            - determine cancelled
        #- narrate "context.entity.uuid is <context.entity.uuid>" targets:<server.match_player[Wahrheit]>
        #- narrate "context.old_material is <context.old_material>" targets:<server.match_player[Wahrheit]>
        #- narrate "context.new_material is <context.new_material>" targets:<server.match_player[Wahrheit]>