use <x_carriage.scad>;
use <timing_belt.scad>;
use <motor_end.scad>;

$fa = 3;   // Minimum angle for circle segments.
$fs = 0.5; // Minimum size for circle segments.

aluminum = [0.9, 0.9, 0.9];
steel = [0.8, 0.8, 0.9];

end_idler_z = 40;
honeycomb_step = end_idler_z / 4.5;
ear_left = 2 * honeycomb_step;
ear_radius = 10;

end_idler_x = 200;
end_idler_x2 = 25 + ear_left;
idler_x = -200;
idler_z = 1.5*honeycomb_step;

zaxis_y = -12;

// X axis smooth rods
color(steel) {
  translate([100, 0, -35]) rotate([0, 90, 0])
	  cylinder(r=4, h=240, center=true);
  translate([100, 0, 35]) rotate([0, 90, 0])
	  cylinder(r=4, h=240, center=true);
}

// Z axis threaded rods
color(0.7 * steel) {
  translate([30, zaxis_y, 0]) cylinder(r=4, h=200, center=true);
}

// Z axis smooth rods
color(steel) {
  translate([0, zaxis_y, 0]) cylinder(r=4, h=200, center=true);
}

// Z axis linear bearings
zaxis_bearing_z = 28;
translate([0, zaxis_y, zaxis_bearing_z]) lm8uu();
translate([0, zaxis_y, -zaxis_bearing_z]) lm8uu();

// X axis end timing belt bearings
translate([-end_idler_x2, 0, -idler_z]) bearing(6, 17, 6);
translate([-end_idler_x2, 0, idler_z]) bearing(6, 17, 6);
translate([-end_idler_x2, 0, -end_idler_z]) bearing(6, 17, 6);
translate([-end_idler_x2, 0, end_idler_z]) bearing(6, 17, 6);

// Timing belt
module belt_loop() {
	translate([(end_idler_x - end_idler_x2) / 2, 0, end_idler_z + 9])
		rotate([0, 180, 0]) timing_belt(end_idler_x + end_idler_x2);
	translate([-(end_idler_x2 + idler_x) / 2, 0, idler_z - 9])
		timing_belt(end_idler_x2 - idler_x);
	translate([-end_idler_x2 - 9, 0, (idler_z + end_idler_z) / 2])
		rotate([0, 90, 0]) timing_belt(end_idler_z - idler_z);
}

belt_loop();
mirror([0, 0, 1]) belt_loop();

module honeycomb(count) {
	for (i = [0 : count]) {
		translate([0, 0, honeycomb_step*(i-count/2)]) rotate([90])
			cylinder(r=3, h=50, center=true);
	}
}

// Left-hand X end (without stepper motors)
color([0, 1, 0])
difference() {
	union() {
		translate([15, 0, 0]) mirror([1, 0, 0]) z_carriage();
		translate([-end_idler_x2+ear_left/2, -11, 0]) minkowski() {
			cube([ear_left, 11, 2*end_idler_z], center=true);
			rotate([90, 0, 0]) cylinder(r=ear_radius, h=1, center=true);
		}
	}
	translate([-end_idler_x2, 0, 0]) honeycomb(9);
	translate([-end_idler_x2+honeycomb_step, 0, 0]) honeycomb(9);
	translate([-end_idler_x2+2*honeycomb_step, 0, 0]) honeycomb(9);
}
