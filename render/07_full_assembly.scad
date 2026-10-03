include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../n5065-mounts.scad>
include <../htd-pulley.scad>

$fn = 64;

mount_plate_thickness = 6;
rail_tube_side = 10;
chassis_tube_side = 25;
motor_center_z = -9.25;

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

module carriage() {
    diff("remove") {
        cuboid([21, 21, 12], rounding=1, anchor=BOTTOM);
        tag("remove")
            cuboid([15, 8, 13], anchor=CENTER);
        tag("remove")
            move([0, 0, 2])
                cyl(d=4, h=4, anchor=BOTTOM);
    }
}

// 25 x 25 mm chassis tube and 10 x 10 mm rail tube.
move([0, 0, 2])
    cuboid([chassis_tube_side, chassis_tube_side, 18], anchor=BOTTOM);
move([32, 0, 0])
    cuboid([rail_tube_side, rail_tube_side, 45], anchor=BOTTOM);
move([32, 0, 32])
    cuboid([20, 25, 12], anchor=CENTER);

// N5065 front/rear mounts, motor body, and encoder bosses.
move([0, 0, motor_center_z]) {
    n5065_front_mount(thickness=mount_plate_thickness, circle=false) {
        attach(TOP, BOT)
            zrot(25)
                arc_copies(d=33, n=2, sa=0, ea=360)
                    cuboid([3, 6, 6], anchor=CENTER);
    }
    down(n5065_motor_length() / 2 + mount_plate_thickness / 2)
        cyl(d=n5065_motor_diameter(), h=n5065_motor_length(), anchor=CENTER);
    down(n5065_motor_length() + mount_plate_thickness / 2)
        n5065_rear_mount(thickness=mount_plate_thickness, circle=false);
}

// HTD5M drive pulley on the motor shaft.
move([0, 0, motor_center_z + n5065_motor_length() / 2 + mount_plate_thickness])
    htd_pulley(
        type            = "5M",
        teeth           = 20,
        belt_width      = 10,
        bore_d          = 8,
        d_flat          = 8,
        hub_d           = 20,
        hub_h           = 7,
        flange_thickness = 1.5,
        flange_overhang  = 1.5,
        set_screw_d     = 3.2,
        anchor          = BOTTOM
    );

// Idler/tensioner and carriage reference geometry.
move([30, 0, 20])
    idler_tensioner();
move([32, 0, 48])
    carriage();
