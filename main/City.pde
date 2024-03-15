// seuils de densite de population : 
int[] seuilsDens = {  5,   15,   30,   50,   80,  110,   150,
                    250,  500, 1000, 2000, 4000, 8000, 15000};

// seuils d'altitude des villes : 
int[] seuilsAlt = { 200,  300,  400,  500,  700,
                   1000, 1500, 2000, 3000, 4000};

// classe pour représenter les données d'une ville
public class City { 
      int postalcode; 
      String name; 
      float x; 
      float y; 
      float population; 
      float density; 
      float surface;
      float altitude;
      boolean toselect;
      boolean selected;
      
      public City(int p, String n, float x, float y, float pop, float d, float a) {
        this.postalcode = p;
        this.name = n; 
        this.x = x; 
        this.y = y; 
        this.population = pop; 
        this.density = d;
        this.surface = pop/d;
        this.altitude = a;
        this.selected = false;
        this.toselect = false;
      }
      
      boolean lowerThan(City other) {
        //return  this.density < other.density;
        return this.altitude < other.altitude;
      }
      
      boolean greaterThan(City other) {
        //return  this.density > other.density;
        return this.altitude > other.altitude;
      }
      
      // convertie la valeur, selon les valeurs de seuils, en une valeur entre min et max
      float getData(int[] seuils, float value, int min, int max) {
        int i = 0;
        float r = max;
        while(i<seuils.length) {
          if(value < seuils[i]) { 
            r = map(i, 0, seuils.length+1, min, max);
            i = seuils.length;
          }
          else i++;
        }
        return r;
      }
      
      // convertie une valeur en couleur
      int getColor(int[] seuils, float value) {return (int) getData(seuils, value, 255, 0);}
      // convertie une valeur en échelle
      float getScale(int[] seuils, float value) {return getData(seuils, value, 5, 25);}
      
      // fonction de dessin 
      void draw(int x, int y) {
        drawMixColor(x,y);
        //drawDemiCircles(x, y);
        //drawAltScaleDensColor(x, y);
        //drawDensScaleAltColor(x, y);
      }
      
      // mélange de couleur selon densité et altitude
      void drawMixColor(int x, int y) {
        int colorDens = getColor(seuilsDens,this.density);
        float colorAlt = getColor(seuilsAlt,this.altitude);
        if (this.toselect) {
          fill(color(0,0,255));
          circle(x,y,10);
          textSize(16);
          textAlign(LEFT,CENTER);
          String s = this.name;
          float sw = textWidth(s);
          fill(color(0,0,0,200));
          rect(x+5, y+8, sw+10, 22);
          if(this.selected) fill(color(255,0,0));
          else fill(color(255,255,255));
          text(this.name, x+10, y+16);
        }
        else if (this.selected) {
          fill(color(255,0,0));
          circle(x,y,8);
        }
        else {
          fill(color(colorDens,colorAlt,0));
          circle(x,y,5);
        }
      }
      
      // dessin de cercle où la moitié gauche représente la densité et la moitié droite l'altitude
      void drawDemiCircles(int x, int y) {
        int colorDens = getColor(seuilsDens,this.density);
        int colorAlt = getColor(seuilsAlt,this.altitude);
        fill(color(colorDens,0,0));
        arc(x, y, 10, 10, HALF_PI, PI+HALF_PI, CHORD);
        fill(color(0,colorAlt,0));
        arc(x, y, 10, 10, PI+HALF_PI, 2*PI+HALF_PI, CHORD);
      }
      
      // l'échelle change avec l'altitude et la couleur avec la densité
      void drawAltScaleDensColor(int x, int y) {
        int colorDens = getColor(seuilsDens,this.density);
        float scaleAlt = getScale(seuilsAlt,this.altitude);
        fill(color(colorDens,0,0));
        circle(x,y,scaleAlt);
      }
      
      // l'échelle change avec la densité et la couleur avec l'altitude
      void drawDensScaleAltColor(int x, int y) {
        float scaleDens = getScale(seuilsDens,this.density);
        int colorAlt = getColor(seuilsAlt,this.altitude);
        fill(color(0,colorAlt,0));
        circle(x,y,scaleDens);
      }
    
      
}
