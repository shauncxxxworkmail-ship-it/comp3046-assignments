// ============================================================
// 5_motor_pulley.scad - 馬達端皮帶輪 (5M 34T) - 選用
// ============================================================
include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <n5065-mounts.scad>
include <htd-pulley.scad>

$fn = $preview ? 8 : 128;

diff()
htd_pulley(
    type             = "5M",
    teeth            = 34,
    belt_width       = 10,
    hub_h            = 0,
    flange_thickness = 5,
    anchor           = BOTTOM
) {
    // N5065 後軸孔 (中央大孔)
    tag("remove")
        attach(TOP, BOT, inside=true)
            n5065_rear_bore();

    // N5065 後軸螺絲孔 (一圈小孔)
    tag("remove")
        attach(BOT, TOP, inside=true)
            n5065_rear_screws(l = 10 + 5*2 + 1.5);
}