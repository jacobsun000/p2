public class Cloth {
    public Node[][] nodes;
    public float linkLength;
    public Function<Vec2, Vec2> posFunc;
    
    public Cloth(int numRows, int numCols, float linkLength, Function<Vec2, Vec2> posFunc) {
        this.nodes = new Node[numRows][numCols];
        this.linkLength = linkLength;
        this.posFunc = posFunc;
        for(int i = 0; i < nodes.length; i++){
            for (int j = 0; j < nodes[0].length; j++) {
                nodes[i][j] = new Node(posFunc.apply(new Vec2(i, j)));
            }
        }
    }
    
    //public void initial(){
    //  for (int i = 0; i < numNodes; i++){ 
    //    for(int j = 0; j < numNodes; j++){
    //      nodes[i][j].pos.x = base_pos.x+i*1/1;
    //      nodes[i][j].pos.y = base_pos.y+j*1.1;
    //      //nodes[i][j].add(new Node(new Vec2(base_pos.x+i*0.2, base_pos+j*0.2)));  //nodes[0] is the base node
    //    }
    //  }
    //}
    
    public void update_physics(float dt) {
        // semi_implicit_integration(dt);

        for (int i = 0; i < num_relaxation_steps; i++) {
            // constrain_distance();
            hook_s_law(dt);
        }
        
        
        // update_velocity(dt);


        // pin
        //for (int col = 0; col < nodes[0].length; col++) {
        //  //if(nodes[0]
        //   //nodes[0][col].pos.x = base_pos.y+col*1.1;
        //    nodes[0][col].pos = posFunc.apply(new Vec2(base_pos.x, col));
        //    print("Pos: " + nodes[0][col].pos.x + ' ' + nodes[0][col].pos.y);
        //}
        
         // pin
         //for (int col = 0; col < nodes[0].length; col++) {
         //    nodes[0][col].pos = posFunc.apply(new Vec2(0, col));
         //}
    }
    
    public void draw_nodes() {
        for(int i = 0; i < nodes.length; i++){
            for (int j = 0; j < nodes[0].length; j++) {
                ellipse(nodes[i][j].pos.x * scene_scale, nodes[i][j].pos.y * scene_scale, radius*2, radius*2);
            }
        }

    }

    public void draw_lines() {
        for(int i = 1; i < nodes.length; i++){
            for (int j = 1; j < nodes[0].length; j++) {
                line(nodes[i][j].pos.x * scene_scale, nodes[i][j].pos.y * scene_scale, nodes[i-1][j].pos.x * scene_scale, nodes[i-1][j].pos.y * scene_scale);
                line(nodes[i][j].pos.x * scene_scale, nodes[i][j].pos.y * scene_scale, nodes[i][j-1].pos.x * scene_scale, nodes[i][j-1].pos.y * scene_scale);
            }
        }
        for (int i = 1; i < nodes.length; i++) {
            line(nodes[i][0].pos.x * scene_scale, nodes[i][0].pos.y * scene_scale, nodes[i-1][0].pos.x * scene_scale, nodes[i-1][0].pos.y * scene_scale);
        }
        for (int j = 1; j < nodes[0].length; j++) {
            line(nodes[0][j].pos.x * scene_scale, nodes[0][j].pos.y * scene_scale, nodes[0][j-1].pos.x * scene_scale, nodes[0][j-1].pos.y * scene_scale);
        }

    }
    
    public void mapTexture(){
      pushStyle();
      textureMode(NORMAL);
      beginShape();
      texture(clothTex);
      vertex(nodes[0][0].pos.x, nodes[0][0].pos.y, 0, 0);
      vertex(nodes[0][4].pos.x, nodes[0][4].pos.y, 0, 1);
      vertex(nodes[4][4].pos.x, nodes[4][4].pos.y, 1, 1);
      vertex(nodes[4][0].pos.x, nodes[4][0].pos.y, 1, 0);
      endShape(CLOSE);
      popStyle();  
    }
    
    // Cloth Simulation (Hooke's law)
    private void hook_s_law(float dt) {
        Vec2 vn[][] = new Vec2[nodes.length][nodes[0].length];
        // vertical
         for(int i = 0; i < nodes.length-1; i++){
             for (int j = 0; j < nodes[0].length; j++) {
                 Node curr = nodes[i+1][j];
                 Node prev = nodes[i][j];
                 //float l = curr.pos.distanceTo(prev.pos);
                 //Vec2 e = curr.pos.minus(prev.pos).normalized();
                 //float v1 = dot(e, prev.vel);
                 //float v2 = dot(e, curr.vel);
                 //float f = -ks*(linkLength - l)-kv*(v1-v2);
                 //vn[i][j] = prev.vel.plus(e.times(f*dt));
                 //vn[i+1][j] = curr.vel.minus(e.times(f*dt));
                 
                 //float stringLen = curr.pos.distanceTo(prev.pos);
                 //float stringForce = -ks * (stringLen - linkLength);
                 //Vec2 dampF = (curr.vel.minus(prev.vel)).times(-kv);
                 //Vec2 stringDir = curr.pos.minus(prev.pos).normalized();
                 //Vec2 stringF= stringDir.times(stringForce); 
                 //Vec2 acceleration = stringF.plus(dampF);
                 //vn[i][j] = curr.vel.plus(acceleration.times(dt));
                 
                 //float stringLen = curr.pos.x - prev.pos.x;
                 //float stringForce = -ks * (stringLen - linkLength);
                 //float dampF = -kv * (curr.vel.x - prev.vel.x);
                 //float forceX = stringForce + dampF;
                 //float acceleration = gravity.length() + forceX/nodeMass;
                 //nodes[i+1][j].vel.x += acceleration*dt;
                 //nodes[i+1][j].pos.x += nodes[i+1][j].vel.x*dt;
                 float stringLen = curr.pos.y - prev.pos.y;
                 float stringForce = -ks * (stringLen - linkLength);
                 float dampF = -kv * (curr.vel.y - prev.vel.y);
                 float forceY = stringForce + dampF;
                 float acceleration = gravity.length() + forceY/nodeMass;
                 nodes[i+1][j].vel.y += acceleration*dt;
                 nodes[i+1][j].pos.y += nodes[i+1][j].vel.x*dt;
             }
         }
        // horizontal
        for(int i = 0; i < nodes.length; i++){
            for (int j = 0; j < nodes[0].length-1; j++) {
                Node curr = nodes[i][j+1];
                Node prev = nodes[i][j];
                //float l = curr.pos.distanceTo(prev.pos);
                //Vec2 e = curr.pos.minus(prev.pos).normalized();
                //float v1 = dot(e, prev.vel);
                //float v2 = dot(e, curr.vel);
                //float f = -ks*(linkLength - l)-kv*(v1-v2);
                //vn[i][j] = prev.vel.plus(e.times(f*dt));
                //vn[i][j+1] = curr.vel.minus(e.times(f*dt));
                
                //float stringLen = curr.pos.y - prev.pos.y;
                //float stringForce = -ks * (stringLen - linkLength);
                //float dampF = -kv * (curr.vel.y - prev.vel.y);
                //float forceY = stringForce + dampF;
                //float acceleration = gravity.length() + forceY/nodeMass;
                //nodes[i][j+1].vel.y += acceleration*dt;
                //nodes[i][j+1].pos.y += nodes[i][j+1].vel.x*dt;
                
                float stringLen = curr.pos.x - prev.pos.x;
                float stringForce = -ks * (stringLen - linkLength);
                float dampF = -kv * (curr.vel.x - prev.vel.x);
                float forceX = stringForce + dampF;
                float acceleration = gravity.length() + forceX/nodeMass;
                nodes[i][j+1].vel.x += acceleration*dt;
                nodes[i][j+1].pos.x += nodes[i][j+1].vel.x*dt;
            }
        }
        
        // update
        //for(int i = 0; i < nodes.length; i++){
        //    for (int j = 0; j < nodes[0].length; j++) {
        //      //print(vn[i][j]);
        //      //vn[i][j].y += -0.1;
        //      //nodes[i][j].vel = vn[i][j];
        //      nodes[i][j].vel = vn[i][j].plus(gravity.times(dt*-0.0001));
        //      //nodes[i][j].vel = vn[i][j].plus(gravity.times(dt));
        //      //print(nodes[i][j].vel);
        //      nodes[i][j].pos.add(nodes[i][j].vel.times(dt));
        //    }
        //}

    }
    
    // Collision Detection
    private void collision_detection(float dt) {
        for(int i = 0; i < nodes.length; i++){
            for (int j = 0; j < nodes[0].length; j++) {
                float d = circle0Pos.distanceTo(nodes[i][j].pos);
                if(d < circles.get(0).r + 0.09){
                   Vec2 n= (circle0Pos.minus(nodes[i][j].pos)).times(-1); //sphere normal
                   n.normalized(); 
                   //n = [n[0],n[1],n[2]]
                   Vec2 bounce = n.times(dot(nodes[i][j].vel, n));
                   nodes[i][j].vel = nodes[i][j].vel.minus(bounce.times(-1.5));
                   nodes[i][j].pos = nodes[i][j].pos.plus(n.times(0.1 + circles.get(0).r - d));
                   //bounce = np.multiply(np.dot(v[i,j],n),n)
                   //v[i,j] -= 1.5*bounce
                   //p[i,j] += np.multiply(.1 + sphereR - d, n) #move out
                }
            }
        }
    }
    
    // Semi implicit integration       
    private void semi_implicit_integration(float dt) {
        for(int i = 1; i < nodes.length; i++){
            for (int j = 0; j < nodes[0].length; j++) {
                nodes[i][j].last_pos = nodes[i][j].pos;
                nodes[i][j].vel = nodes[i][j].vel.plus(gravity.times(dt));
                nodes[i][j].pos.add(nodes[i][j].vel.times(dt));
            }
        }
    }
    
    private void constrain_distance() {
        // Horizontal
        for (int i = 0; i < nodes.length-1; i++) {
            for (int j = 0; j < nodes[0].length; j++) {
                constrain_link(i+1, j, i, j);
            }
        }
        // Vertical
        for (int i = 0; i < nodes.length; i++) {
            for (int j = 0; j < nodes[0].length-1; j++) {
                constrain_link(i, j+1, i, j);
            }
        }
        
    }
    
    private void constrain_link(int i1, int j1, int i2, int j2) {
        Node curr = nodes[i1][j1];
        Node prev = nodes[i2][j2];
        Vec2 delta = curr.pos.minus(prev.pos);
        float delta_len = delta.length();
        float correction = delta_len - linkLength;
        correction = correction * ks;
        Vec2 delta_normalized = delta.normalized();
        // update the position of both notes
        nodes[i1][j1].pos.subtract(delta_normalized.times(correction / 2));
        nodes[i2][j2].pos.add(delta_normalized.times(correction / 2));     
    }
    

    private void update_velocity(float dt){
        for (int i = 0; i < nodes.length; i++) {
            for (int j = 0; j < nodes[0].length; j++) {
                nodes[i][j].vel = nodes[i][j].pos.minus(nodes[i][j].last_pos).times(1 / dt);
            }
        }
        
    }
}
