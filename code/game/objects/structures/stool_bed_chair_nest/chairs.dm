/obj/structure/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/furniture_vr.dmi' //VOREStation Edit - Using Eris furniture
	icon_state = "chair_preview"
	color = "#666666"
	base_icon = "chair"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/bed/chair/LateInitialize()
	. = ..()
	update_layer()

/obj/structure/bed/chair/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(!padding_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, "<span class='notice'>\The [SK] is not ready to be attached!</span>")
			return
		user.drop_item()
		var/obj/structure/bed/chair/e_chair/E = new (src.loc, material.name)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.setDir(dir)
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)

/obj/structure/bed/chair/attack_tk(mob/user as mob)
	if(has_buckled_mobs())
		..()
	else
		rotate_clockwise()
	return

/obj/structure/bed/chair/post_buckle_mob()
	update_icon()

/obj/structure/bed/chair/update_icon()
	..()
	if(has_buckled_mobs() && padding_material)
		var/cache_key = "[base_icon]-armrest-[padding_material.name]"
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.layer = MOB_LAYER + 0.1
			I.plane = MOB_PLANE
			I.color = padding_material.icon_colour
			stool_cache[cache_key] = I
		overlays |= stool_cache[cache_key]

/obj/structure/bed/chair/proc/update_layer()
	if(src.dir == NORTH)
		plane = MOB_PLANE
		layer = MOB_LAYER + 0.1
	else
		reset_plane_and_layer()

/obj/structure/bed/chair/setDir()
	..()
	update_layer()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.setDir(dir)

/obj/structure/bed/chair/verb/rotate_clockwise()
	set name = "Rotate Chair Clockwise"
	set category = "Object"
	set src in oview(1)

	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(ismouse(usr) || (isobserver(usr) && !config_legacy.ghost_interaction))
		return

	src.setDir(turn(src.dir, 270))

/obj/structure/bed/chair/shuttle
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "shuttle_chair"
	color = null
	base_icon = "shuttle_chair"
	applies_material_colour = 0

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"

/obj/structure/bed/chair/comfy/brown/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "leather")

/obj/structure/bed/chair/comfy/red/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "carpet")

/obj/structure/bed/chair/comfy/teal/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "teal")

/obj/structure/bed/chair/comfy/black/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "black")

/obj/structure/bed/chair/comfy/green/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "green")

/obj/structure/bed/chair/comfy/purp/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "purple")

/obj/structure/bed/chair/comfy/blue/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "blue")

/obj/structure/bed/chair/comfy/beige/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "beige")

/obj/structure/bed/chair/comfy/lime/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "lime")

/obj/structure/bed/chair/office
	anchored = 0
	buckle_movable = 1

/obj/structure/bed/chair/office/update_icon()
	return

/obj/structure/bed/chair/office/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.is_wirecutter())
		return
	..()

/obj/structure/bed/chair/office/Move()
	..()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/occupant = A
			occupant.buckled = null
			occupant.Move(src.loc)
			occupant.buckled = src
			if (occupant && (src.loc != occupant.loc))
				if (propelled)
					for (var/mob/O in src.loc)
						if (O != occupant)
							Bump(O)
				else
					unbuckle_mob()

/obj/structure/bed/chair/office/Bump(atom/A)
	..()
	if(!has_buckled_mobs())	return

	if(propelled)
		for(var/a in buckled_mobs)
			var/mob/living/occupant = unbuckle_mob(a)

			var/def_zone = ran_zone()
			var/blocked = occupant.run_armor_check(def_zone, "melee")
			var/soaked = occupant.get_armor_soak(def_zone, "melee")
			occupant.throw_at(A, 3, propelled)
			occupant.apply_effect(6, STUN, blocked)
			occupant.apply_effect(6, WEAKEN, blocked)
			occupant.apply_effect(6, STUTTER, blocked)
			occupant.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
			if(istype(A, /mob/living))
				var/mob/living/victim = A
				def_zone = ran_zone()
				blocked = victim.run_armor_check(def_zone, "melee")
				soaked = victim.get_armor_soak(def_zone, "melee")
				victim.apply_effect(6, STUN, blocked)
				victim.apply_effect(6, WEAKEN, blocked)
				victim.apply_effect(6, STUTTER, blocked)
				victim.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"

// Chair types
/obj/structure/bed/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"

/obj/structure/bed/chair/wood/update_icon()
	return

/obj/structure/bed/chair/wood/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.is_wirecutter())
		return
	..()

/obj/structure/bed/chair/wood/Initialize(mapload, material_key)
	..(mapload, "wood")

/obj/structure/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
