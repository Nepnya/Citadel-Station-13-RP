/obj/mecha/combat/gygax
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	name = "Gygax"
	icon_state = "gygax"
	initial_icon = "gygax"
	step_in = 3
	dir_in = 1 //Facing North.
	health = 300
	maxhealth = 300
	deflect_chance = 15
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1)
	max_temperature = 25000
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/gygax
	internal_damage_threshold = 35
	max_equip = 3

	max_hull_equip = 1
	max_weapon_equip = 2
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	overload_possible = 1

//Not quite sure how to move those yet.
/obj/mecha/combat/gygax/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_leg_overload=1'>Toggle leg actuators overload</a>
						</div>
						</div>
						"}
	output += ..()
	return output


/obj/mecha/combat/gygax/dark
	desc = "A lightweight exosuit used by Heavy Asset Protection. A significantly upgraded Gygax security mech."
	name = "Dark Gygax"
	icon_state = "darkgygax"
	initial_icon = "darkgygax"
	health = 400
	maxhealth = 400
	deflect_chance = 25
	damage_absorption = list("brute"=0.6,"fire"=0.8,"bullet"=0.6,"laser"=0.5,"energy"=0.65,"bomb"=0.8)
	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/dark
	max_equip = 4
	step_energy_drain = 5
	mech_faction = MECH_FACTION_SYNDI

	max_hull_equip = 1
	max_weapon_equip = 2
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 2

/obj/mecha/combat/gygax/dark/Initialize(mapload)
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/teleporter
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)
	return

/obj/mecha/combat/gygax/dark/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000

/obj/mecha/combat/gygax/serenity
	desc = "A lightweight exosuit made from a modified Gygax chassis combined with proprietary VeyMed medical tech. It's faster and sturdier than most medical mechs, but much of the armor plating has been stripped out, leaving it more vulnerable than a regular Gygax."
	name = "Serenity"
	icon_state = "medgax"
	initial_icon = "medgax"
	health = 150
	maxhealth = 150
	deflect_chance = 20
	step_in = 2
	damage_absorption = list("brute"=0.9,"fire"=1,"bullet"=0.9,"laser"=0.8,"energy"=0.9,"bomb"=1)
	max_temperature = 20000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/serenity
	max_equip = 3
	step_energy_drain = 8
	cargo_capacity = 2
	max_hull_equip = 1
	max_weapon_equip = 1
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	var/obj/item/clothing/glasses/hud/health/mech/hud

/obj/mecha/combat/gygax/serenity/Initialize(mapload)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health/mech(src)

/obj/mecha/combat/gygax/serenity/moved_inside(var/mob/living/carbon/human/H as mob)
	if(..())
		if(H.glasses)
			occupant_message("<font color='red'>[H.glasses] prevent you from using [src] [hud]</font>")
		else
			H.glasses = hud
			H.recalculate_vis()
		return 1
	else
		return 0

/obj/mecha/combat/gygax/serenity/go_out()
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		if(H.glasses == hud)
			H.glasses = null
			H.recalculate_vis()
	..()
	return
