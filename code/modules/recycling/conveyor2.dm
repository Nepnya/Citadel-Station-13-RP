#define OFF 0
#define FORWARDS 1
#define BACKWARDS -1

//conveyor2 is pretty much like the original, except it supports corners, but not diverters.
//note that corner pieces transfer stuff clockwise when running forward, and anti-clockwise backwards.

/obj/machinery/conveyor
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor0"
	name = "conveyor belt"
	desc = "A conveyor belt."
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = 1
	circuit = /obj/item/circuitboard/conveyor
	speed_process = TRUE
	/// What we set things to glide size to when they are being moved by us
	var/conveyor_glide_size = 8

	var/operating = OFF	// 1 if running forward, -1 if backwards, 0 if off
	var/operable = 1	// true if can operate (no broken segments in this belt run)
	var/forwards		// this is the default (forward) direction, set by the map dir
	var/backwards		// hopefully self-explanatory
	var/movedir			// the actual direction to move stuff in

	var/list/affecting	// the list of all items that will be moved this ptick
	var/id = ""			// the control ID	- must match controller ID

/obj/machinery/conveyor/centcom_auto
	id = "round_end_belt"

	// create a conveyor
/obj/machinery/conveyor/Initialize(mapload, newdir, on = 0)
	. = ..()
	if(newdir)
		setDir(newdir)

	update_dir()

	if(on)
		operating = FORWARDS
		setmove()

	component_parts = list()
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stack/cable_coil(src,5)
	RefreshParts()

/obj/machinery/conveyor/proc/setmove()
	if(operating == FORWARDS)
		movedir = forwards
	else if(operating == BACKWARDS)
		movedir = backwards
	else
		operating = OFF
	update()

/obj/machinery/conveyor/setDir()
	. =..()
	update_dir()

/obj/machinery/conveyor/Crossed(atom/movable/AM)
	. = ..()
	if(operating)
		AM.set_glide_size(conveyor_glide_size)

/obj/machinery/conveyor/Uncrossed(atom/movable/AM)
	. = ..()
	if(operating)
		AM.reset_glide_size()

/obj/machinery/conveyor/proc/update_dir()
	if(!(dir in GLOB.cardinal)) // Diagonal. Forwards is *away* from dir, curving to the right.
		forwards = turn(dir, 135)
		backwards = turn(dir, 45)
	else
		forwards = dir
		backwards = turn(dir, 180)

/obj/machinery/conveyor/proc/update()
	if(stat & BROKEN)
		icon_state = "conveyor-broken"
		operating = OFF
		return
	if(!operable)
		operating = OFF
	if(stat & NOPOWER)
		operating = OFF
	if(operating)
		for(var/atom/movable/AM in loc)
			AM.set_glide_size(conveyor_glide_size)
	icon_state = "conveyor[operating]"

	// machine process
	// move items to the target location
/obj/machinery/conveyor/process(delta_time)
	if(stat & (BROKEN | NOPOWER))
		return
	if(!operating)
		return
	use_power(10)

	affecting = loc.contents - src		// moved items will be all in loc
	var/items_moved = 0
	for(var/atom/movable/A in affecting)
		if(!A.anchored)
			if(A.loc == src.loc) // prevents the object from being affected if it's not currently here.
				step(A,movedir)
				items_moved++
		if(items_moved >= 10)
			break

// attack with item, place item on conveyor
/obj/machinery/conveyor/attackby(var/obj/item/I, mob/user)
	if(isrobot(user))	return //Carn: fix for borgs dropping their modules on conveyor belts
	if(I.loc != user)	return // This should stop mounted modules ending up outside the module.

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return

	if(istype(I, /obj/item/multitool))
		if(panel_open)
			var/input = sanitize(input(usr, "What id would you like to give this conveyor?", "Multitool-Conveyor interface", id))
			if(!input)
				to_chat(user, "No input found. Please hang up and try your call again.")
				return
			id = input
			for(var/obj/machinery/conveyor_switch/C in machines)
				if(C.id == id)
					C.conveyors |= src
			return

	user.drop_item(get_turf(src))
	return

// attack with hand, move pulled object onto conveyor
/obj/machinery/conveyor/attack_hand(mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()
	return


// make the conveyor broken
// also propagate inoperability to any connected conveyor with the same ID
/obj/machinery/conveyor/proc/broken()
	stat |= BROKEN
	update()

	var/obj/machinery/conveyor/C = locate() in get_step(src, dir)
	if(C)
		C.set_operable(dir, id, 0)

	C = locate() in get_step(src, turn(dir,180))
	if(C)
		C.set_operable(turn(dir,180), id, 0)


//set the operable var if ID matches, propagating in the given direction

/obj/machinery/conveyor/proc/set_operable(stepdir, match_id, op)

	if(id != match_id)
		return
	operable = op

	update()
	var/obj/machinery/conveyor/C = locate() in get_step(src, stepdir)
	if(C)
		C.set_operable(stepdir, id, op)

/obj/machinery/conveyor/power_change()
	..()
	update()

// the conveyor control switch
//
//

/obj/machinery/conveyor_switch

	name = "conveyor switch"
	desc = "A conveyor control switch."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	var/position = 0			// 0 off, -1 reverse, 1 forward
	var/last_pos = -1			// last direction setting
	var/operated = 1			// true if just operated

	var/id = "" 				// must match conveyor IDs to control them

	var/list/conveyors		// the list of converyors that are controlled by this switch
	anchored = 1



/obj/machinery/conveyor_switch/Initialize(mapload)
	..()
	update()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/conveyor_switch/LateInitialize()
	conveyors = list()
	for(var/obj/machinery/conveyor/C in machines)
		if(C.id == id)
			conveyors += C

// update the icon depending on the position

/obj/machinery/conveyor_switch/proc/update()
	if(position<0)
		icon_state = "switch-rev"
	else if(position>0)
		icon_state = "switch-fwd"
	else
		icon_state = "switch-off"


// timed process
// if the switch changed, update the linked conveyors

/obj/machinery/conveyor_switch/process(delta_time)
	if(!operated)
		return
	operated = 0

	for(var/obj/machinery/conveyor/C in conveyors)
		C.operating = position
		C.setmove()

// attack with hand, switch position
/obj/machinery/conveyor_switch/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	if(position == 0)
		if(last_pos < 0)
			position = 1
			last_pos = 0
		else
			position = -1
			last_pos = 0
	else
		last_pos = position
		position = 0

	operated = 1
	update()

	// find any switches with same id as this one, and set their positions to match us
	for(var/obj/machinery/conveyor_switch/S in machines)
		if(S.id == src.id)
			S.position = position
			S.update()

/obj/machinery/conveyor_switch/attackby(var/obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return

	if(istype(I, /obj/item/weldingtool))
		if(panel_open)
			var/obj/item/weldingtool/WT = I
			if(!WT.remove_fuel(0, user))
				to_chat(user, "The welding tool must be on to complete this task.")
				return
			playsound(src, WT.usesound, 50, 1)
			if(do_after(user, 20 * WT.toolspeed))
				if(!src || !WT.isOn()) return
				to_chat(user, "<span class='notice'>You deconstruct the frame.</span>")
				new /obj/item/stack/material/steel( src.loc, 2 )
				qdel(src)
				return

	if(istype(I, /obj/item/multitool))
		if(panel_open)
			var/input = sanitize(input(usr, "What id would you like to give this conveyor switch?", "Multitool-Conveyor interface", id))
			if(!input)
				to_chat(user, "No input found. Please hang up and try your call again.")
				return
			id = input
			conveyors = list() // Clear list so they aren't double added.
			for(var/obj/machinery/conveyor/C in machines)
				if(C.id == id)
					conveyors += C
			return

/obj/machinery/conveyor_switch/oneway
	var/convdir = 1 //Set to 1 or -1 depending on which way you want the convayor to go. (In other words keep at 1 and set the proper dir on the belts.)
	desc = "A conveyor control switch. It appears to only go in one direction."

// attack with hand, switch position
/obj/machinery/conveyor_switch/oneway/attack_hand(mob/user)
	if(position == 0)
		position = convdir
	else
		position = 0

	operated = 1
	update()

	// find any switches with same id as this one, and set their positions to match us
	for(var/obj/machinery/conveyor_switch/S in machines)
		if(S.id == src.id)
			S.position = position
			S.update()
