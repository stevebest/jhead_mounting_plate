width = 70;
depth = 28;
thickness = 8;

screw_mount = 3;       // diameter of the mounting screws
screw_assemble = 3;    // diameter of assembling screws
screw_assemble_head = 6;

mount_separation = 50; // distance between mount points
mount_allowance = 2;   // 

jhead_R = 15 / 2;      // radius of the JHead assembly
jhead_r = 12 / 2;      // radius of JHead at the mount groove
jhead_d = 4.5;         // width of the groove
jhead_D = 10 - jhead_d;// width of the neck

module main_body(x = width, y = depth, z = thickness) {
	difference() {
		translate([0, 0, z / 2]) cube(size = [x, y, z], center = true);

		// JHead mounting point
		translate([0, 0, jhead_d])
			cylinder(h = z - jhead_d, r = jhead_R, $fn = 32);
		translate([0, 0, 0])
			cylinder(h = jhead_d, r = jhead_r, $fn = 32);

		// screw holes for attachment to extruder
		mount_holes(mount_separation / 2);

		// screw holes for assembling main body and clamp
		assemble_holes(x, y, z);
	};
}

module mount_holes(s) {
	translate([-s, 0, 0])
		mount_hole();
	translate([ s, 0, 0])
		mount_hole();
}

module mount_hole() {
	a = mount_allowance;
	d = screw_mount;
	z = thickness;

	translate([0, 0, z / 2])
		cube([a, d, z], center = true);

	translate([-a/2, 0, 0])
		cylinder(h = z, d = d, $fn = 16);
	translate([ a/2, 0, 0])
		cylinder(h = z, d = d, $fn = 16);
}

module assemble_holes(x = width, y = depth, z = thickness) {
	s = jhead_R + screw_assemble;
	translate([s, -y/2, z/2])
	rotate([-90, 0, 0])
		assemble_hole(x, y, z);
	translate([-s, -y/2, z/2])
	rotate([-90, 0, 0])
		assemble_hole(x, y, z);
}

module assemble_hole(x, y, z) {
	cylinder(h = y, d = screw_assemble, $fn = 16);
	translate([0, 0, -1])
		cylinder(h = 3, d = screw_assemble_head, $fn = 16);
	translate([0, 0, y - 4])
		cylinder(h = 5, d = screw_assemble_head, $fn = 6);
}


module clamp_shape(x, y, z) {
	translate([0, -y/2, z/2])
		cube([y + 2, y, z], center = true);
}

module clamp(x, y, z) {
	intersection () {
		main_body(x, y, z);
		clamp_shape(x, y, z);
	}
}


module main(x = width, y = depth, z = thickness) {
	difference () {
		main_body(x, y, z);
		clamp_shape(x, y, z);
	}

	translate([0, -y, 0])
		clamp(x, y, z);
}

main();
