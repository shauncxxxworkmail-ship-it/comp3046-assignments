include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../htd-linear-clamp.scad>

$fn = 64;

// MGN9H carriage reference block and 10 mm belt clamp.
move([0, 0, 10])
    cuboid([22, 20, 12], rounding=1, anchor=BOTTOM);

move([0, 0, 22])
    htd_linear_clamp(
        type = "5M",
        teeth = 6,
        belt_width = 10,
        thickness = 4,
        flange_thickness = 1.5,
        flange_height = 2,
        anchor = BOTTOM
    );

// A straight 10 mm belt segment shows the tooth engagement direction.
color("steelblue", 0.9)
move([0, 0, 22])
    down(0.8)
        cuboid([30, 10, 1.6], anchor=BOTTOM);
