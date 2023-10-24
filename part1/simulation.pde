// CSCI5611-Procjet2
// Author: Jianing Wen, Jacob Sun

// Scene
Camera cam;
int width = 1000;
int height = 1000;
float sceneScale = width / 10.0f;

// Constants for physics simulation
Vec3 gravity = new Vec3(0, 0.0981, 0);
float ks = 0.3;  //ks
float kv = 0.2; //damping
float airdrag = 0.5;
int numSteps = 10; 

// Circle
float COR = 0.005;
Vec3 circlePos = new Vec3(1.20, 3, 3.00);
float circleRadius = 0.6;
ArrayList<Circle> circles = new ArrayList<Circle>();

// Ropes
int ropeNodeNums = 5;
float ropeLinkLength = 1;
float ropeNodeRadius = 15 / 4;
Vec3 ropeBasePos = new Vec3(3, 1, 0);
Node ropeBase = new Node(ropeBasePos);
float ropeNodeMass = 1;
ArrayList<Rope> ropes = new ArrayList<Rope>();

// Cloths
PImage clothTex;
int clothRows = 30;
int clothCols = 30;
float clothLinkLength = 0.066;
Function<Vec2, Vec3> clothPosFunc = (v) -> 
    new Vec3(0 + v.y * clothLinkLength,
             2, 
             2.5 + v.x * clothLinkLength);
Cloth cloth;

void setup() {
    size(1000, 1000, P3D); //<>//
    cam = new Camera();
    noStroke();
    surface.setTitle("Cloth and Rope simulation"); //<>// //<>// //<>//

    // circle
    Circle c1 = new Circle(circlePos, new Vec3(0, 0, 0), circleRadius);
    circles.add(c1);
    
    // rope
    Rope r1 = new Rope(new Vec3(2, 5, 2), 10, 0.5, (i) -> 
                    new Vec3(2, 5, 2-i*0.5));
    Rope r2 = new Rope(new Vec3(2, 5, 3), 10, 0.5, (i) -> 
                    new Vec3(2, 5, 3+i*0.5));
    ropes.add(r1);
    ropes.add(r2);
  
    // cloth
    clothTex = loadImage("flag.jpg");
    cloth = new Cloth(clothRows, clothCols, clothLinkLength, clothPosFunc, clothTex);
}


void updatePhysics(float dt) {
    // circles
    for (Circle circle: circles) {
        circle.updatePhysics(dt);
    }
    
    // ropes
    Rope r1 = ropes.get(0);
    Rope r2 = ropes.get(1);
    r1.updateCollision(r2);
    for (Rope r : ropes) {
        r.updatePhysics(dt);
    }

    // cloth
    cloth.updatePhysics(dt);
    for (Circle circle : circles) {
        cloth.updateCollision(circle);
    }
}

boolean paused = false;

void keyPressed() {
    if (key == ' ') {
        //updatePhysics(1.0/20/numSteps);
        //paused = !paused;
        cloth = new Cloth(clothRows, clothCols, clothLinkLength, clothPosFunc, clothTex);
        ropes.clear();
        Rope r1 = new Rope(new Vec3(2, 5, 2), 10, 0.5, (i) -> 
                        new Vec3(2, 5, 2-i*0.5));
        Rope r2 = new Rope(new Vec3(2, 5, 3), 10, 0.5, (i) -> 
                        new Vec3(2, 5, 3+i*0.5));
        ropes.add(r1);
        ropes.add(r2);        
    }
    
    cam.HandleKeyPressed();
  
}

void keyReleased()
{
  cam.HandleKeyReleased();
}

void draw() {
    // background
    background(100, 100, 200);
    lights();
    
    // circles
    for (Circle circle : circles) {
        circle.draw();
    }
    
    // ropes
    for (Rope rope : ropes) {
        //rope.draw();
    }
    
    // cloth
    cloth.draw();
    // physics
    float dt = 1.0/20;
    cam.Update(dt);
    if (!paused) {
        for (int i = 0; i < numSteps; i++) {
        updatePhysics(dt / numSteps);
        }
    }
}
