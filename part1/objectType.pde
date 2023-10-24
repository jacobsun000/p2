class Circle {
    public Vec3 pos;
    public Vec3 vel;
    public float radius;
    
    public Circle (Vec3 pos, Vec3 vel, float radius) {
        this.pos = pos;
        this.vel = vel;
        this.radius = radius;
    }
    
    public void updatePhysics(float dt) {
        pos.add(vel.times(dt));
    }
    
    public void draw() {
        push();
        fill(200, 100, 128);
        translate(pos.x, pos.y, pos.z);
        sphere(radius);
        pop();
    }
}