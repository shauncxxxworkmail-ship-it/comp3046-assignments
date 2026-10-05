// ============================================================
// roller.scad - 34T HTD5M 滾輪 (用兩粒 MR63 軸承)
// ============================================================
$fn = 64;

pulley_teeth  = 34;
pulley_pitch  = 5.0;
tooth_depth   = 2.06;
groove_r      = 1.49;
pld           = 0.5715;

pulley_w      = 10.0;
flange_t      = 1.5;
flange_over   = 1.5;

bearing_od    = 8.0;
bearing_id    = 3.0;
bearing_h     = 4.0;

pitch_r   = (pulley_teeth * pulley_pitch) / (2 * PI);
outer_r   = pitch_r - pld;
groove_off= outer_r - tooth_depth + groove_r;
flange_r  = outer_r + flange_over;
fn_val    = max(48, pulley_teeth * 6);
total_h   = pulley_w + flange_t * 2;

difference() {
    union() {
        translate([0, 0, -pulley_w/2 - flange_t])
            cylinder(r = flange_r, h = flange_t, $fn = fn_val);
        difference() {
            cylinder(r = outer_r, h = pulley_w, center = true, $fn = fn_val);
            for (i = [0 : pulley_teeth - 1])
                rotate([0, 0, i * 360 / pulley_teeth])
                    translate([groove_off, 0, 0])
                        cylinder(r = groove_r, h = pulley_w + 0.1,
                                 center = true, $fn = 16);
        }
        translate([0, 0, pulley_w/2])
            cylinder(r = flange_r, h = flange_t, $fn = fn_val);
    }
    cylinder(d = bearing_od + 0.1, h = total_h + 2, center = true);
    cylinder(d = bearing_id + 0.2, h = total_h + 4, center = true);
}