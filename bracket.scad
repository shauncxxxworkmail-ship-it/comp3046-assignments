// ============================================================
// bracket.scad - 鐵管 10 × 10mm 支架
// ★ 移除 -X 側板 ★
// ★ 加頂板封頂，保留鐵管套 ★
// ★ 套筒壁厚 10mm ★
// ★ 鐵管 10 × 10mm ★
// ★ 螺絲孔整體下移 5mm ★
// ★ 套筒底部加長 5mm (40 → 45mm)，避免孔洞貼邊 ★
// ============================================================
$fn = 64;

// ---- 鐵管實際尺寸 ----
tube_w       = 10.0;
tube_h       = 10.0;
tube_clear   = 0.3;

// ---- 孔尺寸 ----
hole_w = tube_w + 2*tube_clear;   // 10.6
hole_h = tube_h + 2*tube_clear;   // 10.6

// ---- 套筒 ----
wall_thick   = 10.0;              // 套筒壁厚 (闊深)
clamp_x      = hole_w + 2*wall_thick;   // 30.6
clamp_y      = hole_h + 2*wall_thick;   // 30.6
clamp_h      = 45.0;              // ★ 套筒高度加長 5mm (原 40 → 45)
screw_spacing= 20.0;
screw_d      = 3.5;
screw_head_d = 6.0;
screw_head_h = 3.5;
screw_z_shift = -5.0;   // 螺絲孔整體下移 5mm (相對於套筒中心)

// ---- 頂板 ----
top_plate_t  = 5.0;      // 頂板厚度

// ---- 兩臂 (沿 Y 前後分開) ----
arm_gap      = 19.0;
arm_thick    = 6.0;
arm_len      = 24.0;
arm_h        = 77.0;

// ---- 滾輪軸 ----
shaft_d      = 3.0;

// ---- 座標 ----
tube_left  = -hole_w/2;            // -5.3
clamp_left = -clamp_x/2;           // -15.3
remove_w   = tube_left - clamp_left;   // 10.0 (即壁厚)

// ---- 高度計算 ----
arm_z0          = clamp_h + top_plate_t;
roller_z_center = arm_z0 + arm_h/2;
roller_bottom   = roller_z_center - 27;
total_h         = arm_z0 + arm_h;

echo("=================================");
echo("鐵管孔: ", hole_w, " × ", hole_h);
echo("套筒: X ", clamp_left, " 到 ", clamp_x/2, " (尺寸 ", clamp_x, " × ", clamp_y, " × ", clamp_h, ")");
echo("-X 側板移除: X ", clamp_left, " 到 ", tube_left, " (寬 ", remove_w, "mm)");
echo("頂板: Z ", clamp_h, " 到 ", arm_z0, " (厚 ", top_plate_t, "mm)");
echo("手臂: Z ", arm_z0, " 到 ", total_h);
echo("螺絲孔中心 Z: ", clamp_h/2 + screw_z_shift, " (下移 ", -screw_z_shift, "mm)");
echo("最下方孔底 Z: ", clamp_h/2 + screw_z_shift - screw_spacing/2 - screw_head_d/2, " (距離底邊 ", clamp_h/2 + screw_z_shift - screw_spacing/2 - screw_head_d/2, "mm)");
echo("總高: ", total_h, " mm");
echo("=================================");

module bracket() {
    difference() {
        union() {
            // 套筒
            translate([-clamp_x/2, -clamp_y/2, 0])
                cube([clamp_x, clamp_y, clamp_h]);

            // ★ 頂板 (封頂)
            translate([-clamp_x/2, -clamp_y/2, clamp_h])
                cube([clamp_x, clamp_y, top_plate_t]);

            // 兩臂
            for (sy = [-1, 1])
                translate([-arm_len/2,
                           sy*(arm_gap/2 + arm_thick/2) - arm_thick/2,
                           arm_z0])
                    cube([arm_len, arm_thick, arm_h]);
        }

        // 鐵管孔 (貫穿套筒 + 頂板，保留鐵管套)
        translate([-hole_w/2, -hole_h/2, -0.1])
            cube([hole_w, hole_h, arm_z0 + 0.1]);

        // ★ 移除 -X 側板 (僅套筒高度，讓套筒可夾緊)
        translate([clamp_left - 1, -clamp_y/2 - 1, -0.1])
            cube([remove_w + 1, clamp_y + 2, clamp_h + 0.1]);

        // 滾輪軸孔
        translate([0, 0, roller_z_center])
            rotate([90, 0, 0])
                cylinder(d = shaft_d + 0.3,
                         h = arm_gap + 2*arm_thick + 4, center = true);

        // M3 螺絲孔 + Ø6 沉頭 (整體下移 5mm)
        for (dz = [-screw_spacing/2, screw_spacing/2]) {
            translate([0, 0, clamp_h/2 + screw_z_shift + dz])
                rotate([0, 90, 0])
                    cylinder(d = screw_d, h = clamp_x + 2, center = true);
            translate([clamp_x/2 - screw_head_h, 0, clamp_h/2 + screw_z_shift + dz])
                rotate([0, 90, 0])
                    cylinder(d = screw_head_d, h = screw_head_h + 0.1);
        }
    }
}

bracket();