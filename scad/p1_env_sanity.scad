include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 8 : 128;

student_name = "SHAUN";   // <-- change this parameter
key_width    = 50;
key_height   = 20;
key_thick    = 4;
hole_spacing = 40;   // distance between the two keyring holes
hole_dia     = 3.0;  // clearance for keyring

diff()
cuboid([key_width, key_height, key_thick], rounding=2, anchor=BOTTOM) {
    attach(TOP) {
        left(hole_spacing / 2) tag("remove")
            cyl(d=hole_dia, h=key_thick + 1, anchor=BOTTOM);
        left(hole_spacing / 2) tag("remove")
            cyl(d=hole_dia, h=key_thick + 1, anchor=TOP);
    }
    attach(TOP)
     right(1.6)
        linear_extrude(height=1.5)
            text(student_name, size=8, halign="center", valign="center",
                 font="Liberation Sans:style=Bold");
}