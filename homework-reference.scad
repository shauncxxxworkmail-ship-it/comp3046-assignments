include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <n5065-mounts.scad>
include <htd-pulley.scad>
include <htd-linear-clamp.scad>

$fn = $preview ? 8 : 128;

carriage_dim = [20, 40, 10];
carriage_screw_hole_interval = [16, 15];

// [修改點 1] AMT103 編碼器安裝尺寸
// 目前預設為 Option A (16mm 螺栓圓)
amt103_bolt_circle = 16; 

// [修改點 2] 熱熔螺母尺寸 (標準 M3 熱熔螺母通常外徑為 4.0mm 左右)
// 已將直徑從 3.8 改為 4.0，並修正了變數名稱的拼寫錯誤 (legth -> length)
heatinsert_diameter = 4.0;
heatinsert_length = 4;

lift_tube_clearance = 0.4;
lift_tube_od = 10;
lift_tube_length = 200;
rail_screw_diameter = 3;

mount_tube_clearance = 0.4;
mount_tube_od = 25;

mount_couple_screw_diameter = 3;
mount_gap = 2.4;
mount_wall_thickness = mount_couple_screw_diameter * 2; // 6mm
mount_length = n5065_motor_length();

// [修改點 3] 皮帶長度精確計算 
// 中心距 C = 200mm(導軌) + 25mm(方管) + 2 * 6mm(安裝壁) = 243mm
// 皮帶長度 L = 2*C + 34*5 (兩端34齒，5M皮帶，齒距5mm)
center_distance = lift_tube_length + mount_tube_od + 2 * mount_wall_thickness; // 243mm
calculated_belt_length = 2 * center_distance + 34 * 5; // 656mm
belt_teeth = calculated_belt_length / 5; // 131.2齒
echo("Exact Belt Length Required (mm): ", calculated_belt_length);
echo("Exact Belt Teeth: ", belt_teeth);

// [修改點 4] 實際中心距 
// 132T 皮帶 (660mm) 配 34T 齒輪的理論中心距為 245mm。
actual_center_distance = 245; 

// [修改點 5] 新增惰輪張緊器模組
module idler_tensioner() {
    diff("remove") {
        cuboid([30, 25, 10], rounding=2, anchor=BOTTOM);
        tag("remove")
            move([0, 0, 5])
                screw_hole("M4", l=10, head="socket", anchor=BOTTOM);
        tag("remove")
            move([0, 0, 1.5])
                cyl(d=7, h=3, anchor=BOTTOM);
    }
}

// [修改點 6] 補齊惰輪組件 (用於皮帶迴圈)
module idler_pulley_assembly() {
    idler_bearing_od = 8;
    idler_bearing_id = 3;
    idler_bearing_h  = 4;
    
    htd_pulley(
        type = "5M", teeth = 34, belt_width = 10,
        bore_d = idler_bearing_od, d_flat = idler_bearing_od,
        hub_d = 18, hub_h = 7, flange_thickness = 1.5, 
        flange_overhang = 1.5, set_screw_d = 0, anchor = BOTTOM
    );
    up(21.5) cyl(d=idler_bearing_od, h=idler_bearing_h, anchor=BOTTOM);
    up(21.5) cyl(d=idler_bearing_id, h=idler_bearing_h+0.2, anchor=BOTTOM);
}

hide("") {
    tag("base") diff() cuboid([n5065_motor_diameter(), mount_length, mount_wall_thickness*2 + mount_tube_od], anchor=FWD+BOT, rounding=2, edges=[TOP+FWD, TOP+LEFT, TOP+RIGHT, BOT+BACK]) {

        tag("remove") attach(FWD, FWD, inside=true) {
            cuboid([mount_tube_od + mount_tube_clearance, mount_length*2, mount_tube_od + mount_tube_clearance]);
            cuboid([n5065_motor_diameter(), mount_length*2, mount_gap]);
        }
        tag("remove")
            grid_copies((n5065_motor_diameter() - mount_tube_od + mount_tube_clearance)/2 + mount_tube_od)
                screw_hole(str("M", mount_couple_screw_diameter), l=mount_wall_thickness*2 + mount_tube_od) {
                    attach(BOT, BOT, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_length, chamfer1=-0.6);
                }

        // 導軌管與導軌螺絲參考
        align(BACK, TOP) cuboid([n5065_motor_diameter(), 6+6+carriage_dim[0]+1.5, (mount_wall_thickness*2 + mount_tube_od)/2], rounding=2, edges=[TOP+LEFT, TOP+RIGHT]) {
            right(lift_tube_od/2) attach(TOP, BOT) half_of(LEFT) rect_tube(l=40, size=6+carriage_dim[0]+1.5, isize=lift_tube_od+mount_tube_clearance) {
                tag("remove") attach(LEFT, TOP, inside=true) ycopies(20, n=2) #screw_hole(str("M", rail_screw_diameter), l=lift_tube_od) {
                    attach(TOP, TOP, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_length, chamfer2=-0.6);
                }
            }
        }

        // N5065 前安裝座、編碼器凸台與電機皮帶輪
        align(BOT, FWD) cuboid([n5065_motor_diameter(), 6, 4]) {
            yflip() attach(BOT, RIGHT) n5065_front_mount(circle=false) {
                // 使用 AMT103 螺栓圓尺寸計算凸台位置
                attach(TOP, BOT) zrot(25) arc_copies(d=amt103_bolt_circle+6, n=2, sa=0, ea=360) cuboid(6, rounding=1, edges="Z") {
                    tag("remove") attach(TOP, TOP, inside=true) screw_hole("M3", l=12) {
                        attach(TOP, TOP, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_length, chamfer2=-0.6);
                    }
                }

                down(n5065_motor_length())
                    attach(BOT, TOP) htd_pulley(type="5M", teeth=34, belt_width=10, hub_h=0, flange_thickness=5) {
                        tag("remove") attach(TOP, BOT, inside=true) n5065_rear_bore();
                        tag("remove") attach(BOT, TOP, inside=true) n5065_rear_screws(l=10+5*2+1.5);
                    }
            }
        }
        
        // [修改點 7] 加入惰輪張緊器支架參考 (移至實際中心距)
        align(BACK, TOP) right(actual_center_distance) idler_tensioner();
    }

    // 皮帶夾具 (連接至車架)
    tag("clamp") diff() htd_linear_clamp(type="5M", teeth=8, belt_width=10, thickness=10, flange_thickness=10) {
        tag("remove") grid_copies(carriage_screw_hole_interval, n=2) screw_hole(str("M", rail_screw_diameter), l=carriage_dim[2]);

        attach(TOP, BOT, overlap=-10) cuboid([40, 30, 6]) {
            tag("remove") grid_copies(carriage_screw_hole_interval, n=2) screw_hole(str("M", rail_screw_diameter), l=carriage_dim[2]);
        }
    }
    
    // [修改點 8] 將惰輪放置於實際中心距處
    right(actual_center_distance) up(20) idler_pulley_assembly();
}