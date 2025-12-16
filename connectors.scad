//             //
// DEFINES     //
//             //

function inch_to_mm(inches) = inches * 25.4;

pillar_height = inch_to_mm(2);    // 2 inches in mm
face_width    = inch_to_mm(2/3);  // 2/3 inch in mm

wall_width    = 1.0;             // Width of slot (for cardstock thickness + clearance)
slot_height   = inch_to_mm(1);   // Height of slot (1 inch, from top down)
tab_height    = slot_height + inch_to_mm(0.5); // tab extends .5 in below the slot
tab_width     = inch_to_mm(0.25);
kerf          = 1.0;             // cut between tab and wall
tolerance     = 0.4;             // allow wiggle room

module PILLAR_original_rect() {
    // the original paper rectangle
    translate([0,0,pillar_height/2])
        cube([face_width, face_width, pillar_height], true);
}

module PILLAR_slim_diag_rect() {
    // rotate 45 degrees for a slimmer rectangle
    
    // rotated square is sqrt(2) wide, plus a little extra to fit the tab
    face = face_width / sqrt(2) + (kerf/1.5);

    rotate([0,0,45]) //45 degrees around z axis
        translate([0,0,pillar_height/2])
        cube([face, face, pillar_height], true);
}

module PILLAR_cruciform() {
    rotate([0,0,0])
        translate([0,0,pillar_height/2])
        cube([wall_width * 3, face_width, pillar_height], true);
    rotate([0,0,90])
        translate([0,0,pillar_height/2])
        cube([wall_width * 3, face_width, pillar_height], true);
    cylinder(h=2, d=face_width, center=true);
}

module PILLAR_cave() {
    width = 24;
    difference() {
        resize([width+1, width, 56]) 
            import("src/pillar_cave.stl"); 
        trim_top(1);
        bounding_cyl(24);
    }
}



//             //
// RENDER ALL  //
//             //

module render_all() {
    display_pos(0) {
        wallify() { PILLAR_slim_diag_rect(); }};
    display_pos(1) {
        wallify() { PILLAR_original_rect(); }};
    display_pos(2) {
        wallify() { PILLAR_cruciform(); }};
    display_pos(3) {
        wallify() { import("src/pillar_stone.stl"); }};
    display_pos(4) {
        wallify() { import("src/pillar_beam.stl"); }};
    display_pos(5) {
        wallify() { PILLAR_cave(); }};
}
//render_all();
wallify() { PILLAR_slim_diag_rect(); };




//             //
// LIBRARY     //
//             //


module wall_cut(rotation) {
    //TODO ADD TOLERANCE
    rotate([0,0,rotation])
        translate([-wall_width/2, 0, pillar_height - tab_height - tolerance])
        cube([wall_width, pillar_height, tab_height+tolerance]);

    rotate([0,0,rotation])
        translate([-wall_width/2, face_width/2, 0])
        cube([wall_width, pillar_height, pillar_height]);
}

// first we cut space for the 4 walls
module cut_walls() {
    wall_cut(0);
    wall_cut(90);
    wall_cut(180);
    wall_cut(270);
}

// then backfill the tab that fits in the kerf
module fill_tabs() {
    fill_tab(0);
    fill_tab(90);
    fill_tab(180);
    fill_tab(270);
}

module fill_tab(rotation) {
    rotate([0,0,rotation])
        translate([-wall_width / 2, (face_width / 2) - kerf + tolerance, 0])
        cube([wall_width, kerf - tolerance, pillar_height - slot_height - tolerance]);
}

// create slots in a pillar
module wallify() {
    // first cut holes for the wall to fit through
    difference() {
        children(0);
        cut_walls();
        trim_top();
    }
    // then insert the tiny walls that fit in the tabs' slim kerf
    fill_tabs();
}

//move a completed shape into display position
module display_pos(pos) {
    rotate([0, 0, 45 * pos])
        translate([pillar_height, 0, 0])
        children(0);
}

module trim_top(offset=0) {
    translate([0,0,pillar_height*2-offset])
        cube([100,100,100], center=true);
}

module bounding_cyl(diameter) {
    difference() {
        cylinder(pillar_height,100,center=true);
        cylinder(pillar_height, d=diameter, center=true);
    }
}


