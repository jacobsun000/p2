// Created for CSCI 5611 by Liam Tyler & Stephen J. Guy

// WASD keys move the camera relative to its current orientation
// Arrow keys rotate the camera's orientation
// Holding shift boosts the move speed
// Mouse position is used to highlight the sphere that the ray from the camera intersects with


class Camera
{
  Camera()
  {
    position      = new PVector( 0, 0, 0 ); // initial position
    theta         = 9; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = 0; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = 1;
    turnSpeed     = 1.57; // radians/sec
    //boostSpeed    = 10;  // extra speed boost for when you press shift
    //mouseDir      = new PVector( 0, 0, -1 ); // direction of mouse ray
    
    // dont need to change these
    shiftPressed = false;
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1;
    farPlane         = 10000;
  }
  
  void Update(float dt)
  {
    theta += turnSpeed * ( negativeTurn.x + positiveTurn.x)*dt;
    
    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = 85 * PI / 180;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
    // except that their theta and phi are named opposite
    float t = theta + PI / 2;
    float p = phi + PI / 2;
    PVector forwardDir = new PVector( sin( p ) * cos( t ),   cos( p ),   -sin( p ) * sin ( t ) );
    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
    position.add( PVector.mult( upDir,      moveSpeed * velocity.y * dt ) );
    position.add( PVector.mult( rightDir,   moveSpeed * velocity.x * dt ) );
    
    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y, position.z,
            position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
            upDir.x, upDir.y, upDir.z );

    //float mx = mouseX / (float) width;
    //float my = mouseY / (float) height;
    //PVector mousePos = new PVector();
    //mousePos.set( forwardDir );
    //mousePos.mult( nearPlane );
    //mousePos.add( position );
    //mousePos.add( PVector.mult( upDir, ( my - 0.5 ) * nearPlane * tan( fovy / 2 ) * 2 ) );
    //mousePos.add( PVector.mult( rightDir, ( mx - 0.5 ) * nearPlane * aspectRatio * tan( fovy / 2 ) * 2 ) );
    //mouseDir = new PVector();
    //mouseDir.set( mousePos );
    //mouseDir.sub( position );
    //mouseDir.normalize();
    
    //// Draw box at mouse position
    //pushMatrix();
    //translate( mousePos.x, mousePos.y, mousePos.z );
    //fill(120,120,120);
    //box( 0.002 );
    //popMatrix();

  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyPressed()
  {
    if ( key == 'w' || key == 'W' ) positiveMovement.z = 1;
    if ( key == 's' || key == 'S' ) negativeMovement.z = -1;
    if ( key == 'a' || key == 'A' ) negativeMovement.x = -1;
    if ( key == 'd' || key == 'D' ) positiveMovement.x = 1;
    if ( key == 'q' || key == 'Q' ) positiveMovement.y = 1;
    if ( key == 'e' || key == 'E' ) negativeMovement.y = -1;
    
    if ( key == 'r' || key == 'R' ){
      Camera defaults = new Camera();
      position = defaults.position;
      theta = defaults.theta;
      phi = defaults.phi;
    }
    
    if ( keyCode == LEFT )  negativeTurn.x = 1;
    if ( keyCode == RIGHT ) positiveTurn.x = -0.5;
    if ( keyCode == UP )    positiveTurn.y = 0.5;
    if ( keyCode == DOWN )  negativeTurn.y = -1;
    
    if ( keyCode == SHIFT ) shiftPressed = true; 
    if (shiftPressed){
      positiveMovement.mult(boostSpeed);
      negativeMovement.mult(boostSpeed);
    }
    
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyReleased()
  {
    if ( key == 'w' || key == 'W' ) positiveMovement.z = 0;
    if ( key == 'q' || key == 'Q' ) positiveMovement.y = 0;
    if ( key == 'd' || key == 'D' ) positiveMovement.x = 0;
    if ( key == 'a' || key == 'A' ) negativeMovement.x = 0;
    if ( key == 's' || key == 'S' ) negativeMovement.z = 0;
    if ( key == 'e' || key == 'E' ) negativeMovement.y = 0;
    
    if ( keyCode == LEFT  ) negativeTurn.x = 0;
    if ( keyCode == RIGHT ) positiveTurn.x = 0;
    if ( keyCode == UP    ) positiveTurn.y = 0;
    if ( keyCode == DOWN  ) negativeTurn.y = 0;
    
    if ( keyCode == SHIFT ){
      shiftPressed = false;
      positiveMovement.mult(1.0/boostSpeed);
      negativeMovement.mult(1.0/boostSpeed);
    }
  }
  
  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;
  float boostSpeed;
  PVector mouseDir;
  
  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;  
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
  boolean shiftPressed;
};




//// ----------- Example using Camera class -------------------- //
//Camera camera;

//void setup(){
//  size(600, 600, P3D);
//  camera = new Camera();
//  sphereDetail(15, 15);
//  surface.setTitle("[CSCI 5611] Picking Example");
//  // noCursor();  // Disable mouse cursor
//}

//void keyPressed()
//{
//  camera.HandleKeyPressed();
//}

//void keyReleased()
//{
//  camera.HandleKeyReleased();
//}

//boolean raySphereIntersect(PVector rayOrigin, PVector rayDir, PVector sphereCenter, float sphereRadius, PVector intersection){
//  PVector oc = new PVector();
//  oc.set(rayOrigin);
//  oc.sub(sphereCenter);
//  float a = PVector.dot(rayDir, rayDir);
//  float b = 2 * PVector.dot(oc, rayDir);
//  float c = PVector.dot(oc, oc) - sphereRadius * sphereRadius;
//  float discriminant = b * b - 4 * a * c;
//  if (discriminant < 0){
//    return false;
//  }
//  else{
//    float t = (-b - sqrt(discriminant)) / (2 * a);
//    intersection.set(rayOrigin);
//    intersection.add(PVector.mult(rayDir, t));
//    return true;
//  }
//}

//void drawSphere(PVector center, float radius){
//  pushMatrix();
//  translate(center.x, center.y, center.z);
//  sphere(radius);
//  popMatrix();
//}

//void draw() {
//  background(255);
//  noLights();

//  float sphereRadius = 20;

//  camera.Update(1.0/frameRate);
//  PVector intersection = new PVector();

//  // draw six spheres surrounding the origin (front, back, left, right, top, bottom)


//  // Blue Spheres
//  PVector sphereCenter = new PVector(0, 0, -50);
//  fill( 0, 0, 255 );
//  if (raySphereIntersect(camera.position, camera.mouseDir, sphereCenter, sphereRadius, intersection)){
//    fill(255, 0, 255);
//  }
//  drawSphere(sphereCenter, sphereRadius);

//  sphereCenter = new PVector(0, 0, 50);
//  fill( 0, 0, 255 );
//  if (raySphereIntersect(camera.position, camera.mouseDir, sphereCenter, sphereRadius, intersection)){
//    fill(255, 0, 255);
//  }
//  drawSphere(sphereCenter, sphereRadius);

//  // Red Spheres
//  sphereCenter = new PVector(-50, 0, 0);
//  fill( 255, 0, 0 );
//  if (raySphereIntersect(camera.position, camera.mouseDir, sphereCenter, sphereRadius, intersection)){
//    fill(255, 0, 255);
//  }
//  drawSphere(sphereCenter, sphereRadius);

//  sphereCenter = new PVector(50, 0, 0);
//  fill( 255, 0, 0 );
//  if (raySphereIntersect(camera.position, camera.mouseDir, sphereCenter, sphereRadius, intersection)){
//    fill(255, 0, 255);
//  }
//  drawSphere(sphereCenter, sphereRadius);
  
//  // Green Spheres
//  sphereCenter = new PVector(0, 50, 0);
//  fill( 0, 255, 0 );
//  if (raySphereIntersect(camera.position, camera.mouseDir, sphereCenter, sphereRadius, intersection)){
//    fill(255, 0, 255);
//  }
//  drawSphere(sphereCenter, sphereRadius);

//  sphereCenter = new PVector(0, -50, 0);
//  fill( 0, 255, 0 );
//  if (raySphereIntersect(camera.position, camera.mouseDir, sphereCenter, sphereRadius, intersection)){
//    fill(255, 0, 255);
//  }
//  drawSphere(sphereCenter, sphereRadius);
//}
