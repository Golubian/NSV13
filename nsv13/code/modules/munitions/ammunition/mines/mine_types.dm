/obj/item/ship_weapon/ammunition/mine
    name = "Standard Mine"
    icon = 'nsv13/icons/obj/munition_types.dmi'
    icon_state = "mine"
    desc = "A standard mine, designed to impair enemy movement."
    density = FALSE
    climbable = FALSE //No shenanigans
    w_class = WEIGHT_CLASS_HUGE //Change this to be smaller?
    move_resist = MOVE_FORCE_VERY_STRONG
    interaction_flags_item = 1 // -INTERACT_ITEM_ATTACK_HAND_PICKUP
    projectile_type = /obj/item/deployable/mine //What torpedo type we fire
    pixel_x = -17
    volatility = 1 //Very volatile.
    explode_when_hit = TRUE //Yeah, this can't ever end well for you.