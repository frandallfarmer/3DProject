// D&D Terrain Pillar Connector
// Parametric design for 3D printing

// === PARAMETERS (adjust these as needed) ===
pillar_height = 50.8;        // 2 inches in mm
face_width = 16.93;          // 2/3 inch in mm
wall_thickness = 2;          // Wall thickness in mm

slot_width = 1.0;            // Width of slot (for cardstock thickness + clearance)
slot_height = 25.4;          // Height of slot (1 inch, from top down)
slot_depth = wall_thickness; // Slots go through the wall
slot_from_top = 0;           // Distance from top to start slot (0 = starts at top)

// Calculated values
inner_size = face_width - (2 * wall_thickness);

// === MAIN MODEL ===
difference() {
    // Outer shell
    cube([face_width, face_width, pillar_height]);

    // Hollow interior (leave bottom solid for strength)
    translate([wall_thickness, wall_thickness, wall_thickness])
        cube([inner_size, inner_size, pillar_height]);

    // Slot on face 1 (front, centered, from top down)
    translate([face_width/2 - slot_width/2, -0.1, pillar_height - slot_from_top - slot_height])
        cube([slot_width, wall_thickness + 0.1, slot_height]);

    // Slot on face 2 (right, centered, from top down)
    translate([face_width - wall_thickness, face_width/2 - slot_width/2, pillar_height - slot_from_top - slot_height])
        cube([wall_thickness + 0.1, slot_width, slot_height]);

    // Slot on face 3 (back, centered, from top down)
    translate([face_width/2 - slot_width/2, face_width - wall_thickness, pillar_height - slot_from_top - slot_height])
        cube([slot_width, wall_thickness + 0.1, slot_height]);

    // Slot on face 4 (left, centered, from top down)
    translate([-0.1, face_width/2 - slot_width/2, pillar_height - slot_from_top - slot_height])
        cube([wall_thickness + 0.1, slot_width, slot_height]);
}
