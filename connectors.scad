//             //
// DEFINES     //
//             //

pillar_height_inch = 2;
face_width_inch = 0.666666;
slot_height_inch = 1;
tab_width_inch = 0.25;
wall_width    = 1.0;             // Width of slot (for cardstock thickness + clearance)
kerf          = 1.0;             // cut between tab and wall
tolerance     = 0.8;             // allow wiggle room below tab


// the calculated values below don't show up in the openscad customizer pane
function inch_to_mm(inches) = inches * 25.4;

pillar_height = inch_to_mm(pillar_height_inch);    // 2 inches in mm
face_width    = inch_to_mm(face_width_inch);  // 2/3 inch in mm
slot_height   = inch_to_mm(slot_height_inch);   // Height of slot (1 inch, from top down)
tab_height    = slot_height + inch_to_mm(0.5); // tab extends 1/2" below the slot
tab_width     = inch_to_mm(tab_width_inch);


module get_modelname(i) {
    if (i == "slimrect") PILLAR_slim_diag_rect();
    else if (i == "origrect") PILLAR_original_rect();
    else if (i == "cruciform") PILLAR_cruciform();
    else if (i == "cobblewall") import("src/pillar_cobblewall.stl");
    else if (i == "hengestone") PILLAR_hengestone();
    else if (i == "stalagmite") PILLAR_cave();
    else if (i == "log") import("src/log.stl");
    else if (i == "woodbeam") import("src/wood_beam.stl");
    else if (i == "slimbeam") PILLAR_smallbeam();
    else if (i == "slimhengestone") PILLAR_smallhengestone();
}
module wallify_variantname(variant) {
    if (variant == "end")           wallify()        children(0);
    else if (variant == "corner")   wallify(b=1)     children(0);
    else if (variant == "straight") wallify(c=1)     children(0);
    else if (variant == "tee")      wallify(b=1,c=1) children(0);
    else if (variant == "allways")  wallify(all=1)   children(0);
}

module build_byname(model, variant="allways") {
    wallify_variantname(variant) get_modelname(model) ;
}

//                        //
// Pillar model variants  //
//                        //

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

module PILLAR_caveold() {
    // this first POC model is too ugly and treelike
    width = 24;
    difference() {
        resize([width+1, width, 56])
            import("src/pillar_cave.stl");
        trim_top(1);
        bounding_cyl(24);
    }
}

module PILLAR_cave() {
    width = 21;

    resize([width+1, width, pillar_height])
        import("src/stalagmite.stl");
}

module PILLAR_hengestone() {
    hengewidth = 19.5;
    translate([-1,0.5,0])
        resize([hengewidth, hengewidth, pillar_height])
        import("src/hengestone.stl");
}

module PILLAR_smallbeam () {
    beamwidth = 18.5 / sqrt(2);
    rotate([0,0,45])
        resize([beamwidth, beamwidth, pillar_height])
        import("src/wood_beam.stl");
}

module PILLAR_smallhengestone () {
    hengewidth = 26 / sqrt(2);

    resize([hengewidth, hengewidth+2, pillar_height])
        rotate([0,0,45])
        PILLAR_hengestone();
}



//             //
// LIBRARY     //
//             //


module wall_cut(rotation) {
    rotate([0,0,rotation])
        translate([-wall_width/2, 0, pillar_height - tab_height - tolerance])
        cube([wall_width, pillar_height, tab_height+tolerance]);

    rotate([0,0,rotation])
        translate([-wall_width/2, face_width/2, 0])
        cube([wall_width, pillar_height, pillar_height]);
}

module cut_walls(rotation) {
    // first we cut space
    difference() {
        children(0);
        wall_cut(rotation);
    }
    // then backfill the tab that fits in the kerf
    fill_tab(rotation);
}

module fill_tab(rotation) {
    rotate([0,0,rotation])
        translate([-wall_width / 2, (face_width / 2) - kerf + tolerance, 0])
        cube([wall_width, kerf - tolerance, pillar_height - slot_height - tolerance]);
}

// create slots in a pillar
module wallify(b=0, c=0, d=0, all=0) {

    cut_walls(0)
        cut_walls(090 * (b+all))
        cut_walls(180 * (c+all))
        cut_walls(270 * (d+all))
        children(0);
}

//move a completed shape into display position
module display_pos(pos) {
    row = ceil((pos) / 8);
    rotate([0, 0, 45 * pos])
        translate([row * pillar_height, 0, 0])
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


