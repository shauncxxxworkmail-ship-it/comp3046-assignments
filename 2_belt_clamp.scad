// ============================================================
// 2_belt_clamp.scad - 5M 皮帶線性夾具 (連接車架)
// ============================================================
include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <htd-linear-clamp.scad>
include <htd-pulley.scad>

$fn = $preview ? 8 : 128;

// ---- 參數 ----
carriage_dim               = [20, 40, 10];
carriage_screw_hole_interval = [16, 15];
rail_screw_diameter        = 3;

// ---- 皮帶夾具 ----
diff()
htd_linear_clamp(type="5M", teeth=8, belt_width=10,
                 thickness=10, flange_thickness=10) {
    // 夾具本體螺絲孔
    tag("remove")
        grid_copies(carriage_screw_hole_interval, n=2)
            screw_hole(str("M", rail_screw_diameter), l = carriage_dim[2]);

    // 車架安裝板
    attach(TOP, BOT, overlap = -10)
        cuboid([40, 30, 6]) {
            tag("remove")
                grid_copies(carriage_screw_hole_interval, n=2)
                    screw_hole(str("M", rail_screw_diameter), l = carriage_dim[2]);
        }
}