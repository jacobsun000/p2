// CSCI5611-HW2
// Author: Jianing Wen

//PrintWriter writer; // Declare a PrintWriter object to write the data into a csv file
PImage clothTex;
Camera camera;

// constants for simulation parameters, such as gravity, damping
Vec2 gravity = new Vec2(0, 9.81);
float ks = 1000;  //ks
float kv = 16; //damping
float kfric = 10.0;
  
// nodes.radius
float radius = 15 / 2;         //15 is 0.3 * scene_scale actually

// Scaling factor for the scene
float scene_scale = width / 10.0f;

// Physics Parameters
int num_relaxation_steps = 1; //sets  the  number  of  substeps  within  a  simulation  step  used  to  compute  the  physics (giving  you  an  effective  ∆t  of  less  than  0.05)
int num_steps = 10; //sets the  number  of  times  to  run  the  constraint  solver  per  substeps

// Ropes
int numNodes = 5;
float nodeMass = 1;
ArrayList<Rope> ropes = new ArrayList<Rope>();

// Link length
float linkLength = 1;
float totalLength = (numNodes - 1) * linkLength;

//for the obstacle
float COR = 0.7;
ArrayList<Circle> circles = new ArrayList<Circle>();
Vec2 circle0Pos = new Vec2(7,4);

// Node pos
Vec2 base_pos = new Vec2(3, 1);
Node base = new Node(base_pos);

// Cloths
Cloth cloth = new Cloth(5, 5, linkLength, 
    (v) -> new Vec2(base_pos.x+v.y*1.1, base_pos.y+v.x*1.1));

void setup() {
  size(500, 500);
  surface.setTitle("Fixed-length link simulation");
  scene_scale = width / 10.0f;  
  
  //for (int i = 0; i < numNodes; i++){ 
  //  for(int j = 0; j < numNodes; j++){
  //    nodes[i][j] .add(new Node(new Vec2(base_pos.x+i*0.2, base_pos+j*0.2)));  //nodes[0] is the base node
  //  }
  //}
  //cloth.initial();
  
  // Multiple ropes
//   Rope rope1 = new Rope(base_pos, numNodes, linkLength, 
//                         i -> new Vec2(base_pos.x+i*linkLength, base_pos.y));

//   Rope rope2 = new Rope(base_pos, numNodes, linkLength, 
//                         i -> new Vec2(base_pos.x-i*linkLength, base_pos.y));
//   ropes.add(rope1);
//   ropes.add(rope2);
  //for (int i = 0; i < numNodes; i++){ 
  //  nodes3.add(new Node(new Vec2(base_pos.x+i*0.2, base_pos.y-i*0.1)));  //nodes[0] is the base node
  //}
  //for (int i = 0; i < numNodes; i++){ 
  //  nodes4.add(new Node(new Vec2(base_pos.x-i*0.2, base_pos.y-i*0.1)));  //nodes[0] is the base node
  //}
  
  // Obstacles
  circles.add(new Circle(circle0Pos.x, circle0Pos.y, 2));
  clothTex = loadImage("flag.jpg");
  
}


void update_physics(float dt) {
    // for (Rope r : ropes) {
    //     r.update_physics(dt);
    // }
    cloth.update_physics(dt);
  
  // ellipse cirrcle collision
  //for (int i = 1; i < nodes.size(); i++) {    
  //  if (ncColliding(nodes.get(i), circles.get(0))) {
  //    Vec2 circleObjPos = new Vec2(circles.get(0).x, circles.get(0).y);
  //    Vec2 normal = (nodes.get(i).pos.minus(circleObjPos)).normalized();
  //    nodes.get(i).pos = circleObjPos.plus(normal.times(radius+circles.get(0).r).times(1.01));
  //    Vec2 velNormal = normal.times(dot(nodes.get(i).vel,normal));
  //    //velNormal.add(new Vec2(50,50));
  //    nodes.get(i).vel.subtract(velNormal.times(1 + COR));
  //  }
  //}      
  
}

boolean paused = false;

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
  
  if (key == 'u') {
    ks += 10;
  }
  if (key == 'e') {
    ks -= 10;
  }

  if (key == 'i') {
    kv += 10;
  }
  if (key == 'n') {
    kv -= 10;
  }

  cloth = new Cloth(5, 5, linkLength, 
        (v) -> new Vec2(3+v.x*1, 1+v.y*1));
  print(ks);
  print(", ");
  println(kv);
 
  //if (keyCode == RIGHT)
  //  velX += 20;
  //if (keyCode == LEFT)
  //  velX -= 20;
  //camera.HandleKeyPressed();
  
}

void keyReleased()
{
  //camera.HandleKeyReleased();
}

float time = 0;
void draw() {
  float dt = 1.0 / 20; //Dynamic dt: 1/frameRate;
  // dt changed
  dt = 0.001;
  
  if (!paused) {
    for (int i = 0; i < num_steps; i++) {
      time += dt / num_steps;
      update_physics(dt / num_steps);
    }
  }

  // Compute the total energy (should be conserved)
  //float kinetic_energy = 0;
  //for(int i = 0; i < nodes.size(); i++){
  //  kinetic_energy += 0.5 * nodes.get(i).vel.lengthSqr();
  //}

  //float potential_energy = 0; // PE = m*g*h
  //for (int i = 0; i < nodes.size(); i++){
  //  float nodeHeight =  (height - nodes.get(i).pos.y * scene_scale) / scene_scale;
  //  potential_energy += nodeMass * magnitude(gravity.x, gravity.y) * nodeHeight;
  //}
  
  //float total_energy = kinetic_energy + potential_energy;

  background(255);
  stroke(0);
  strokeWeight(2);

  // Draw Nodes
  fill(166, 23, 150);
  stroke(0);
  strokeWeight(0.02 * scene_scale);
  cloth.draw_nodes();
  cloth.mapTexture();

//   ropes.get(0).drawNodes(scene_scale, radius);
//   fill(0, 213, 150);
//   ropes.get(1).drawNodes(scene_scale, radius);
  //fill(150, 213, 0);
  //ropes.get(2)scene_scale, radius);
  //fill(213, 0, 150);
  //ropes.get(3)scene_scale, radius);

  // Draw Links (black)
  stroke(0);
  strokeWeight(0.02 * scene_scale);
  cloth.draw_lines();
//   ropes.get(0).drawLine(scene_scale);
//   ropes.get(1).drawLine(scene_scale);
  //drawLine(nodes3, scene_scale);
  //drawLine(nodes4, scene_scale);
  
  // Draw Obstacle
  pushStyle();
  pushMatrix();
  translate(circle0Pos.x,circle0Pos.y);
  fill(233,66,87);
  //circle(circle0Pos.x* scene_scale,circle0Pos.y* scene_scale,circles.get(0).r* scene_scale);
  popMatrix();
  popStyle();
}
