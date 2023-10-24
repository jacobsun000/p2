// CSCI5611-Procjet2
// Author: Jianing Wen, Jacob Sun

import java.util.function.Function;

public class Rope {
    public ArrayList<Node> nodes;
    public Vec3 basePos;
    public float linkLength;

    // Nodes has to be at least 2 nodes
    public Rope (Vec3 basePos, int numNodes, float linkLength, Function<Integer, Vec3> posFunc) {
        this.basePos = basePos;
        this.linkLength = linkLength;
        this.nodes = new ArrayList<Node>();
        for (int i = 0; i < numNodes; i++) {
            nodes.add(new Node(posFunc.apply(i)));
        }
    }
    
    public void updatePhysics(float dt) {
        semi_implicit_integration(dt);

        // Constrain the distance between nodes to the link length
        for (int i = 0; i < 10; i++) {
            constrain_distance();
        }

        // Fix the base node in place (it's pinned!!!)
        nodes.get(0).pos = basePos;
        
        update_velocity(dt);
    }
    
    public void updateCollision(Rope o) {
        for (int i = 1; i < nodes.size(); i++) {
            for (int j = 1; j < o.nodes.size(); j++) {
                Node n1 = nodes.get(i);
                Node n2 = o.nodes.get(j);
                float dist = n1.pos.distanceTo(n2.pos);
                float overlap = dist;
                if (overlap > 0.05)
                    return;
                println("collided");
                Vec3 norm = n1.pos.minus(n2.pos).normalized();
                float v1_in = dot(n1.vel, norm);
                float v2_in = dot(n2.vel, norm);
                
                n1.pos = n1.pos.plus(norm.times(overlap * 1));
                n2.pos = n2.pos.minus(norm.times(overlap * 1));
                n1.vel = n1.vel.minus(norm.times(v2_in-v1_in).times(1));
                n2.vel = n2.vel.minus(norm.times(v1_in-v2_in).times(1));
            }
        }
        
    }
    
    // draw nodes
    public void draw() {
        float radius = linkLength / 4 * sceneScale;
        for (int i = 0; i < nodes.size()-1; i++) {
            Vec3 p1 = nodes.get(i).pos.times(sceneScale);
            Vec3 p2 = nodes.get(i+1).pos.times(sceneScale);
            pushMatrix();
            pushStyle();
            fill(200, 50, 50);
            translate(p1.x, p1.y, p1.z);
            sphere(radius);
            stroke(1);
            line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
            noStroke();
            popStyle();
            popMatrix();
        }
    }

    //draw links
    public void drawLine(float sceneScale) {
        for(int i = 0; i < nodes.size()-1; i++){
            line(nodes.get(i).pos.x * sceneScale, nodes.get(i).pos.z * sceneScale, nodes.get(i+1).pos.x * sceneScale, nodes.get(i+1).pos.z * sceneScale);
        }
    }
    
    // semi_implicit_integration
    private void semi_implicit_integration(float dt){
        for(int i = 1; i < nodes.size();i++){
            nodes.get(i).last_pos = nodes.get(i).pos;
            nodes.get(i).vel = nodes.get(i).vel.plus(gravity.times(dt*100));
            nodes.get(i).pos = nodes.get(i).pos.plus(nodes.get(i).vel.times(dt));
        }
    }
    
    // Hooke's law
    private void hooke_s_law(float dt){
        for(int i = 1; i < nodes.size();i++){
            Node curr = nodes.get(i);
            Node prev = nodes.get(i-1);
            float stringLen = curr.pos.distanceTo(prev.pos);
            float stringForce = -ks * (stringLen - linkLength);
            Vec3 stringDir = curr.pos.minus(prev.pos).normalized();
            Vec3 stringF= stringDir.times(stringForce);
            Vec3 dampF = (curr.vel.minus(prev.vel)).times(-kv);
            Vec3 acceleration = stringF.plus(dampF).plus(gravity);
            nodes.get(i).vel.add(acceleration.times(dt));
            nodes.get(i).pos.add(nodes.get(i).vel.times(dt));
        }
    }

    // Arbitrary angles
    private void damping(float dt){
        for(int i = 1; i < nodes.size();i++){
            Vec3 d = nodes.get(i).pos.minus(nodes.get(i-1).pos);
            float stringLen = d.length();
            float stringF = -ks * (stringLen - linkLength); 
            Vec3 string_dir = d.normalized();
            Vec3 dampFXY = (nodes.get(i).vel.minus(nodes.get(i-1).vel)).times(-kv);
            
            nodes.get(i).vel.add(string_dir.times(stringF).times(dt));
            nodes.get(i).vel.add(gravity.times(dt));
            nodes.get(i).pos.add(nodes.get(i).vel.times(dt));
        }
    }
    
    // Constrain the distance between nodes to the link length
    private void constrain_distance(){
        for (int j = 0; j < nodes.size()-1; j++){
            Vec3 delta = nodes.get(j+1).pos.minus(nodes.get(j).pos);
            float delta_len = delta.length();
            float correction = delta_len - linkLength;
            Vec3 delta_normalized = delta.normalized();
            // update the position of both notes
            nodes.get(j+1).pos = nodes.get(j+1).pos.minus(delta_normalized.times(correction / 2));
            nodes.get(j).pos = nodes.get(j).pos.plus(delta_normalized.times(correction / 2));     
        }
    }

    // Update the velocities (PBD)
    private void update_velocity(float dt){
        for (int i = 0; i < nodes.size(); i++){
            nodes.get(i).vel = nodes.get(i).pos.minus(nodes.get(i).last_pos).times(1 / dt);
        }
    }


}
