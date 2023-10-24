class Circle {
    float x, y, r;  
    float red, green, blue;
    
    Circle(float x, float y, float r) {
        this.x = x;
        this.y = y;
        this.r = r;
    }
    
    Circle(float x, float y, float r, float red, float green, float blue) {
        this.x = x;
        this.y = y;
        this.r = r;
        this.red = red;
        this.green = green;
        this.blue = blue;
    }  
}

class Ellipse {
    float id;
    float x, y, w, h;  
    float red, green, blue;
    
    Ellipse(float id, float x, float y, float w, float h) {
        this.id = id;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
    
    Ellipse(float id, float x, float y, float w, float h, float red, float green, float blue) {
        this.id = id;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.red = red;
        this.green = green;
        this.blue = blue;
    }
    
}
