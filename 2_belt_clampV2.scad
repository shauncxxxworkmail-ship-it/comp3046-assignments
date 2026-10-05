// ============================================================
// 2_belt_clamp_lower.scad - 5M 皮帶線性夾具下盒
// 孔位與上盒對齊，但螺絲孔為盲孔，不穿透底部
// ============================================================
include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <htd-linear-clamp.scad>
include <htd-pulley.scad>

$fn = $preview ? 8 : 128;

// ---- 參數 (與上盒相同) ----
carriage_dim                 = [20, 40, 10];
carriage_screw_hole_interval = [16, 15];
rail_screw_diameter          = 3;
bottom_thickness             = 3;   // 底部保留厚度 (孔不穿透此層)

// ---- 皮帶夾具下盒 ----
diff()
htd_linear_clamp(type="5M", teeth=8, belt_width=10,
                 thickness=10, flange_thickness=10) {

    // 夾具本體螺絲孔 - 盲孔
    // 孔從 z = bottom_thickness 開始往上，貫穿頂部但保留底部
    tag("remove")
        up(bottom_thickness)
            grid_copies(carriage_screw_hole_interval, n=2)
                screw_hole(str("M", rail_screw_diameter),
                           l = carriage_dim[2]);

    // 車架安裝板 (與上盒相同)
    attach(TOP, BOT, overlap = -10)
        cuboid([40, 30, 6]) {
            tag("remove")
                grid_copies(carriage_screw_hole_interval, n=2)
                    screw_hole(str("M", rail_screw_diameter),
                               l = carriage_dim[2]);
        }
}