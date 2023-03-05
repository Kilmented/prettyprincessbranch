/// ARROW CRAFTING ~

/// the stickthing that we're using as a base that everything will be slapped onto
/obj/item/arrow_shaft
	name = "arrow shaft"
	desc = "A long and sturdy piece of wood with notches at both ends. \
		Just add a head and some hay, and you've got yourself a DIY arrow!"
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_shaft"
	/// our arrow head type
	var/obj/item/stack/arrowhead/the_head
	/// Does it have hay on it?
	var/has_hay
	/// The result arrow
	var/obj/item/ammo_casing/caseless/arrow/the_arrow

/obj/item/arrow_shaft/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/arrowhead) && attach_arrowhead(W, user))
		return
	if(istype(W, /obj/item/stack/sheet/hay) && attach_hay(W, user))
		return
	. = ..()

/obj/item/arrow_shaft/attack_hand(mob/user, act_intent, attackchain_flags)
	if(ispath(the_head, /obj/item/stack/arrowhead))
		remove_arrowhead(user)
		return
	if(has_hay)
		remove_hay(user)
		return
	. = ..()


/obj/item/arrow_shaft/proc/attach_hay(obj/item/stack/sheet/hay/haaay, mob/user)
	if(has_hay)
		return FALSE
	if(!istype(haaay))
		return FALSE
	if(!haaay.use(1))
		user.show_message(span_alert("You need at least one clump of hay for this!"))
		return FALSE
	has_hay = TRUE
	user.show_message(span_notice("You strap some hay to the base of the shaft, giving it a basic set of fletching."))
	update_icon()
	check_constructed(user)
	return TRUE

/obj/item/arrow_shaft/proc/remove_hay(mob/user)
	if(!has_hay)
		return FALSE
	var/obj/item/stack/sheet/hay/newhay = new(get_turf(src))
	user.put_in_hands(newhay)
	has_hay = FALSE
	user.show_message(span_notice("You pull the fletching off the shaft."))
	update_icon()
	check_constructed(user)

/obj/item/arrow_shaft/proc/attach_arrowhead(obj/item/stack/arrowhead/a_head, mob/user)
	if(!istype(a_head))
		return FALSE
	if(the_head || the_arrow)
		return FALSE
	if(!a_head.use(1))
		user.show_message(span_alert("You need at least one arrow head!"))
		return FALSE
	the_head = a_head.type
	the_arrow = a_head.result_arrow
	user.show_message(span_notice("You tie \the [a_head] to the head of the shaft."))
	update_icon()
	check_constructed(user)

/obj/item/arrow_shaft/proc/remove_arrowhead(mob/user)
	if(!ispath(the_head, /obj/item/stack/arrowhead))
		return FALSE
	var/obj/item/stack/arrowhead/new_head = new(get_turf(src))
	user.put_in_hands(new_head)
	the_head = null
	the_arrow = null
	user.show_message(span_notice("You pull the head off the shaft."))
	update_icon()
	check_constructed(user)

/obj/item/arrow_shaft/proc/check_constructed(mob/user)
	if(!ispath(the_head, /obj/item/stack/arrowhead))
		return FALSE
	else if(!ispath(initial(the_head.result_arrow), /obj/item/ammo_casing/caseless/arrow))
		remove_arrowhead(user)
		return FALSE
	if(!has_hay)
		return FALSE
	finish_construction(user)
	return TRUE

/obj/item/arrow_shaft/proc/finish_construction(mob/user)
	var/obj/item/ammo_casing/caseless/arrow/make_this_arrow = new the_arrow(get_turf(src))
	if(ismob(user))
		user.visible_message(span_notice("[user] makes \a [make_this_arrow]!"))
		if(loc == user)
			user.put_in_hands(make_this_arrow)
	qdel(src)

/obj/item/arrow_shaft/update_overlays()
	. = ..()
	if(ispath(the_head, /obj/item/stack/arrowhead))
		. += mutable_appearance(initial(the_head.icon), "[initial(the_head.icon_state)]_overlay")
	if(has_hay)
		. += mutable_appearance(icon, "arrow_fletching")


/// The arrow heads, use these on the shaft to stick them on the shaft, ezpz
/obj/item/stack/arrowhead
	name = "arrow heads"
	singular_name = "arrow head"
	desc = "Some kind of pointy thing made to go fast."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_metal"
	/// The head defines the resulting arrow
	var/obj/item/ammo_casing/caseless/arrow/result_arrow = /obj/item/ammo_casing/caseless/arrow

/obj/item/stack/arrowhead/metal
	name = "metal arrow heads"
	singular_name = "metal arrow head"
	desc = "A sharpened piece of metal, filed down to an aerodynamic point."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_metal"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/metal

/obj/item/stack/arrowhead/field
	name = "field arrow heads"
	singular_name = "field arrow head"
	desc = "A thin, sharpened piece of metal, filed down to an aerodynamic point."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_field"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/field

/obj/item/stack/arrowhead/titanium
	name = "titanium arrow heads"
	singular_name = "titanium arrow head"
	desc = "A sharpened piece of titanium, filed down to an aerodynamic point."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_titanium"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/titanium

/obj/item/stack/arrowhead/bone
	name = "bone arrow heads"
	singular_name = "bone arrow head"
	desc = "A sharpened 'animal' bone, filed down to an aerodynamic point."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_bone"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/bone

/obj/item/stack/arrowhead/flint
	name = "flint arrow heads"
	singular_name = "flint arrow head"
	desc = "A sharpened piece of flint, filed down to an aerodynamic point."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_flint"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/flint

/obj/item/stack/arrowhead/glass
	name = "glass arrow heads"
	singular_name = "glass arrow head"
	desc = "A sharpened piece of glass, filed down to an aerodynamic point."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_glass"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/glass

/obj/item/stack/arrowhead/jagged
	name = "jagged arrow heads"
	singular_name = "jagged arrow head"
	desc = "A jagged shard of metal, ready to rearrange someone's guts all over the road."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_jagged"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/jagged

/obj/item/stack/arrowhead/explosive
	name = "explosive arrow heads"
	singular_name = "explosive arrow head"
	desc = "A sack of explosives, ready to rearrange someone's guts all over the road."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_explosive"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/explosive

/obj/item/stack/arrowhead/ion
	name = "ion arrow heads"
	singular_name = "ion arrow head"
	desc = "A clump of charged electronic chunks, ready to let out all manner of electrical nonsense on whatever it hits."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_ion"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/ion

/obj/item/stack/arrowhead/blunt
	name = "blunt arrow heads"
	singular_name = "blunt arrow head"
	desc = "A blunt wad of leather, firm enough to knock someone over."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_blunt"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/blunt

/obj/item/stack/arrowhead/practice
	name = "practice arrow heads"
	singular_name = "practice arrow head"
	desc = "A blunt sack, ready to gently paff someone from across the road."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_practice"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/practice

/obj/item/stack/arrowhead/sticky
	name = "sticky arrow heads"
	singular_name = "sticky arrow head"
	desc = "A sticky sack, ready to annoy someone."
	icon = 'icons/obj/arrow_crafting.dmi'
	icon_state = "arrow_head_sticky"
	result_arrow = /obj/item/ammo_casing/caseless/arrow/sticky
