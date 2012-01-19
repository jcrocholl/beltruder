use <pulley.scad>;

$fa = 3;   // Minimum angle for circle segments.
$fs = 0.5; // Minimum size for circle segments.

aluminum = [0.9, 0.9, 0.9];
steel = [0.8, 0.8, 0.9];

linear_x = 24;
hotend_x = 3;
idler_x = 30;
idler_z = 13;

module lm8uu() {
	color(steel)
	difference() {
		cylinder(h=25, r=7.5, center=true);
		cylinder(h=30, r=4, center=true);
	}
}

module bearing(id, od, w) {
	color(steel)
	rotate([90, 0, 0])
	difference() {
		cylinder(h=w, r=od/2, center=true);
		cylinder(h=w*2, r=id/2, center=true);
	}
}

module linearclip() {
     union() {
		difference() {
			intersection() {
				translate([0, -6, 10]) rotate([0, 90, 0])
					cylinder(r=20, h=75, center=true);
				translate([0, -6, -10]) rotate([0, 90, 0])
					cylinder(r=20, h=75, center=true);
				translate([0, -3, 0]) rotate([0, 90, 0])
					cylinder(r=10.3, h=75, center=true);
			}
			rotate([0, 90, 0]) cylinder(r=7.5, h=80, center=true);
			translate([0, 13, 0]) cube([80, 20, 22], center=true);
			translate([0, -20, 0]) cube([80, 20, 22], center=true);
		}
		translate([0, -7.5, -0]) cube([75, 5, 14], center=true);
	}
}

support_radius = 30;
support_x = 26.5;
jaw_x = 18;

// Carriage body
color([0, 1, 0])
difference() {
	union() {
		// Main body plate
		translate([0, -7.5, 0]) cube([75, 5, 60], center=true);

		// Linear bearing holder clips
		translate([0, 0, 35]) linearclip();
		translate([0, 0, -35]) rotate([-90, 0, 0]) linearclip();

		// Timing belt idler holders
		translate([-idler_x, -4.5, -idler_z]) rotate([90, 0, 0])
		    cylinder(h=3, r1=4.5, r2=7.5, center=true);
		translate([-idler_x, -4.5, idler_z]) rotate([90, 0, 0])
			cylinder(h=3, r1=4.5, r2=7.5, center=true);
		translate([idler_x, -4.5, -idler_z]) rotate([90, 0, 0])
			cylinder(h=3, r1=4.5, r2=7.5, center=true);
		translate([idler_x, -4.5, idler_z]) rotate([90, 0, 0])
			cylinder(h=3, r1=4.5, r2=7.5, center=true);

		intersection() {
			union() {
				// Extruder barrel (the case around the hobbed bolt)
				translate([0, -20, 0]) rotate([90])
					cylinder(r=12, h=30, center=true);

				// Barrel support
				difference() {
					translate([-22.5, -20, 0]) cube([30, 30, 30], center=true);
					translate([-support_x, -20, support_radius+2.5])
						rotate([90])
						cylinder(r=support_radius, h=50, center=true);
					translate([-support_x, -20, -support_radius-2.5])
						rotate([90])
						cylinder(r=support_radius, h=50, center=true);
					translate([-2*support_x, -20, -7.5])
						cube([2*support_x, 20, 10], center=true);
					translate([-2*support_x, -20, 7.5])
						cube([2*support_x, 20, 10], center=true);
				}
			}
			translate([0, 30, 0]) cylinder(r=65, h=100, center=true);
		}

		// Groovemount holder
		intersection() {
			union() {
				translate([0, -18, -20]) cube([75, 20, 5], center=true);
				translate([jaw_x, -20, -22]) rotate([90])
					cylinder(r=10, h=6, center=true);
			}
			translate([0, 38, 0]) cylinder(r=65, h=45, center=true);
		}
	}
	// Hobbed bolt hole
	translate([0, -20, 0]) rotate([90, 0, 0])
		cylinder(h=40, r=7, center=true);

	// Hobbed bolt bearing holders
	translate([0, -7, 0]) rotate([90, 0, 0])
	    cylinder(r=8.5, h=8, center=true);
	translate([0, -33, 0]) rotate([90, 0, 0])
		cylinder(r=8.56, h=8, center=true);

	// Timing belt idler screw holes
	translate([-idler_x, -5.5, -idler_z]) rotate([90, 0, 0])
	    cylinder(h=50, r=3, center=true);
	translate([-idler_x, -5.5, idler_z]) rotate([90, 0, 0])
		cylinder(h=50, r=3, center=true);
	translate([idler_x, -5.5, -idler_z]) rotate([90, 0, 0])
		cylinder(h=50, r=3, center=true);
	translate([idler_x, -5.5, idler_z]) rotate([90, 0, 0])
		cylinder(h=50, r=3, center=true);

	// Zip tie tunnels
	translate([-linear_x, 0, -24]) cube([6, 30, 2], center=true);
	translate([-linear_x, 0, 24]) cube([6, 30, 2], center=true);
	translate([linear_x, 0, -24]) cube([6, 30, 2], center=true);
	translate([linear_x, 0, 24]) cube([6, 30, 2], center=true);

	// Extruder mouth
	translate([0, -20, -2]) cylinder(r=7, h=20, center=true);
	translate([10, -20, -2]) cube([20, 14, 20], center=true);
	translate([10, -20, 0]) cube([20, 19, 8], center=true);
	translate([10, -25, 0]) cube([6, 30, 20], center=true);

	// Filament hole and funnels
	translate([hotend_x, -20, 0]) cylinder(r=1, h=80, center=true);
	translate([hotend_x, -20, 11]) cylinder(r1=1, r2=5, h=5, center=true);
    translate([hotend_x, -20, -19]) cylinder(r1=1, r2=5, h=5, center=true);

	// Jaw tensioner
	translate([0, -25, 22]) cube([20, 30, 10], center=true);

	// Jaw tensioner hinge screw hole
	translate([jaw_x, -20, -15]) rotate([90])
		cylinder(r=1.5, h=60, center=true);
	translate([jaw_x, -13.5, -15]) rotate([90])
		cylinder(r=5, h=7, center=true);
	translate([jaw_x, -26.5, -15]) rotate([90])
		cylinder(r=5, h=7, center=true);
}

// Linear bearings
translate([-linear_x, 0, 35]) rotate([0, 90, 0]) lm8uu();
translate([-linear_x, 0, -35]) rotate([0, 90, 0]) lm8uu();
translate([linear_x, 0, 35]) rotate([0, 90, 0]) lm8uu();
translate([linear_x, 0, -35]) rotate([0, 90, 0]) lm8uu();

// Timing belt pulley
translate([0, 0, 0]) rotate([270]) pulley(6, 38.8, 7, 42, 1, 14, 14);

// Timing belt bearings
translate([-idler_x, 0, -idler_z]) bearing(6, 17, 6);
translate([idler_x, 0, -idler_z]) bearing(6, 17, 6);
translate([-idler_x, 0, idler_z]) bearing(6, 17, 6);
translate([idler_x, 0, idler_z]) bearing(6, 17, 6);

// Hobbed bolt
color(steel)
translate([0, -12, 0]) rotate([90, 0, 0]) cylinder(h=50, r=3, center=true);

// Extruder bearings
translate([0, -8, 0]) bearing(6, 17, 6);
translate([0, -32, 0]) bearing(6, 17, 6);
translate([12, -20, 0]) bearing(6, 17, 6);

module groovemount() {
	color([0.3, 0.3, 0.3])
	difference() {
		union() {
			cylinder(h=27, r=6, center=true);
			translate([0, 0, 11.5]) cylinder(h=4, r=8, center=true);
			translate([0, 0, 5]) cylinder(h=2, r=8, center=true);
		}
		cylinder(h=30, r=3, center=true);
	}
}

// Hotend
translate([hotend_x, -20, -36]) groovemount();

// Red filament
translate([hotend_x, -20, 0]) color([1, 0, 0])
	cylinder(r=1.75/2, h=100, center=true);
