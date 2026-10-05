// ============================================================
// bracket.scad - 鐵管 17 × 10mm 支架 (無頂橋, arm_h = 77)
// ============================================================
$fn = 64;

// ---- 鐵管實際尺寸 ----
tube_w       = 17.0;   // 寬 (X)
tube_h       = 10.0;   // 高 (Y)
tube_clear   = 0.3;    // 每邊公差

// ---- 套筒 ----
clamp_x      = 34.0;
clamp_y      = 36.0;
clamp_h      = 35.0;
screw_spacing= 20.0;
screw_d      = 3.5;
screw_head_d = 6.0;
screw_head_h = 3.5;

// ---- 兩臂 (沿 Y 前後分開) ----
arm_gap      = 19.0;
arm_thick    = 6.0;
arm_len      = 24.0;
arm_h        = 77.0;   // ★ 用返 77 ★

// ---- 滾輪軸 ----
shaft_d      = 3.0;

// ---- 孔尺寸 ----
hole_w = tube_w + 2*tube_clear;
hole_h = tube_h + 2*tube_clear;

// ---- 高度計算 ----
roller_z_center = clamp_h + arm_h/2;
roller_bottom   = roller_z_center - 27;
echo("=================================");
echo("鐵管寬:", tube_w);
echo("鐵管高:", tube_h);
echo("開孔寬:", hole_w);
echo("開孔高:", hole_h);
echo("滾輪軸中心高度:", roller_z_center, "mm");
echo("滾輪最低點高度:", roller_bottom, "mm");
echo("套筒頂高度:", clamp_h, "mm");
echo("間隙:", roller_bottom - clamp_h, "mm");
echo("=================================");

module bracket() {
    difference() {
        union() {
            // 套筒
            translate([-clamp_x/2, -clamp_y/2, 0])
                cube([clamp_x, clamp_y, clamp_h]);

            // 兩臂 (沿 Y 前後分開)
            for (sy = [-1, 1])
                translate([-arm_len/2,
                           sy*(arm_gap/2 + arm_thick/2) - arm_thick/2,
                           clamp_h])
                    cube([arm_len, arm_thick, arm_h]);
        }

        // 鐵管孔 17.6 × 10.6
        translate([-hole_w/2, -hole_h/2, -0.1])
            cube([hole_w, hole_h, clamp_h + 0.2]);

        // 滾輪軸孔
        translate([0, 0, roller_z_center])
            rotate([90, 0, 0])
                cylinder(d = shaft_d + 0.3,
                         h = arm_gap + 2*arm_thick + 4, center = true);

        // M3 螺絲孔 + Ø6 沉頭
        for (dz = [-screw_spacing/2, screw_spacing/2]) {
            translate([0, 0, clamp_h/2 + dz])
                rotate([0, 90, 0])
                    cylinder(d = screw_d, h = clamp_x + 2, center = true);
            translate([clamp_x/2 - screw_head_h, 0, clamp_h/2 + dz])
                rotate([0, 90, 0])
                    cylinder(d = screw_head_d, h = screw_head_h + 0.1);
        }
    }
}

bracket();