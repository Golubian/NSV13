/obj/item/ship_weapon/ammunition/mine
    name = "Standard Mine"
    icon = 'nsv13/icons/obj/munitions.dmi'
    icon_state = "mine"
    desc = "A standard mine, designed to impair enemy movement."
    density = FALSE
    climbable = FALSE //No shenanigans
    w_class = WEIGHT_CLASS_HUGE //Change this to be smaller?
    move_resist = MOVE_FORCE_VERY_STRONG
    interaction_flags_item = 1 // -INTERACT_ITEM_ATTACK_HAND_PICKUP
    projectile_type = /obj/item/deployable/mine //What torpedo type we fire
    volatility = 1 //Very volatile.
    explode_when_hit = TRUE //Yeah, this can't ever end well for you.

/obj/item/ship_weapon/ammunition/mine/cluster
    name = "Cluster Mine"
    icon = 'nsv13/icons/obj/munitions.dmi'
    icon_state = "mine_cluster"
    desc = "A cluster mine to be used with the mine layer fighter module, this one breaks up into mini mines when deployed."
    density = FALSE
    climbable = FALSE //No shenanigans
    w_class = WEIGHT_CLASS_HUGE //Change this to be smaller?
    move_resist = MOVE_FORCE_VERY_STRONG
    interaction_flags_item = 1 // -INTERACT_ITEM_ATTACK_HAND_PICKUP
    projectile_type = /obj/item/deployable/mine/cluster //What torpedo type we fire
    volatility = 1 //Very volatile.
    explode_when_hit = TRUE //Yeah, this can't ever end well for you.


/obj/item/ship_weapon/ammunition/mine/Initialize()
	. = ..()
	AddComponent(/datum/component/twohanded/required)