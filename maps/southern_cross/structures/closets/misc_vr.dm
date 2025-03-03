/obj/structure/closet/secure_closet/explorer
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secureexp1"
	icon_closed = "secureexp"
	icon_locked = "secureexp1"
	icon_opened = "secureexpopen"
	icon_broken = "secureexpbroken"
	icon_off = "secureexpoff"

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/explorer,
		/obj/item/flashlight,
		/obj/item/gps/explorer,
		/obj/item/storage/box/flare,
		/obj/item/geiger,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/material/knife/machete,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/reagent_containers/food/snacks/liquidprotein,
		/obj/item/cataloguer)

/obj/structure/closet/secure_closet/sar
	name = "field medic locker"

	starts_with = list(
		/obj/item/storage/backpack/dufflebag/emt,
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/reagent_containers/glass/bottle/antitoxin,
		/obj/item/storage/belt/medical/emt,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/gun/energy/frontier/locked/holdout,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer/medic,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/radio/headset/sar,
		/obj/item/cartridge/medical,
		/obj/item/material/knife/machete,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/flashlight,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/healthanalyzer,
		/obj/item/radio/off,
		/obj/random/medical,
		/obj/item/reagent_containers/food/snacks/liquidfood = 2,
		/obj/item/reagent_containers/food/snacks/liquidprotein = 2,
		/obj/item/tool/crowbar,
		/obj/item/extinguisher/mini,
		/obj/item/storage/box/freezer,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/barrier_tape_roll/medical,
		/obj/item/gps/medical,
		/obj/item/geiger,
		/obj/item/bodybag/cryobag,
		/obj/item/cataloguer/compact)

/obj/structure/closet/secure_closet/pilot
	starts_with = list(
		/obj/item/storage/backpack/parachute,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/gun/energy/frontier/locked/holdout,
		/obj/item/clothing/head/pilot,
		/obj/item/clothing/under/rank/pilot1,
		/obj/item/clothing/suit/storage/toggle/bomber/pilot,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/radio/headset/pilot/alt,
		/obj/item/flashlight,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/reagent_containers/food/snacks/liquidprotein,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle,
		/obj/item/storage/box/flare,
		/obj/item/gun/projectile/shotgun/flare/explo,
		/obj/item/storage/box/flashshells,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/gps/explorer,
		/obj/item/cataloguer/compact)

/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder locker"
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secureexp1"
	icon_closed = "secureexp"
	icon_locked = "secureexp1"
	icon_opened = "secureexpopen"
	icon_broken = "secureexpbroken"
	icon_off = "secureexpoff"
	req_access = list(access_gateway)

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/explorer,
		/obj/item/flashlight,
		/obj/item/gps/explorer,
		/obj/item/storage/belt/explorer,
		/obj/item/storage/box/flare,
		/obj/item/storage/box/explorerkeys,
		/obj/item/geiger,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/subspaceradio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/material/knife/machete/deluxe,
		/obj/item/gun/energy/frontier/locked/carbine,
		/obj/item/gun/projectile/caseless/usmc,
		/obj/item/ammo_magazine/m10x24mm/small/snark,
		/obj/item/ammo_magazine/m10x24mm/small/hp/snark,
		/obj/item/ammo_magazine/m10x24mm/small/ap/snark,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/reagent_containers/food/snacks/liquidprotein,
		/obj/item/cataloguer/compact/pathfinder)

/obj/structure/closet/secure_closet/pathfinder/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	return ..()
