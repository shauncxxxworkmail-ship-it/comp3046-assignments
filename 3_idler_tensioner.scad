// ============================================================
// 3_idler_tensioner.scad - 惰輪張緊器支架
// ============================================================
include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 8 : 128;

module idler_tensioner() {
    diff("remove") {
        cuboid([30, 25, 10], rounding=2, anchor=BOTTOM);

        // M4 螺絲頭沉頭孔
        tag("remove")
            move([0, 0, 5])
                screw_hole("M4", l=10, head="socket", anchor=BOTTOM);

        // 惰輪軸承座凹槽
        tag("remove")
            move([0, 0, 1.5])
                cyl(d=7, h=3, anchor=BOTTOM);
    }
}

idler_tensioner();