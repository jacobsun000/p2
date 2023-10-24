//CSCI 5611 project2-p2
//Author: Stephen Guy, Jianing Wen
    
//Set inital conditions
float w = 40;
float h = 40;
float l = 40;
float w1= 20;
float h1 = 20;
float l1 = 20;
//float w2= 50;
//float h2 = 200;
float box_bounce = 0.8; //Coef. of restitution

float mass = 1;                         //Resistance to change in momentum/velocity
Vec3 rot_inertia = new Vec3(mass*(h*h+l*l)/12*20, mass*(w*w+l*l)/12*20, mass*(w*w+h*h)/12*20);  //Resistance to change in angular momentum/angular velocity
float mass1 = 0.8;
Vec3 rot_inertia1 = new Vec3(mass1*(h1*h1+l1*l1)/12, mass1*(w1*w1+l1*l1)/12, mass1*(w1*w1+h1*h1)/12);

Vec3 momentum = new Vec3(0,0,0);          //Speed the box is translating (derivative of position)
Vec3 momentum1 = new Vec3(0,0,0);
//float angular_momentum = 0;             //Speed the box is rotating (derivative of angle)
//float angular_momentum1 = 0;
Vec3 angular_momentum = new Vec3(0,0,0);         
Vec3 angular_momentum1 = new Vec3(0,0,0);

Vec3 center = new Vec3(500,200,200);        //Current position of center of mass
Vec3 center1 = new Vec3(800,300,200);
float angle = 0.4; /*radians*/          //Current rotation amount (orientation)
float angle1 = 0.4;

float radius = 104;

Vec3 total_force = new Vec3(0,0,0);       //Forces change position (center of mass)
Vec3 total_force1 = new Vec3(0,0,0);
//float total_torque = 0;                 //Torques change orientation (angle)
//float total_torque1 = 0;
Vec3 total_torque = new Vec3(0,0,0);
Vec3 total_torque1 = new Vec3(0,0,0);

Vec3 p1,p2,p3,p4,p5,p6,p7,p8;          //2 boxes: 4 corners of the box -- computed in updateCornerPositions()
Vec3 p11,p21,p31,p41,p51,p61,p71,p81;

int windows_x=1200;
int windows_y=800;
int windows_z=800;

int arrow_dir = 0;

void setup(){
  size(1200,800,P3D);
}

//----------
// Physics Functions
void apply_force(Vec3 force, Vec3 applied_position){
  total_force.add(force);
  Vec3 displacement = applied_position.minus(center);
  total_torque = cross(displacement, force);
}

void update_physics(float dt){
  //Update center of mass
  momentum.add(total_force.times(dt));     //Linear Momentum = Force * time
  Vec3 box_vel = momentum.times(1.0/mass); //Velocity = Momentum / mass
  center.add(box_vel.times(dt));           //Position += Vel * time
  
  //TODO: update rotation
    //Angular Momentum = Torque * time
    //Angular Velocity = (Angular Momentum)/(Rotational Inertia)
    //Orientation += (Angular Velocity) * time
   angular_momentum = angular_momentum.plus(total_torque.times(dt));
   //float box_avel = angular_momentum/rot_inertia;
   Vec3 box_avel = new Vec3(angular_momentum.x/rot_inertia.x, angular_momentum.y/rot_inertia.y, angular_momentum.z/rot_inertia.z);
   angle += box_avel.length()*dt;
  
  //Reset forces and torques
  total_force = new Vec3(0,0.98*3,0); //Set forces to 0 after they've been applied
  /*TODO*/ //Set torques to 0 after the forces have been applied
  total_torque = new Vec3(0,0,0);
}

void update_physics1(float dt){
  //Update center of mass
  momentum1.add(total_force1.times(dt));     //Linear Momentum = Force * time
  Vec3 box_vel1 = momentum1.times(1.0/mass1); //Velocity = Momentum / mass
  center1.add(box_vel1.times(dt));           //Position += Vel * time
  
  //TODO: update rotation
    //Angular Momentum = Torque * time
    //Angular Velocity = (Angular Momentum)/(Rotational Inertia)
    //Orientation += (Angular Velocity) * time
   angular_momentum1 = angular_momentum1.plus(total_torque1.times(dt));
   //float box_avel1 = angular_momentum1.length()/rot_inertia1;
   Vec3 box_avel1 = new Vec3(angular_momentum1.x/rot_inertia1.x, angular_momentum1.y/rot_inertia1.y, angular_momentum1.z/rot_inertia1.z);
   angle1 += box_avel1.length()*dt;
  
  //Reset forces and torques
  total_force1 = new Vec3(0,0.98*3,0); //Set forces to 0 after they've been applied
  /*TODO*/ //Set torques to 0 after the forces have been applied
  total_torque1 = new Vec3(0,0,0);
}


class ColideInfo{
  public boolean hit = false;
  public Vec3 hitPoint = new Vec3(0,0,0);
  public Vec3 objectNormal =  new Vec3(0,0,0);
}


void updateCornerPositions(){
  // Object 1
  Vec3 right = new Vec3(cos(angle), sin(angle), 0).times(w / 2);
  Vec3 up = new Vec3(-sin(angle), cos(angle), 0).times(-h / 2);
  Vec3 forward = new Vec3(0, 0, 1).times(l / 2);
  p1 = center.plus(right).plus(up).plus(forward);
  p2 = center.plus(right).minus(up).plus(forward);
  p3 = center.minus(right).plus(up).plus(forward);
  p4 = center.minus(right).minus(up).plus(forward);
  p5 = center.plus(right).plus(up).minus(forward);
  p6 = center.plus(right).minus(up).minus(forward);
  p7 = center.minus(right).plus(up).minus(forward);
  p8 = center.minus(right).minus(up).minus(forward);
  
  // Object 2
  Vec3 right1 = new Vec3(cos(angle1), sin(angle1), 0).times(w / 2);
  Vec3 up1 = new Vec3(-sin(angle1), cos(angle1), 0).times(-h / 2);
  Vec3 forward1 = new Vec3(0, 0, 1).times(l / 2);
  p11 = center1.plus(right1).plus(up1).plus(forward1);
  p21 = center1.plus(right1).minus(up1).plus(forward1);
  p31 = center1.minus(right1).plus(up1).plus(forward1);
  p41 = center1.minus(right1).minus(up1).plus(forward1);
  p51 = center1.plus(right1).plus(up1).minus(forward1);
  p61 = center1.plus(right1).minus(up1).minus(forward1);
  p71 = center1.minus(right1).plus(up1).minus(forward1);
  p81 = center1.minus(right1).minus(up1).minus(forward1);

}

ColideInfo collisionTest(){
  updateCornerPositions(); // Compute the corner positions for both objects

  ColideInfo info = new ColideInfo();
  
  // Check if any of the corners collide with the walls
  if (p1.x > windows_x){info.hitPoint = p1;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p2.x > windows_x){info.hitPoint = p2;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p3.x > windows_x){info.hitPoint = p3;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p4.x > windows_x){info.hitPoint = p4;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p5.x > windows_x){info.hitPoint = p5;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p6.x > windows_x){info.hitPoint = p6;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p7.x > windows_x){info.hitPoint = p7;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p8.x > windows_x){info.hitPoint = p8;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  
  if (p11.x > windows_x){info.hitPoint = p11;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p21.x > windows_x){info.hitPoint = p21;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p31.x > windows_x){info.hitPoint = p31;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p41.x > windows_x){info.hitPoint = p41;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p51.x > windows_x){info.hitPoint = p51;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p61.x > windows_x){info.hitPoint = p61;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p71.x > windows_x){info.hitPoint = p71;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p81.x > windows_x){info.hitPoint = p81;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  
  // Check for collision with the left wall
  if (p1.x < 0){info.hitPoint = p1;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p2.x < 0){info.hitPoint = p2;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p3.x < 0){info.hitPoint = p3;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p4.x < 0){info.hitPoint = p4;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p5.x < 0){info.hitPoint = p5;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p6.x < 0){info.hitPoint = p6;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p7.x < 0){info.hitPoint = p7;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p8.x < 0){info.hitPoint = p8;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  
  if (p11.x < 0){info.hitPoint = p11;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p21.x < 0){info.hitPoint = p21;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p31.x < 0){info.hitPoint = p31;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p41.x < 0){info.hitPoint = p41;info.hit = true;info.objectNormal = new Vec3(1, 0, 0);}
  if (p51.x < 0){info.hitPoint = p51;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p61.x < 0){info.hitPoint = p61;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p71.x < 0){info.hitPoint = p71;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}
  if (p81.x < 0){info.hitPoint = p81;info.hit = true;info.objectNormal = new Vec3(-1, 0, 0);}

  // Check for collision with the ceiling (y-axis)
  if (p1.y > windows_y){center.y -= p1.y+windows_y+0.01;info.hitPoint = p1;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p2.y > windows_y){center.y -= p2.y+windows_y+0.01;info.hitPoint = p2;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p3.y > windows_y){center.y -= p3.y+windows_y+0.01;info.hitPoint = p3;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p4.y > windows_y){center.y -= p4.y+windows_y+0.01;info.hitPoint = p4;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p5.y > windows_y){center.y -= p5.y+windows_y+0.01;info.hitPoint = p5;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p6.y > windows_y){center.y -= p6.y+windows_y+0.01;info.hitPoint = p6;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p7.y > windows_y){center.y -= p7.y+windows_y+0.01;info.hitPoint = p7;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p8.y > windows_y){center.y -= p8.y+windows_y+0.01;info.hitPoint = p8;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  
  if (p11.y > windows_y){center.y -= p11.y+windows_y+0.01;info.hitPoint = p11;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p21.y > windows_y){center.y -= p21.y+windows_y+0.01;info.hitPoint = p21;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p31.y > windows_y){center.y -= p31.y+windows_y+0.01;info.hitPoint = p31;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p41.y > windows_y){center.y -= p41.y+windows_y+0.01;info.hitPoint = p41;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p51.y > windows_y){center.y -= p51.y+windows_y+0.01;info.hitPoint = p51;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p61.y > windows_y){center.y -= p61.y+windows_y+0.01;info.hitPoint = p61;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p71.y > windows_y){center.y -= p71.y+windows_y+0.01;info.hitPoint = p71;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  if (p81.y > windows_y){center.y -= p81.y+windows_y+0.01;info.hitPoint = p81;info.hit = true;info.objectNormal = new Vec3(0, -1, 0);}
  
  // Check for collision with the floor (z-axis)
  if (p1.z > windows_z){info.hitPoint = p1;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p2.z > windows_z){info.hitPoint = p2;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p3.z > windows_z){info.hitPoint = p3;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p4.z > windows_z){info.hitPoint = p4;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p5.z > windows_z){info.hitPoint = p5;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p6.z > windows_z){info.hitPoint = p6;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p7.z > windows_z){info.hitPoint = p7;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p8.z > windows_z){info.hitPoint = p8;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  
  if (p11.z > windows_z){info.hitPoint = p11;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p21.z > windows_z){info.hitPoint = p21;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p31.z > windows_z){info.hitPoint = p31;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p41.z > windows_z){info.hitPoint = p41;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p51.z > windows_z){info.hitPoint = p51;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p61.z > windows_z){info.hitPoint = p61;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p71.z > windows_z){info.hitPoint = p71;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}
  if (p81.z > windows_z){info.hitPoint = p81;info.hit = true;info.objectNormal = new Vec3(0, 0, -1);}

  return info;
}


//Updates momentum & angular_momentum based on collision using an impulse based method
//This method assumes you hit an immovable obstacle which simplifies the math
// see Eqn 8-18 of here: https://www.cs.cmu.edu/~baraff/sigcourse/notesd2.pdf
// or Eqn 9 here: http://www.chrishecker.com/images/e/e7/Gdmphys3.pdf
//for obstacle-obstacle collisions.
void resolveCollision(Vec3 hit_point, Vec3 hit_normal, float dt){
  Vec3 r = hit_point.minus(center);
  Vec3 arbitraryVector = new Vec3(1, 0, 0);
  Vec3 r_perp = perpendicular(r, arbitraryVector);
  Vec3 object_vel = momentum.times(1/mass);
  Vec3 object_angular_speed = new Vec3(angular_momentum.x/rot_inertia.x, angular_momentum.y/rot_inertia.y, angular_momentum.z/rot_inertia.z);
  Vec3 point_vel = object_vel.plus(r_perp.times(object_angular_speed.length()));
  println(point_vel,object_vel);
  float j = -(1+box_bounce)*dot(point_vel,hit_normal);
  j /= (1/mass + pow(dot(r_perp,hit_normal),2)/rot_inertia.length());
 
  Vec3 impulse = hit_normal.times(j);
  momentum.add(impulse);
  //println(momentum);
  Vec3 helperVector = new Vec3(1,1,1);
  angular_momentum = angular_momentum.plus(helperVector.times(dot(r_perp,impulse)));
  update_physics(1.01*dt); //A small hack, better is just to move the object out of collision directly
}

void draw(){
  background(200);
  float dt = 1 / frameRate;
  update_physics(dt);
  update_physics1(dt);
  
  boolean clicked_box = mousePressed && point_in_box(new Vec3(mouseX, mouseY, center.z), center, w, h, l, angle);
  //println(mousePressed);
  //println(clicked_box);
  
  if (clicked_box) {
    Vec3 force = new Vec3(1,0,0).times(100);
    Vec3 hit_point = new Vec3(mouseX, mouseY,0);
    apply_force(force, hit_point);
  }
  
  ColideInfo info = collisionTest(); //TODO: Use this result below
  
  //TODO the these values based on the results of a collision test
  Boolean hit_something = false; //Did I hit something?
  if (hit_something){
    Vec3 hit_point = new Vec3(0,0,0);
    Vec3 hit_normal = new Vec3(0,0,0);
    resolveCollision(hit_point,hit_normal,dt);
  }
  
  Vec3 box_vel = momentum.times(1/mass);
  float box_speed = box_vel.length();
  Vec3 box_agular_velocity = new Vec3(angular_momentum.x/rot_inertia.x, angular_momentum.y/rot_inertia.y, angular_momentum.z/rot_inertia.z);
  float linear_kinetic_energy = .5*mass*box_speed*box_speed;
  float rotational_kinetic_energy = .5*rot_inertia.length()*box_agular_velocity.length()*box_agular_velocity.length();
  float total_kinetic_energy = linear_kinetic_energy+rotational_kinetic_energy;
  //println("Box Vel:",box_vel,"ang vel:",box_agular_velocity,"linear KE:",linear_kinetic_energy,"rotation KE:",rotational_kinetic_energy,"Total KE:",total_kinetic_energy);
  
  fill(255);
  if (clicked_box){
    fill(255,200,200);
  }
    
  // Draw 3D box
  pushMatrix();
  translate(center.x, center.y, center.z);
  rotate(angle); // Rotate the view for a better 3D perspective
  box(w, h, l);
  popMatrix();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  
  pushMatrix();
  translate(center1.x, center1.y, center1.z);
  rotate(angle1); // Rotate the view for a better 3D perspective
  box(w1, h1, l1);
  popMatrix();
  
  fill(0);
  
  
  //circle(p1.x, p1.y, 4.0);
  //circle(p2.x, p2.y, 4.0);
  //circle(p3.x, p3.y, 4.0);
  //circle(p4.x, p4.y, 4.0);
  //circle(p5.x, p4.y, 4.0);
  //circle(p6.x, p4.y, 4.0);
  //circle(p7.x, p4.y, 4.0);
  //circle(p8.x, p4.y, 4.0);
  
  drawArrow(mouseX, mouseY, 0, 100, 0);
}


void keyPressed(){
  if (key == 'r'){
    center = new Vec3(500,200,200);    
    center1 = new Vec3(800,300,400);
    momentum = new Vec3(0,0,0);
    angular_momentum = new Vec3(0,0,0);
    angle = radians(90);
    println("Resetting the simulation");
    return;
  }
}

//Returns true iff the point 'point' is inside the box
boolean point_in_box(Vec3 point, Vec3 box_center, float box_w, float box_h, float box_l, float box_angle){
  Vec3 relative_pos = point.minus(box_center);
  println(relative_pos.x + " " + relative_pos.y + " " + relative_pos.z);
  Vec3 box_right = new Vec3(cos(box_angle),0, sin(box_angle));
  Vec3 box_up = new Vec3(0,1,0);
  Vec3 box_forward = cross(box_right, box_up); // Assuming forward is along the z-axis
  
  float point_right = dot(relative_pos,box_right);
  float point_up = dot(relative_pos,box_up);
  float point_forward = dot(relative_pos, box_forward);
  //println(abs(point_right));
  //println(box_w/2);
  //println(abs(point_up) < box_h/2);
  //println(abs(point_forward) < box_l / 2);
  if ((abs(point_right) < box_w/2) && (abs(point_up) < box_h/2) && (abs(point_forward) < box_l / 2))
    return true;
  return false;
}

void drawArrow(int cx, int cy, int cz, int len, float angle){
  pushMatrix();
  translate(cx, cy, cz);
  rotate(radians(angle));
  line(-len,-50,0, -50);
  line(0, -50,  - 8, -48);
  line(0, -50,  - 8, -42);
  popMatrix();
}
