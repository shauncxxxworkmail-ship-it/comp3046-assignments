// ============================================================
// 1_motor_mount.scad - N5065 馬達安裝座 (含方管夾、導軌座、編碼器凸台)
// 編碼器凸台：內邊緣距離 28.77mm，中心距 34.77mm，打斜卡入
// ============================================================
include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <n5065-mounts.scad>
include <htd-pulley.scad>

$fn = $preview ? 8 : 128;

// ---- 參數 ----
carriage_dim               = [20, 40, 10];
amt103_bolt_circle         = 16;
heatinsert_diameter        = 4.0;
heatinsert_length          = 4;
lift_tube_clearance        = 0.4;
lift_tube_od               = 10;
rail_screw_diameter        = 3;
mount_tube_clearance       = 0.4;
mount_tube_od              = 25;
mount_couple_screw_diameter= 3;
mount_gap                  = 2.4;
mount_wall_thickness       = mount_couple_screw_diameter * 2;   // 6mm
mount_length               = n5065_motor_length();

// ★ 編碼器凸台尺寸 ★
boss_w           = 6;          // 凸台寬度 (與 cuboid(6,...) 一致)
target_inner_gap = 28.77;      // 兩個凸台內邊緣之間嘅距離
boss_center_dist = target_inner_gap + boss_w;   // 中心距 = 34.77mm

// ---- 主體 ----
module motor_mount() {
    diff() cuboid(
        [n5065_motor_diameter(), mount_length, mount_wall_thickness*2 + mount_tube_od],
        anchor  = FWD + BOT,
        rounding= 2,
        edges   = [TOP+FWD, TOP+LEFT, TOP+RIGHT, BOT+BACK]
    ) {
        // 方管夾持孔 + 夾持間隙
        tag("remove") attach(FWD, FWD, inside=true) {
            cuboid([mount_tube_od + mount_tube_clearance,
                    mount_length*2,
                    mount_tube_od + mount_tube_clearance]);
            cuboid([n5065_motor_diameter(), mount_length*2, mount_gap]);
        }

        // 方管夾持螺絲孔 (熱熔螺母)
        tag("remove")
            grid_copies((n5065_motor_diameter() - mount_tube_od + mount_tube_clearance)/2 + mount_tube_od)
                screw_hole(str("M", mount_couple_screw_diameter),
                           l = mount_wall_thickness*2 + mount_tube_od) {
                    attach(BOT, BOT, inside=true)
                        cyl(d = heatinsert_diameter,
                            h = heatinsert_length,
                            chamfer1 = -0.6);
                }

        // 導軌管座
        align(BACK, TOP)
            cuboid(
                [n5065_motor_diameter(),
                 6+6+carriage_dim[0]+1.5,
                 (mount_wall_thickness*2 + mount_tube_od)/2],
                rounding = 2,
                edges    = [TOP+LEFT, TOP+RIGHT]
            ) {
                right(lift_tube_od/2)
                    attach(TOP, BOT)
                        half_of(LEFT)
                            rect_tube(l = 40,
                                      size  = 6+carriage_dim[0]+1.5,
                                      isize = lift_tube_od + mount_tube_clearance) {
                                tag("remove")
                                    attach(LEFT, TOP, inside=true)
                                        ycopies(20, n=2)
                                            screw_hole(str("M", rail_screw_diameter),
                                                       l = lift_tube_od) {
                                                attach(TOP, TOP, inside=true)
                                                    cyl(d = heatinsert_diameter,
                                                        h = heatinsert_length,
                                                        chamfer2 = -0.6);
                                            }
                            }
            }

        // 前安裝板 + 編碼器 (AMT103) 凸台
        // ★ 兩個凸台內邊緣距離 = 28.77mm，中心距 = 34.77mm，並以 zrot(25) 打斜卡入 ★
        align(BOT, FWD) cuboid([n5065_motor_diameter(), 6, 4]) {
            yflip() attach(BOT, RIGHT) n5065_front_mount(circle=false) {
                attach(TOP, BOT)
                    zrot(25)
                        arc_copies(d = boss_center_dist, n = 2, sa = 0, ea = 360)
                            cuboid(boss_w, rounding=1, edges="Z") {
                                tag("remove")
                                    attach(TOP, TOP, inside=true)
                                        screw_hole("M3", l=12) {
                                            attach(TOP, TOP, inside=true)
                                                cyl(d = heatinsert_diameter,
                                                    h = heatinsert_length,
                                                    chamfer2 = -0.6);
                                        }
                            }
            }
        }
    }
}

motor_mount();