import java.util.function.Function;

public class Rope {
    public ArrayList<Node> nodes;
    public Vec2 basePos;
    public float linkLength;

    // Nodes has to be at least 2 nodes
    public Rope (Vec2 basePos, int numNodes, float linkLength, Function<Integer, Vec2> posFunc) {
        this.basePos = basePos;
        this.linkLength = linkLength;
        this.nodes = new ArrayList<Node>();
        for (int i = 0; i < numNodes; i++) {
            nodes.add(new Node(posFunc.apply(i)));
        }
    }
    
    public void update_physics(float dt) {
        semi_implicit_integration(dt);

        // Constrain the distance between nodes to the link length
        for (int i = 0; i < num_relaxation_steps; i++) {
            constrain_distance();
        }

        // Fix the base node in place (it's pinned!!!)
        //nodes.get(0).pos = basePos;
        
        update_velocity(dt);
    }
    
    // draw nodes
    public void drawNodes(float scene_scale, float radius) {
        for(int i = 0; i < nodes.size(); i++){
            //ellipse(nodes.get(i).pos.x * scene_scale, nodes.get(i).pos.y * scene_scale, 0.3*scene_scale, 0.3*scene_scale);
            ellipse(nodes.get(i).pos.x * scene_scale, nodes.get(i).pos.y * scene_scale, radius * 2, radius * 2);
        }
    }

    //draw links
    public void drawLine(float scene_scale) {
        for(int i = 0; i < nodes.size()-1; i++){
            line(nodes.get(i).pos.x * scene_scale, nodes.get(i).pos.y * scene_scale, nodes.get(i+1).pos.x * scene_scale, nodes.get(i+1).pos.y * scene_scale);
        }
    }
    

    public float total_length_error(){
        float error = 0;
        for (int i = 0; i < nodes.size()-1; i++) {
            Vec2 delta = nodes.get(i+1).pos.minus(nodes.get(i).pos);
            float delta_len = delta.length();
            error += abs(delta_len - linkLength);
        }
        return error;
    }
    
    // semi_implicit_integration
    private void semi_implicit_integration(float dt){
        for(int i = 1; i < nodes.size();i++){
            nodes.get(i).last_pos = nodes.get(i).pos;
            nodes.get(i).vel = nodes.get(i).vel.plus(gravity.times(dt));
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
            Vec2 stringDir = curr.pos.minus(prev.pos).normalized();
            Vec2 stringF= stringDir.times(stringForce);
            Vec2 dampF = (curr.vel.minus(prev.vel)).times(-kv);
            Vec2 acceleration = stringF.plus(dampF).plus(gravity);
            nodes.get(i).vel.add(acceleration.times(dt));
            nodes.get(i).pos.add(nodes.get(i).vel.times(dt));
        }
    }

    // Arbitrary angles
    private void damping(float dt){
        for(int i = 1; i < nodes.size();i++){
            Vec2 dxdy = new Vec2(nodes.get(i).pos.x - nodes.get(i-1).pos.x, nodes.get(i).pos.y - nodes.get(i-1).pos.y);
            float stringLen = dxdy.length();
            float stringF = -ks * (stringLen - linkLength); 
            Vec2 string_dir = new Vec2(dxdy.x / stringLen, dxdy.y / stringLen);
            Vec2 dampFXY = (nodes.get(i).vel.minus(nodes.get(i-1).vel)).times(-kv);
            
            nodes.get(i).vel.add(string_dir.times(stringF).times(dt));
            nodes.get(i).vel.add(gravity.times(dt));
            nodes.get(i).pos.add(nodes.get(i).vel.times(dt));
        }
    }
    
    // Constrain the distance between nodes to the link length
    private void constrain_distance(){
        for (int j = 0; j < nodes.size()-1; j++){
            Vec2 delta = nodes.get(j+1).pos.minus(nodes.get(j).pos);
            float delta_len = delta.length();
            float correction = delta_len - linkLength;
            Vec2 delta_normalized = delta.normalized();
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
