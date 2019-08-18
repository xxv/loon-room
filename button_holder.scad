button_hole_diameter = 22.5;
button_count = 5;
button_spacing = 30;
rotation_offset = 90;
plate_diameter = 140;
plate_rounding_radius = button_hole_diameter;

mounting_hole_diameter = 5;
mounting_hole_inset = 10;

rear_housing_wall_thickness = 3;
rear_depth = 40;
rear_housing_diameter = 100;

rear_screw_hole_diameter = 3.3;

rear_nut_diameter = 6.35;
rear_screw_mount_offset = 44.7;
rear_screw_center_offset = rear_nut_diameter/2;


control_board = [86, 36];

$fn = 120;
smidge = 0.1;

preview();

*rear_housing();


module preview() {
  linear_extrude(height=3)
    front_plate();

  rear_housing();
  control_board();
}

module rear_housing() {
  translate([0, 0, -rear_depth]) {
    linear_extrude(height=rear_depth)
      difference() {
        rounded_polygon_2d(button_count, rear_housing_diameter, plate_rounding_radius*2);
        rounded_polygon_2d(button_count, rear_housing_diameter - rear_housing_wall_thickness, plate_rounding_radius*2);

      }

    translate([0, 0, -rear_housing_wall_thickness])
      linear_extrude(height=rear_housing_wall_thickness)
        rounded_polygon_2d(button_count, rear_housing_diameter, plate_rounding_radius*2);
  }

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
            cylinder(r1=0, r2=flange_radius, h=flange_height, $fn=6);

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
  # translate([0, 0, -1])
  translate([-control_board.x/2, -button_spacing -control_board.y - button_hole_diameter/2, 0])
  color("red")
    square(control_board);
}

