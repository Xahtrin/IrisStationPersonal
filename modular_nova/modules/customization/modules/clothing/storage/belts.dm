/obj/item/storage/belt/crusader	//Belt + sheath combination - still only holds one sword at a time though
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	name = "crusader belt"
	desc = "Holds an assortment of equipment for whatever situation an adventurer may encounter, as well as having an attached sheath."
	icon_state = "crusader_belt"
	worn_icon_state = "crusader_belt"
	inhand_icon_state = "utility"
	w_class = WEIGHT_CLASS_BULKY //Cant fit a sheath in your bag
	interaction_flags_click = NEED_DEXTERITY
	storage_type = /datum/storage/belt/crusader

/datum/storage/belt/crusader
	max_slots = 2
	max_specific_storage = WEIGHT_CLASS_BULKY
	allow_big_nesting = TRUE

/datum/storage/belt/crusader/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(
		can_hold_list = list(
			/obj/item/storage/belt/storage_pouch,
			/obj/item/forging/reagent_weapon/sword,
			/obj/item/forging/reagent_weapon/katana,
			/obj/item/forging/reagent_weapon/bokken,
			/obj/item/forging/reagent_weapon/dagger,
			/obj/item/melee/sabre,
			/obj/item/claymore,
			/obj/item/melee/cleric_mace,
			/obj/item/knife,
			/obj/item/melee/baton,
			/obj/item/nullrod,	//holds any subset of nullrod in the sheath-storage - - -
		),
		cant_hold_list = list(
			/obj/item/nullrod/armblade,
			/obj/item/nullrod/carp,
			/obj/item/nullrod/chainsaw,
			/obj/item/nullrod/bostaff,
			/obj/item/nullrod/hammer,
			/obj/item/nullrod/pitchfork,
			/obj/item/nullrod/pride_hammer,
			/obj/item/nullrod/spear,
			/obj/item/nullrod/staff,
			/obj/item/nullrod/fedora,
			/obj/item/nullrod/godhand,
			/obj/item/nullrod/staff,
			/obj/item/nullrod/whip,
		)
	)

/obj/item/storage/belt/crusader/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

//Overrides normal dumping code to instead dump from the pouch item inside
/datum/storage/belt/crusader/dump_content_at(atom/dest_object, dump_loc, mob/user)
	var/atom/used_belt = parent
	if(!used_belt)
		return
	var/obj/item/storage/belt/storage_pouch/pouch = locate() in real_location
	if(!pouch)
		pouch.balloon_alert(user, "no pouch!")
		return //oopsie!! If we don't have a pouch! You're fucked!
	if(locked)
		pouch.balloon_alert(user, "locked!")
		return
	pouch.atom_storage.dump_content_at(dest_object, user = user)

/obj/item/storage/belt/crusader/item_ctrl_click(mob/user)	//Makes ctrl-click also open the inventory, so that you can open it with full hands without dropping the sword
	. = ..()
	atom_storage.show_contents(user)
	return CLICK_ACTION_SUCCESS

/obj/item/storage/belt/crusader/click_alt(mob/user)	//This is basically the same as the normal sheath, but because there's always an item locked in the first slot it uses the second slot for swords
	if(contents.len == 2)
		var/obj/item/drawn_item = contents[2]
		add_fingerprint(user)
		playsound(src, 'sound/items/unsheath.ogg', 50, TRUE, -5)
		if(!user.put_in_hands(drawn_item))
			to_chat(user, span_notice("You fumble for [drawn_item] and it falls on the floor."))
			update_appearance()
			return CLICK_ACTION_SUCCESS
		user.visible_message(span_notice("[user] takes [drawn_item] out of [src]."), span_notice("You take [drawn_item] out of [src]."))
		update_appearance()
	else
		to_chat(user, span_warning("[src] is empty!"))
	return CLICK_ACTION_SUCCESS

/obj/item/storage/belt/crusader/update_icon(updates)
	if(contents.len == 2)	//Checks for a sword/rod in the sheath slot, changes the sprite accordingly
		icon_state = "crusader_belt_sheathed"
		worn_icon_state = "crusader_belt_sheathed"
	else
		icon_state = "crusader_belt"
		worn_icon_state = "crusader_belt"
	. = ..()

/obj/item/storage/belt/crusader/examine(mob/user)
	. = ..()
	.+= span_notice("Ctrl-click it to easily open its inventory.")
	if(contents.len == 2)	//If there's no sword/rod in the sheath slot it doesnt display the alt-click instruction
		. += span_notice("Alt-click it to quickly draw the blade.")
		return


/obj/item/storage/belt/crusader/PopulateContents()
	. = ..()
	new /obj/item/storage/belt/storage_pouch(src)

/obj/item/storage/belt/storage_pouch	//seperate mini-storage inside the belt, leaving room for only one sword. Inspired by a (very poorly implemented) belt on Desert Rose
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	name = "storage pouch"
	desc = span_notice("Click on this to open your belt's inventory!")
	icon_state = "storage_pouch_icon"
	worn_icon_state = "storage_pouch_icon"
	w_class = WEIGHT_CLASS_BULKY //Still cant put it in your bags, it's technically a belt
	anchored = 1	//Dont want people taking it out with their hands
	storage_type = /datum/storage/pouch/belt

/datum/storage/pouch/belt
	max_slots = 6
	max_specific_storage = WEIGHT_CLASS_SMALL

/obj/item/storage/belt/storage_pouch/attack_hand(mob/user, list/modifiers)	//Opens the bag on click - considering it's already anchored, this makes it function similar to how ghosts can open all nested inventories
	. = ..()
	atom_storage.show_contents(user)

/obj/item/storage/belt/holster/thigh
	name = "thigh holster"
	desc = "A fine leather holster, fastened to the hip and attached to a belt. Can hold a handgun and some ammo."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/storage/belt/holster/thigh"
	post_init_icon_state = "cowboy_belt"
	worn_icon_state = "cowboy_belt"
	inhand_icon_state = "utility"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	greyscale_config = /datum/greyscale_config/thigh_holster
	greyscale_config_worn = /datum/greyscale_config/thigh_holster/worn
	greyscale_colors = "#7B3B20#7B3B20"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/storage/belt/medbandolier
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	name = "medical bandolier"
	desc = "A pocketed, pine green belt slung like a sash over the shoulder. Features numerous pockets for medicines and poisons alike. Now is coward healing time."
	icon_state = "med_bandolier"
	worn_icon_state = "med_bandolier"
	storage_type = /datum/storage/med_bandolier

/datum/storage/med_bandolier
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_slots = 14
	max_total_storage = 35

/datum/storage/med_bandolier/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/applicator/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/storage/pill_bottle,
		/obj/item/implanter,
		/obj/item/hypospray/mkii,
		/obj/item/reagent_containers/cup/vial,
		/obj/item/weaponcell/medical,
	))
