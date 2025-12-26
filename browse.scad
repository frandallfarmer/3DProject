include <connectors.scad>;

// DEBUG SCRIPT DISPLAYS ALL MODELS
// Rendering all models from here seems to be slow and single threaded
// so I don't recommend using this file to actually render an STL -- but
// it's handy for debugging geometry during development

module display_all_stls() {

    display_pos(0) { build_byname("slimrect"); };
    display_pos(1) { build_byname("origrect"); };
    display_pos(2) { build_byname("cruciform"); };
    display_pos(3) { build_byname("cobblewall"); };
    display_pos(4) { build_byname("hengestone"); };
    display_pos(5) { build_byname("stalagmite"); };
    display_pos(6) { build_byname("log"); };
    display_pos(7) { build_byname("woodbeam"); };
    display_pos(8) { build_byname("slimbeam"); };
    display_pos(9) { build_byname("slimhengestone"); };
  
/*
// source stl defective
    display_pos(20) {
        wallify(all=1) { import("src/mine_framework.stl"); }};
*/
}

module display_all_tab_variants() {
    display_pos(0) {
        wallify(b=1) { children(0); }};
    display_pos(1) {
        wallify(c=1) { children(0); }};
    display_pos(2) {
        wallify(b=1,c=1) { children(0); }};
    display_pos(3) {
        wallify(b=1,c=1,d=1) { children(0); }};
    display_pos(4) {
        wallify() { children(0); }};
}

//display_all_stls();
display_all_tab_variants() { PILLAR_smallbeam(); };
//wallify(c=1) { PILLAR_slim_diag_rect(); };