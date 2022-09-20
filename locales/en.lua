local Translations = {
    error = {
        no_slots = "There Are No Slots Left",
        occured = "Error Has Occurred",
        nothing_inserted_pc = "Nothing inserted to the PC",
        wrong_inserted_pc = "Make sure you inserted a valid USB stick to the PC",
        nothing_inserted_printer = "Nothing inserted to the printer",
        wrong_inserted_printer = "Make sure you inserted a valid USB stick to the printer",
        empty_usb = "Connected USB stick is empty.",
        none_blank_card_left = "Printer does not have any blank cards left.",
        other_than_blank_cards = "Something stuck at the container, please remove it and insert blank cards.",
    },
    info = {
        enter = "Enter Forgery Office",
        usb_overwritten = "Plugged USB stick will be overwritten",
    },
    targetInfo = {
        enter = "Enter Forgery Office",
        create_fake_id = "Create Fake ID",
        create_fake_driving_license = "Create Fake Driver License",
        create_fake_weapon_license = "Create Fake Weapon License",
        create_fake_lawyer_pass = "Create Fake Lawyer Pass",
        use_printer = "Print",
        inventory = "View Inventory",
        usb_slot_inventory = "USB Slots",
        printer_usb_inventory = "USB Slot",
        printer_blank_card_inventory = "Blank Card Container",
        printer_printed_card_inventory = "Printed Cards",
        pc_option = "Computer Options",
        printer_option = "Printer Options",
        leave = "Leave Forgery Office",
        close_menu = "⬅ Close Menu",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})