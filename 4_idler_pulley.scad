// ============================================================
// 4_idler_pulley.scad - 惰輪皮帶輪 (5M 34T, 用於皮帶迴圈)
// ============================================================
include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <htd-pulley.scad>

$fn = $preview ? 8 : 128;

idler_bearing_od = 8;   // 608 軸承外徑

htd_pulley(
    type             = "5M",
    teeth            = 34,
    belt_width       = 10,
    bore_d           = idler_bearing_od,
    d_flat           = idler_bearing_od,
    hub_d            = 18,
    hub_h            = 7,
    flange_thickness = 1.5,
    flange_overhang  = 1.5,
    set_screw_d      = 0,
    anchor           = BOTTOM
);