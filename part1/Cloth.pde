// CSCI5611-Procjet2
// Author: Jianing Wen, Jacob Sun

import java.util.function.Function;


public class Cloth {
    public Node[][] nodes;
    public int rows, cols;
    public float linkLength;
    public Function<Vec2, Vec3> posFunc;
    public PImage texture;
    private Vec3[][] vn; // temp array to hold new velocities for cloth
    
    public Cloth(int numRows, int numCols, float linkLength, 
            Function<Vec2, Vec3> posFunc, PImage texture) {
        this.rows = numRows;
        this.cols = numCols;
        this.nodes = new Node[numRows][numCols];
        this.linkLength = linkLength;
        this.posFunc = posFunc;
        this.texture = texture;
        for(int i = 0; i < nodes.length; i++){
            for (int j = 0; j < nodes[0].length; j++) {
                nodes[i][j] = new Node(posFunc.apply(new Vec2(i, j)));
            }
        }
    }
    
    public void draw() {
        for (int i = 0; i < rows-1; i++) {
            for (int j = 0; j < cols-1; j++) {
                Vec3 p1 = nodes[i][j].pos;
                Vec3 p2 = nodes[i][j+1].pos;
                Vec3 p3 = nodes[i+1][j+1].pos;
                Vec3 p4 = nodes[i+1][j].pos;
                float ulow = float(i) / (rows-1);
                float uhigh = float(i+1) / (rows-1);
                float vlow = float(j) / (cols-1);
                float vhigh = float(j+1) / (cols-1);
                pushStyle();
                textureMode(NORMAL);
                beginShape();
                texture(clothTex);
                vertex(p1.x, p1.y, p1.z, ulow, vlow);
                vertex(p2.x, p2.y, p2.z, ulow, vhigh);
                vertex(p3.x, p3.y, p3.z, uhigh, vhigh);
                vertex(p4.x, p4.y, p4.z, uhigh, vlow);
                endShape(CLOSE);
                popStyle();  
            }
        }
    }
    
    public void mapTexture(){
      pushStyle();
      textureMode(NORMAL);
      beginShape();
      texture(clothTex);
      vertex(nodes[0][nodes.length-1].pos.x, nodes[0][0].pos.y, 0, 0);
      vertex(nodes[0][nodes.length-1].pos.x, nodes[0][nodes.length-1].pos.y, 0, 1);
      vertex(nodes[nodes.length-1][nodes.length-1].pos.x, nodes[nodes.length-1][nodes.length-1].pos.y, 1, 1);
      vertex(nodes[nodes.length-1][0].pos.x, nodes[nodes.length-1][0].pos.y, 1, 0);
      endShape(CLOSE);
      popStyle();  
    }

    // Collision Detection
    public void updateCollision(Circle circle) {
        // self-circle collision
        Vec3 cpos = circle.pos;
        float cradius = circle.radius;
        for (int i = 0; i < nodes.length; i++) {
            for (int j = 0; j < nodes[0].length; j++) {
                Node node = nodes[i][j];
                float dist = cpos.distanceTo(node.pos);
                if (dist <= cradius + 0.005) {
                    Vec3 norm = (cpos.minus(node.pos).times(-1)).normalized();
                    Vec3 bounce = norm.times(dot(node.vel, norm));
                    node.vel.subtract(bounce.times(1 + COR));
                    node.pos.add(norm.times(COR+cradius-dist));
                }
            }
        }
    }

    public void updatePhysics(float dt) {
        // clone vn
        vn = new Vec3[nodes.length][nodes[0].length];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                vn[i][j] = nodes[i][j].vel;
            }
        }
        
        // hooks law
        updateHooksLaw(dt);
        
        // air drag
        updateAirdrag(dt);

        // pin top row
        for (int i = 0; i < cols; i++) {
            vn[0][i] = new Vec3(0, 0, 0);
        }
        
        // update vn to nodes and semi implicit integration
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                nodes[i][j].vel = vn[i][j];
                nodes[i][j].vel.add(gravity.times(dt));
                nodes[i][j].pos.add(nodes[i][j].vel.times(dt));
            }
        }
    }
    
    // Cloth Simulation (Hooke's law)
    private void updateHooksLaw(float dt) {
        // horizontal
        for (int i = 0; i < rows-1; i++) {
            for (int j = 0; j < cols; j++) {
                updateLink(i, j, i+1, j, dt, linkLength);
            }
        }
        for (int i = 0; i < rows-2; i++) {
            for (int j = 0; j < cols; j++) {
                updateLink(i, j, i+2, j, dt, linkLength);
            }
        }

        
        // vertical
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols-1; j++) {
                updateLink(i, j, i, j+1, dt, linkLength);
            }
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols-2; j++) {
                updateLink(i, j, i, j+2, dt, linkLength);
            }
        }

        // diagonal 1
        for (int i = 0; i < rows-1; i++) {
            for (int j = 0; j < cols-1; j++) {
                float restLength = linkLength * sqrt(2);
                updateLink(i, j, i+1, j+1, dt, restLength);
            }
        }
        
        // diagonal 2
        for (int i = 1; i < rows; i++) {
            for (int j = 0; j < cols-1; j++) {
                float restLength = linkLength * sqrt(2);
                updateLink(i, j, i-1, j+1, dt, restLength);
            }
        }
    }

    // Use hooks law to constrain links
    private void updateLink(int i, int j, int m, int n, float dt, float restL) {
        Node n1 = nodes[i][j];
        Node n2 = nodes[m][n];
        Vec3 e = n2.pos.minus(n1.pos);
        float l = e.length();
        e.normalize();
        float v1 = dot(e, n1.vel);
        float v2 = dot(e, n2.vel);
        float f = -ks * (restL-l) - kv * (v1-v2);
        f = f / restL;
        Vec3 fe = e.times(f * dt);
        // print(i);
        // print(", ");
        // print(j);
        // print(", ");
        // println(fe);
        vn[i][j].add(fe);
        vn[m][n].subtract(fe);
    }
    
    // Air drag   
    private void updateAirdrag(float dt) {
        for (int i = 0; i < rows-1; i++) {
            for (int j = 0; j < cols-1; j++) {
                Vec3 p1 = nodes[i][j].pos;
                Vec3 v1 = nodes[i+1][j+1].vel;
                Vec3 p2 = nodes[i+1][j].pos;
                Vec3 p3 = nodes[i][j+1].pos;
                Vec3 n = cross(p2.minus(p1), p3.minus(p1));
                float v = (v1.length() * dot(v1, n)) / (2 * n.length());
                Vec3 f = n.times(-airdrag * v);
                vn[i][j].add(f);
                vn[i+1][j].add(f);
                vn[i][j+1].add(f);
            }
        }
        for (int i = 0; i < rows-1; i++) {
            for (int j = 0; j < cols-1; j++) {
                Vec3 p1 = nodes[i+1][j+1].pos;
                Vec3 v1 = nodes[i+1][j+1].vel;
                Vec3 p2 = nodes[i+1][j].pos;
                Vec3 p3 = nodes[i][j+1].pos;
                Vec3 n = cross(p2.minus(p1), p3.minus(p1));
                float v = (v1.length() * dot(v1, n)) / (2 * n.length());
                Vec3 f = n.times(-airdrag * v);
                vn[i+1][j+1].add(f);
                vn[i+1][j].add(f);
                vn[i][j+1].add(f);
            }
        }

        Vec3 wind = new Vec3(0, 0, airdrag / 25 * dt);
        for (int i = 1; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                nodes[i][j].vel.add(wind);
            }
        }

    }

    private void printNodes() {
        for (Node[] row : nodes) {
            for (Node node : row) {
                print(node.pos);
                print(", ");
            }
            println("");
        }
    }
    
    private void printVels() {
        for (Vec3[] row : vn) {
            for (Vec3 v : row) {
                print(v);
                print(", ");
            }
            println("");
        }
    }

}
