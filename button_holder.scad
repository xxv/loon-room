button_hole_diameter = 22.5;
button_count = 5;
button_spacing = 30;
rotation_offset = 90;
plate_diameter = 140;
plate_rounding_radius = button_hole_diameter;

mounting_hole_diameter = 5;
mounting_hole_inset = 10;

rear_housing_wall_thickness = 3;
rear_depth = 65;
rear_housing_diameter = 110;

rear_screw_hole_diameter = 3.3;

rear_nut_diameter = 6.35;
rear_screw_mount_offset = rear_housing_diameter/2 - 6.25;
rear_screw_center_offset = rear_nut_diameter/2;


control_board = [36, 86];
control_board_offset_from_center = [0, -3];
control_board_standoff_height = 5;

$fn = 120;
smidge = 0.1;

*preview();

*front_plate();
rear_housing();

module preview() {
*  linear_extrude(height=3)
    front_plate();

  rear_housing();
  control_board();
}

module rear_housing_screw_mounts() {
  flange_height = 20;
  flange_radius = 8;
  mount_depth = 2;

  hole_diameter = rear_screw_hole_diameter;
  nut_diameter = rear_nut_diameter;
  screw_mount_offset = rear_screw_mount_offset;
  screw_center_offset = rear_screw_center_offset;

  // screw mounts
  difference() {
    for(rot = [0: 360/button_count : 360])
      rotate([0, 0, rot + rotation_offset + 360/button_count/2])
        translate([screw_mount_offset, 0, -flange_height]) {
          difference() {
            cylinder(r1=0, r2=flange_radius, h=flange_height, $fn=12);

            translate([screw_center_offset, 0, 0]) {
              cylinder(d=nut_diameter, h=flange_height-mount_depth, $fn=6);

              translate([0, 0, flange_height - mount_depth - smidge])
                cylinder(d=hole_diameter, h=mount_depth + smidge * 2);
            }
          }
        }

    translate([0, 0, -rear_depth + smidge])
      linear_extrude(height=rear_depth)
        rounded_polygon_2d(button_count, rear_housing_diameter - rear_housing_wall_thickness, plate_rounding_radius*2);
  }
}

module rear_housing() {
  usb_hole = [13, 13];
  usb_hole_z_offset = control_board_standoff_height - 1;

  translate([0, 0, -rear_depth]) {
    difference() {
      linear_extrude(height=rear_depth)
        difference() {
          rounded_polygon_2d(button_count, rear_housing_diameter, plate_rounding_radius*2);
          rounded_polygon_2d(button_count, rear_housing_diameter - rear_housing_wall_thickness*2, plate_rounding_radius*2);

        }

      translate([-usb_hole.x/2, -rear_screw_mount_offset, usb_hole_z_offset])
        cube([usb_hole.x, rear_housing_wall_thickness * 2, usb_hole.y]);
    }

    translate(control_board_offset_from_center)
      control_board_standoffs();

    translate([0, 0, -rear_housing_wall_thickness])
      linear_extrude(height=rear_housing_wall_thickness)
        rounded_polygon_2d(button_count, rear_housing_diameter, plate_rounding_radius*2);
  }

  rear_housing_screw_mounts();
}

module front_plate() {
  difference() {
    rounded_polygon_2d(button_count, plate_diameter, plate_rounding_radius*2);

    for(rot = [0 : 360/button_count : 360])
      rotate([0, 0, rot + rotation_offset])
      translate([button_spacing, 0])
        circle(d=button_hole_diameter);

    for(rot = [0 : 360/button_count : 360])
      rotate([0, 0, rot + rotation_offset])
      translate([plate_diameter/2 - mounting_hole_inset, 0])
        circle(d=mounting_hole_diameter);

    for(rot = [0 : 360/button_count : 360])
      rotate([0, 0, rot + rotation_offset + 360/button_count/2])
      translate([rear_screw_mount_offset+rear_screw_center_offset, 0])
        circle(d=rear_screw_hole_diameter);
  }
}

module rounded_polygon_2d(sides, diameter, rounding_diameter) {
  minkowski() {
    rotate([0, 0, rotation_offset])
      circle(d=diameter - rounding_diameter, $fn=sides);
    circle(d=rounding_diameter);
  }
}

module control_board() {
  usb_port = [12, 16, 11];
  usb_port_extends = 8;

  % color("red")
    translate(control_board_offset_from_center)
      translate([0, 0, -rear_depth + control_board_standoff_height]) {
        translate([-usb_port.x/2, -control_board.y/2-usb_port_extends, 0])
          cube(usb_port);
        translate([-control_board.x/2, -control_board.y/2, 0])
          linear_extrude(height=10)
          square(control_board);

      }
}

module control_board_standoffs() {
  spacing = [30, 80];
  diameter = 5;
  hole = 1.7;
  height = control_board_standoff_height;

  for(y = [-spacing.y/2:spacing.y:spacing.y/2])
    for(x = [-spacing.x/2:spacing.x:spacing.x/2])
      translate([x, y, 0])
        difference() {
          cylinder(d=diameter, h=height);
          cylinder(d=hole, h=height + smidge);
        }
}
