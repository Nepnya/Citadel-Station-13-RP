//Meant for simple animals to drop lootable human bodies.

//If someone can do this in a neater way, be my guest-Kor

//This has to be seperate from the Away Mission corpses, because New() doesn't work for those, and initialize() doesn't work for these.

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).


/obj/effect/landmark/mobcorpse
	name = "Unknown"
	var/mobname = "Unknown"  //Unused now but it'd fuck up maps to remove it now
	var/corpseuniform = null //Set this to an object path to have the slot filled with said object on the corpse.
	var/corpsesuit = null
	var/corpseshoes = null
	var/corpsegloves = null
	var/corpseradio = null
	var/corpseglasses = null
	var/corpsemask = null
	var/corpsehelmet = null
	var/corpsebelt = null
	var/corpsepocket1 = null
	var/corpsepocket2 = null
	var/corpseback = null
	var/corpseid = 0     //Just set to 1 if you want them to have an ID
	var/corpseidjob = null // Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	var/corpseidaccess = null //This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	var/corpseidicon = null //For setting it to be a gold, silver, CentCom etc ID

/obj/effect/landmark/mobcorpse/Initialize(mapload)
	createCorpse()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/mobcorpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	M.real_name = src.name
	M.stat = 2 //Kills the new mob
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), slot_wear_suit)
	if(src.corpseshoes)
		M.equip_to_slot_or_del(new src.corpseshoes(M), slot_shoes)
	if(src.corpsegloves)
		M.equip_to_slot_or_del(new src.corpsegloves(M), slot_gloves)
	if(src.corpseradio)
		M.equip_to_slot_or_del(new src.corpseradio(M), slot_l_ear)
	if(src.corpseglasses)
		M.equip_to_slot_or_del(new src.corpseglasses(M), slot_glasses)
	if(src.corpsemask)
		M.equip_to_slot_or_del(new src.corpsemask(M), slot_wear_mask)
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), slot_head)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), slot_belt)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), slot_r_store)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), slot_l_store)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), slot_back)
	if(src.corpseid == 1)
		var/obj/item/card/id/W = new(M)
		W.name = "[M.real_name]'s ID Card"
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == corpseidaccess)
				jobdatum = J
				break
		if(src.corpseidicon)
			W.icon_state = corpseidicon
		if(src.corpseidaccess)
			if(jobdatum)
				W.access = jobdatum.get_access()
			else
				W.access = list()
		if(corpseidjob)
			W.assignment = corpseidjob
		W.registered_name = M.real_name
		M.equip_to_slot_or_del(W, slot_wear_id)

//List of different corpse types

/obj/effect/landmark/mobcorpse/syndicatesoldier
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"

/obj/effect/landmark/mobcorpse/solarpeacekeeper
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/blue/sol
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Peacekeeper"
	corpseidaccess = "Syndicate"

/obj/effect/landmark/mobcorpse/syndicatecommando
	name = "Syndicate Commando"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/space/void/merc
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/syndicate
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/merc
	corpseback = /obj/item/tank/jetpack/oxygen
	corpsepocket1 = /obj/item/tank/emergency/oxygen
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"



/obj/effect/landmark/mobcorpse/clown
	name = "Clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Clown"
	corpseidaccess = "Clown"



/obj/effect/landmark/mobcorpse/pirate
	name = "Pirate"
	corpseuniform = /obj/item/clothing/under/pirate
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsehelmet = /obj/item/clothing/head/bandana



/obj/effect/landmark/mobcorpse/pirate/ranged
	name = "Pirate Gunner"
	corpsesuit = /obj/item/clothing/suit/pirate
	corpsehelmet = /obj/item/clothing/head/pirate



/obj/effect/landmark/mobcorpse/russian
	name = "Russian"
	corpseuniform = /obj/item/clothing/under/soviet
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsehelmet = /obj/item/clothing/head/bearpelt

/obj/effect/landmark/mobcorpse/russian/ranged
	corpsehelmet = /obj/item/clothing/head/ushanka

//Diorama Corpses
/obj/effect/landmark/mobcorpse/shogun
	name = "Shogun's Bodyguard"
	corpseuniform = /obj/item/clothing/under/color/black
	corpsesuit = /obj/item/clothing/suit/kamishimo
	corpseshoes = /obj/item/clothing/shoes/sandal
	corpsehelmet = /obj/item/clothing/head/rice

/obj/effect/landmark/mobcorpse/safari
	name = "Colonial Adventurer"
	corpseuniform = /obj/item/clothing/under/safari
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsehelmet = /obj/item/clothing/head/pith

//////////////////////////
//		Vox Bodies
//////////////////////////

/obj/effect/landmark/mobcorpse/vox
	name = "vox"
	corpseid = 0

/obj/effect/landmark/mobcorpse/vox/Initialize()
	. = ..()
	createvoxCorpse()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/mobcorpse/vox/proc/createvoxCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/vox/M = new /mob/living/carbon/human/vox (src.loc)
	M.real_name = src.name
	M.stat = 2 //Kills the new mob
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), slot_wear_suit)
	if(src.corpseshoes)
		M.equip_to_slot_or_del(new src.corpseshoes(M), slot_shoes)
	if(src.corpsegloves)
		M.equip_to_slot_or_del(new src.corpsegloves(M), slot_gloves)
	if(src.corpseradio)
		M.equip_to_slot_or_del(new src.corpseradio(M), slot_l_ear)
	if(src.corpseglasses)
		M.equip_to_slot_or_del(new src.corpseglasses(M), slot_glasses)
	if(src.corpsemask)
		M.equip_to_slot_or_del(new src.corpsemask(M), slot_wear_mask)
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), slot_head)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), slot_belt)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), slot_r_store)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), slot_l_store)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), slot_back)
	if(src.corpseid == 1)
		var/obj/item/card/id/W = new(M)
		W.name = "[M.real_name]'s ID Card"
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == corpseidaccess)
				jobdatum = J
				break
		if(src.corpseidicon)
			W.icon_state = corpseidicon
		if(src.corpseidaccess)
			if(jobdatum)
				W.access = jobdatum.get_access()
			else
				W.access = list()
		if(corpseidjob)
			W.assignment = corpseidjob
		W.registered_name = M.real_name
		M.equip_to_slot_or_del(W, slot_wear_id)

//Types of Vox corpses:

/obj/effect/landmark/mobcorpse/vox/pirate
	name = "vox pirate"
	corpseuniform = /obj/item/clothing/under/color/black
	corpsesuit = /obj/item/clothing/suit/armor/vox_scrap
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsegloves = /obj/item/clothing/gloves/light_brown
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/obj/effect/landmark/mobcorpse/vox/boarder_m
	name = "vox melee boarder"
	corpseuniform = /obj/item/clothing/under/vox/vox_casual
	corpsesuit = /obj/item/clothing/suit/armor/vox_scrap
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsegloves = /obj/item/clothing/gloves/light_brown
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/obj/effect/landmark/mobcorpse/vox/boarder_r
	name = "vox ranged boarder"
	corpseuniform = /obj/item/clothing/under/rank/bartender
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/obj/effect/landmark/mobcorpse/vox/boarder_t
	name = "vox salvage technician"
	corpseuniform = /obj/item/clothing/under/rank/bartender
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/obj/effect/landmark/mobcorpse/vox/suppressor
	name = "vox suppressor"
	corpseuniform = /obj/item/clothing/under/color/red
	corpsesuit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	corpseshoes = /obj/item/clothing/shoes/orange
	corpsegloves = /obj/item/clothing/gloves/red
	corpsemask = /obj/item/clothing/mask/gas/half
	corpseid = 0

/obj/effect/landmark/mobcorpse/vox/captain
	name = "vox captain"
	corpseuniform = /obj/item/clothing/under/color/black
	corpsesuit = /obj/item/clothing/suit/space/vox/carapace
	corpseshoes = /obj/item/clothing/shoes/magboots/vox
	corpsegloves = /obj/item/clothing/gloves/light_brown
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/riot
	corpseid = 0

/obj/effect/landmark/mobcorpse/syndicatecommando
	name = "Mercenary Commando"
