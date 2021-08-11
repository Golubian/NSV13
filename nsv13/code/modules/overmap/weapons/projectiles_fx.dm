/**

Misc projectile types, effects, think of this as the special FX file.

*/

/obj/item/projectile/bullet/pdc_round
	icon_state = "pdc"
	name = "teflon coated tungsten round"
	damage = 40
	flag = "overmap_light"
	spread = 5

/obj/item/projectile/bullet/pdc_round/heavy //do we even use this anymore?
	damage = 10
	flag = "overmap_heavy"
	spread = 5

/obj/item/projectile/bullet/mac_round
	icon_state = "railgun"
	name = "artillery round"
	damage = 400
	speed = 1.85
	//Not easily stopped.
	obj_integrity = 300
	max_integrity = 300
	homing_turn_speed = 2.5
	flag = "overmap_heavy"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/torpedo
	var/homing_benefit_time = 0 SECONDS //NAC shells have a very slight homing effect.

/obj/item/projectile/bullet/mac_round/prehit(atom/target)
	if(isovermap(target))
		var/obj/structure/overmap/OM = target
		var/cache_move_type = movement_type
		if(OM.mass <= MASS_TINY)
			movement_type = FLYING | UNSTOPPABLE //Small things don't stop us.
		else
			movement_type = cache_move_type //But large things do.
	. = ..()

/obj/item/projectile/bullet/mac_round/Initialize()
	. = ..()
	if(homing_benefit_time)
		spawn(0)
			sleep(homing_benefit_time)
			set_homing_target(null)

/obj/item/projectile/bullet/mac_round/ap
	damage = 250
	armour_penetration = 70
	icon_state = "railgun_ap"
	movement_type = FLYING | UNSTOPPABLE //Railguns punch straight through your ship

/obj/item/projectile/bullet/mac_round/magneton
	speed = 1.5
	damage = 325
	homing_benefit_time = 2.5 SECONDS
	homing_turn_speed = 30

//Improvised ammunition, does terrible damage but is cheap to produce
/obj/item/projectile/bullet/mac_round/cannonshot
	name = "cannonball"
	damage = 75
	icon_state = "cannonshot"
	flag = "overmap_medium"

/obj/item/projectile/bullet/railgun_slug
	icon_state = "mac"
	name = "tungsten slug"
	damage = 150
	speed = 1
	homing_turn_speed = 2
	flag = "overmap_heavy"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/torpedo

/obj/item/projectile/bullet/railgun_slug/Initialize()
	. = ..()
	sleep(0.25)
	set_homing_target(null)

/obj/item/projectile/bullet/gauss_slug
	icon_state = "gaussgun"
	name = "tungsten round"
	damage = 40
	obj_integrity = 500 //Flak doesn't shoot this down....
	flag = "overmap_medium"

/obj/item/projectile/bullet/light_cannon_round
	icon_state = "pdc"
	name = "light cannon round"
	damage = 15
	spread = 2
	flag = "overmap_light"

/obj/item/projectile/bullet/heavy_cannon_round
	icon_state = "pdc"
	name = "heavy cannon round"
	damage = 15
	spread = 5
	flag = "overmap_medium"

/obj/item/projectile/guided_munition
	obj_integrity = 50
	max_integrity = 50
	armor = list("overmap_light" = 10, "overmap_medium" = 0, "overmap_heavy" = 0)

/obj/item/projectile/guided_munition/torpedo
	icon_state = "torpedo"
	name = "plasma torpedo"
	speed = 2.75
	valid_angle = 150
	homing_turn_speed = 35
	damage = 240
	obj_integrity = 40
	max_integrity = 40
	range = 250
	armor = list("overmap_light" = 20, "overmap_medium" = 10, "overmap_heavy" = 0)
	flag = "overmap_heavy"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/torpedo
	spread = 5 //Helps them not get insta-bonked when launching

/obj/item/projectile/guided_munition/torpedo/shredder
	icon_state = "torpedo_shredder"
	name = "plasma charge"
	damage = 240
	armour_penetration = 20

/obj/item/projectile/guided_munition/torpedo/decoy
	icon_state = "torpedo"
	damage = 0
	obj_integrity = 200
	max_integrity = 200

/obj/item/projectile/guided_munition/torpedo/nuclear
	icon_state = "torpedo_nuke"
	name = "thermonuclear missile"
	damage = 600
	obj_integrity = 25
	max_integrity = 25
	impact_effect_type = /obj/effect/temp_visual/nuke_impact
	shotdown_effect_type = /obj/effect/temp_visual/nuke_impact

//What you get from an incomplete torpedo.
/obj/item/projectile/guided_munition/torpedo/dud
	icon_state = "torpedo_dud"
	damage = 0
//NSV13 deployable space weapons
/obj/item/deployable
	icon = 'nsv13/icons/obj/munition_types.dmi'
	var/impact_effect_type = /obj/effect/temp_visual/impact_effect/torpedo
	var/damage = 0
	var/faction = null 

//NSV13 deployable space weapons
/obj/item/deployable/proc/check_faction(atom/movable/A)
	var/obj/structure/overmap/OM = A
	if(!istype(OM))
		return TRUE
	if(faction != OM.faction)
		return TRUE
	return FALSE

//NSV13 deployable space mines
/obj/item/deployable/mine
	icon_state = "mine_on"
	name = "Standard mine"
	desc = "A nasty mine."
	damage = 150
	obj_integrity = 10
	max_integrity = 10
	armor = list("overmap_light" = 10, "overmap_medium" = 5, "overmap_heavy" = 0)

/obj/item/deployable/mine/Cross(obj/target)
	. = ..()
	
	if(!check_faction(target))
		target.take_damage(damage)
		new impact_effect_type(src.loc, src.pixel_x, src.pixel_y)
		qdel(src)
		return TRUE

	if(istype(target, /obj/structure/overmap)) //Were we to explode on an actual overmap, this would oneshot the ship as it's a powerful explosion.
		target.take_damage(damage)
		new impact_effect_type(src.loc, src.pixel_x, src.pixel_y)
		qdel(src)
		return TRUE

	var/obj/item/projectile/P = target
	if(isprojectile(P) && P.faction != faction) //Any non-friendly ammo hitting the mine will set it off.
		new impact_effect_type(src.loc, src.pixel_x, src.pixel_y)
		qdel(P)
		qdel(src)
		return TRUE

/obj/item/projectile/guided_munition/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/windup), 1 SECONDS)

/obj/item/projectile/guided_munition/proc/windup()
	valid_angle = 360 //Torpedoes "wind up" to hit their target
	homing_turn_speed *= 5
	homing_turn_speed = CLAMP(homing_turn_speed, 0, 360)
	sleep(0.7 SECONDS) //Let it get clear of the sender.
	valid_angle = initial(valid_angle)
	homing_turn_speed = initial(homing_turn_speed)

/obj/item/projectile/guided_munition/missile
	name = "triton cruise missile"
	icon_state = "conventional_missile"
	speed = 1
	damage = 150
	valid_angle = 120
	homing_turn_speed = 25
	range = 250
	flag = "overmap_medium"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/torpedo
	spread = 5 //Helps them not get insta-bonked when launching

/obj/effect/temp_visual/overmap_explosion
	icon = 'nsv13/goonstation/icons/hugeexplosion.dmi'
	icon_state = "explosion"
	duration = 10

/obj/effect/temp_visual/overmap_explosion/alt
	icon = 'nsv13/goonstation/icons/hugeexplosion2.dmi'
	icon_state = "explosion"
	duration = 10

//Corvid or someone please refactor this to be less messy.
/obj/item/projectile/guided_munition/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!check_faction(target))
		return FALSE 	 //Nsv13 - faction checking for overmaps. We're gonna just cut off real early and save some math if the IFF doesn't check out.
	if(istype(target, /obj/structure/overmap)) //Were we to explode on an actual overmap, this would oneshot the ship as it's a powerful explosion.
		return BULLET_ACT_HIT
	var/obj/item/projectile/P = target //This is hacky, refactor check_faction to unify both of these. I'm bodging it for now.
	if(isprojectile(target) && P.faction != faction && !P.nodamage) //Because we could be in the same faction and collide with another bullet. Let's not blow ourselves up ok?
		if(obj_integrity <= P.damage) //Tank the hit, take some damage
			qdel(P)
			explode()
			return BULLET_ACT_HIT
		else
			qdel(P)
			take_damage(P.damage)
			return FALSE //Didn't take the hit
	if(!isprojectile(target)) //This is lazy as shit but is necessary to prevent explosions triggering on the overmap when two bullets collide. Fix this shit please.
		detonate(target)
	return BULLET_ACT_HIT

/obj/item/projectile/guided_munition/proc/detonate(atom/target)
	explosion(target, 2, 4, 4)
	
/obj/item/projectile/guided_munition/torpedo/nuclear/detonate(atom/target)
		var/obj/structure/overmap/OM = target.get_overmap() //What if I just..........
		OM?.nuclear_impact()
		explosion(target, 3, 6, 8)
