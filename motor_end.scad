use <x_carriage.scad>;
use <timing_belt.scad>;

$fa = 3;   // Minimum angle for circle segments.
$fs = 0.5; // Minimum size for circle segments.

aluminum = [0.9, 0.9, 0.9];
steel = [0.8, 0.8, 0.9];

slot_length = 20;
slot_height = 3.2;

ear_right = 37 + slot_length;
end_idler_x = 25 + ear_right;
end_idler_x2 = 100;
end_idler_z = 40;
idler_x = -100;
idler_z = 13;

motor_x = 37 + slot_length/2;
motor_z = (idler_z + end_idler_z) / 2;
motor_screw = 15.5;
motor_diagonal = sqrt(2 * motor_screw * motor_screw);

ear_radius = 10;
ear_radius_inner = 7;

zaxis_y = -12;

// X axis smooth rods
color(steel) {
  translate([-100, 0, -35]) rotate([0, 90, 0])
	  cylinder(r=4, h=240, center=true);
  translate([-100, 0, 35]) rotate([0, 90, 0])
	  cylinder(r=4, h=240, center=true);
}

// Z axis threaded rods
color(0.7 * steel) {
  translate([-30, zaxis_y, 0]) cylinder(r=4, h=200, center=true);
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
translate([end_idler_x, 0, -idler_z]) bearing(6, 17, 6);
translate([end_idler_x, 0, idler_z]) bearing(6, 17, 6);
translate([end_idler_x, 0, -end_idler_z]) bearing(6, 17, 6);
translate([end_idler_x, 0, end_idler_z]) bearing(6, 17, 6);

// Timing belt
module motor_belt_loop() {
	translate([(end_idler_x - end_idler_x2) / 2, 0, end_idler_z + 9])
		rotate([0, 180, 0]) timing_belt(end_idler_x + end_idler_x2);
	translate([(end_idler_x + idler_x) / 2, 0, idler_z - 9])
		timing_belt(end_idler_x - idler_x);
	translate([(end_idler_x + motor_x) / 2, 0, idler_z + 9])
		rotate([0, 180, 0]) timing_belt(end_idler_x - motor_x);
	translate([(end_idler_x + motor_x) / 2, 0, end_idler_z - 9])
		timing_belt(end_idler_x - motor_x);
}

motor_belt_loop();
mirror([0, 0, 1]) motor_belt_loop();

module nema17(length) {
	color([0.4, 0.4, 0.4]) {
		translate([0, -length/2-17, 0])
			intersection() {
			cube([42, length, 42], center=true);
			rotate([0, 45, 0]) cube([53, length, 53], center=true);
		}
		translate([0, -17, 0]) rotate([90]) cylinder(r=11, h=4, center=true);
	}
	color(steel)
	translate([0, -length/2-7, 0]) rotate([90, 0, 0])
		cylinder(r=2.5, h=length+21, center=true);
	for (a = [0, 90, 180, 270]) rotate([0, a, 0]) {
		color([0.2, 0.2, 0.2]) translate([motor_screw, -10, motor_screw])
			rotate([90, 0, 0]) cylinder(r=2.5, h=4, center=true);
		color(steel) translate([motor_screw, -11.8, motor_screw])
			rotate([90, 0, 0]) cylinder(r=5, h=0.5, center=true);
	}
	rotate([180, 0, 0]) pulley(5, 16, 7, 18, 1);
}

// Stepper motors
translate([motor_x, -0.1, motor_z]) nema17(47);
translate([motor_x, -0.1, -motor_z]) nema17(47);

module smooth_rod_clamp() {
	difference() {
		union() {
			translate([0, -4, 0]) cube([66, 26, 16], center=true);
		}
		translate([0, 7, 0]) cube([80, 10, 5], center=true);
		rotate([0, 90, 0]) cylinder(r=4.6, h=80, center=true, $fn=6);
		translate([0, 8, 26]) rotate([15, 0, 0]) rotate([0, 90, 0])
		    cylinder(r=20, h=80, center=true, $fn=12);
		translate([0, 8, -26]) rotate([15, 0, 0]) rotate([0, 90, 0])
		    cylinder(r=20, h=80, center=true, $fn=12);

		// Threaded nut hole
		translate([-15, -12, 0]) cube([13, 13, 7], center=true);
	}
}

module z_carriage() {
	difference() {
		union() {
			translate([0, 0, -35]) smooth_rod_clamp();
			translate([0, 0, 35]) smooth_rod_clamp();
			translate([0, -14.5, 0]) cube([66, 5, 55], center=true);
		}
		translate([-15, -12, 0]) cylinder(r=5.5, h=100, center=true, $fn=6);
	}
}

module motor_slots() {
	minkowski() {
		cube([slot_length, 0.01, 0.01], center=true);
		rotate([90]) cylinder(r=11, h=10, center=true);
	}
	translate([-motor_screw, 0, -motor_screw])
		cube([slot_length, 20, slot_height], center=true);
	translate([-motor_screw, 0, motor_screw])
		cube([slot_length, 20, slot_height], center=true);
	translate([motor_screw, 0, -motor_screw])
		cube([slot_length, 20, slot_height], center=true);
	translate([motor_screw, 0, motor_screw])
		cube([slot_length, 20, slot_height], center=true);
}

// Right-hand X end (with stepper motors)
color([0, 1, 0])
difference() {
	union() {
		translate([-15, 0, 0]) z_carriage();
		translate([end_idler_x-ear_right/2, -11, 0]) minkowski() {
			cube([ear_right, 11, 2*end_idler_z], center=true);
			rotate([90, 0, 0]) cylinder(r=ear_radius, h=1, center=true);
		}
	}
	translate([end_idler_x-ear_right/2-7, 3, motor_z]) minkowski() {
		cube([ear_right-14, 29, end_idler_z-idler_z], center=true);
		rotate([90, 0, 0]) cylinder(r=ear_radius_inner, h=1, center=true);
	}
	translate([end_idler_x-ear_right/2-7, 3, -motor_z]) minkowski() {
		cube([ear_right-14, 29, end_idler_z-idler_z], center=true);
		rotate([90, 0, 0]) cylinder(r=ear_radius_inner, h=1, center=true);
	}
	translate([motor_x, -14.5, motor_z]) motor_slots();
	translate([motor_x, -14.5, -motor_z]) motor_slots();
}
