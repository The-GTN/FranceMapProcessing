//globally
//declare the min and max variables that you need in parseInfo
float minX, maxX;
float minY, maxY;
int totalCount; // total number of places
int minPopulation, maxPopulation;
int minSurface, maxSurface;
int minAltitude, maxAltitude;
int minDensite = 100000; 
int maxDensite = 0;

//declare the variables corresponding to the column ids for x and y
int x = 1;
int y = 2;

// and the tables in which the city coordinates will be stored
float xList[];
float yList[];

// visual variables
int draw_width = 600;
int draw_height = 500;
int ajust = 25;
int minPopulationToDisplay = 10000;
float displayPop = 1;
int xmouse = 0;
int ymouse = 0;
int selected = 0;

// SLIDER 
float slider_width = 50;
float slider_height = 10;
float slider_posx = 350;
float slider_posy = 650;
float slider_minX = slider_posx-100+(slider_width/2);float slider_maxX = slider_posx+100-(slider_width/2);
float slider_begin = slider_posx - 100; float slider_end = slider_posx + 100;
boolean slider_over = false;
boolean slider_locked = false;
float slider_xoff;

// les données de villes
City cities[];

// initialisation du programme
void setup() {
  //size(800,800);
  fullScreen();
  readData();
}

// Lecture des données
void readData() {
  String[] lines = {};
  try{
    lines = loadStrings("../TP1/villes.tsv");
  }
  catch(NullPointerException e) {
    try {
      lines = loadStrings("./villes.tsv");
    }
    catch (NullPointerException e2) { exit();}
  }
   
  
  parseInfo(lines[0]); // read the header line
  
  xList = new float[totalCount-2];
  yList = new float[totalCount-2];
  
  cities = new City[totalCount-2];
  
  float pop, surface, dens, alt;
  for (int i = 2 ; i < totalCount ; i++) {
    String[] columns = split(lines[i], TAB);
    xList[i-2] = float(columns[1]);
    yList[i-2] = float(columns[2]);
    pop = float(columns[5]);
    surface = float(columns[6]);
    alt = float(columns[7]);
    dens = pop/surface;
    if(dens > maxDensite) maxDensite = (int) dens;
    if(dens < minDensite) minDensite = (int) dens;
    cities[i-2] = new City(int(columns[0]),columns[4],xList[i-2],yList[i-2],pop,dens,alt);
  }
  //triRapide(cities);
}

// formatage des données
void parseInfo(String line) {
  String infoString = line.substring(2); // remove the #
  String[] infoPieces = split(infoString, ',');
  totalCount = int(infoPieces[0]);
  minX = float(infoPieces[1]);
  maxX = float(infoPieces[2]);
  minY = float(infoPieces[3]);
  maxY = float(infoPieces[4]);
  minPopulation = int(infoPieces[5]);
  maxPopulation = int(infoPieces[6]);
  minSurface = int(infoPieces[7]);
  maxSurface = int(infoPieces[8]);
  minAltitude = int(infoPieces[9]);
  maxAltitude = int(infoPieces[10]);
}

// ajustement d'une coordonnée X pour le rendu final
float mapX(float x) {
 return ajust + map(x, minX, maxX, 0, draw_width);
}

// ajustement d'une coordonnée Y pour le rendu final
float mapY(float y) {
 return ajust + map(y, minY, maxY, draw_height, 0);
}

// fonction de dessin
void draw(){
  background(255);
  drawslider();
  int pop = Math.round(minPopulationToDisplay*displayPop);
  textSize(32);
  fill(0, 0, 0);
  textAlign(BASELINE);
  text("Afficher les populations supérieures à "+Integer.toString(pop), 50, 600); 
  int x, y;
  double dist = 1000000000;
  int drawx = 0, drawy = 0;
  for (int i = 0 ; i < totalCount-2 ; ++i) {
    x = (int) mapX(xList[i]);
    y = (int) mapY(yList[i]);
    cities[i].toselect = false;
    if(cities[i].population > minPopulationToDisplay*displayPop) {
      cities[i].draw(x,y);
      double d = Math.sqrt(Math.pow((xmouse-x),2) + Math.pow((ymouse-y),2));
      if (d < dist){dist = d;selected = i;drawx = x;drawy = y;}
    }
  }
  if(xmouse < draw_width+200 && ymouse < draw_height+50) {
    cities[selected].toselect = true;
    //line(xmouse, ymouse, drawx, drawy);
    fill(color(0,0,0,125));
    circle(xmouse,ymouse,(float) dist*2);
    cities[selected].draw(drawx,drawy);
  }
}

// dessin du slider
void drawslider() {
  rectMode(CENTER);
  line (slider_begin, slider_posy, slider_end, slider_posy);
  if (mouseX < slider_posx+(slider_width/2) && mouseX > slider_posx-(slider_width/2) && mouseY < slider_posy+(slider_height/2) && mouseY > slider_posy-(slider_height/2)) 
    { fill(200); slider_over = true;}
  else {fill(255); slider_over = false;}
  if (slider_posx < slider_minX) slider_posx = slider_minX;
  if (slider_posx > slider_maxX) {
    //slider_posx = slider_maxX;
    fill(color(150,0,0));
  }
  rect(slider_posx, slider_posy, slider_width, slider_height);
  rectMode(BASELINE);
}


// lorsqu'une touche du clavier est pressée
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) displayPop += 0.01; 
    else if(keyCode == RIGHT) displayPop += 0.1;
    else if(keyCode == LEFT) displayPop -= 0.1;
    else if (keyCode == DOWN) displayPop -= 0.01;
  }
  else if (key == BACKSPACE || key == ENTER) displayPop = 1;
  redraw();
}


void mousePressed() {
  if (slider_over) {
    slider_locked = true;
    slider_xoff = mouseX-slider_posx;
  }
}
void mouseDragged() {
  if (slider_locked) {
    slider_posx = mouseX-slider_xoff;
    displayPop = map(slider_posx, slider_minX, slider_maxX, 0, 2);
    if (displayPop < 0) displayPop = 0; 
    //if (displayPop > 2) displayPop = 2;
    redraw();
  }
}
void mouseReleased() {
  slider_locked = false;
}

void mouseMoved() {
  xmouse = mouseX;
  ymouse = mouseY;
}

void mouseClicked() {
  if (!slider_locked && !slider_over) {
    cities[selected].selected = !cities[selected].selected;
    displayPop = ((cities[selected].population) - 1)/minPopulationToDisplay;
    redraw();
  }
}
 
 
// algo tri rapide :  http://www.dailly.info/ressources/tri/java/rapide.html
public static void triRapide(City tableau[])
    {
    int longueur=tableau.length;
    triRapide(tableau,0,longueur-1);
    }

// algo tri rapide :  http://www.dailly.info/ressources/tri/java/rapide.html
private static int partition(City tableau[],int deb,int fin)
    {
    int compt=deb;
    City pivot=tableau[deb];
    for(int i=deb+1;i<=fin;i++)
        {
        if (tableau[i].greaterThan(pivot))
            {
            compt++;
            echanger(tableau,compt,i);
            }
        }
    echanger(tableau,deb,compt);
    return(compt);
    }
    
// algo tri rapide :  http://www.dailly.info/ressources/tri/java/rapide.html
private static void echanger(City tableau[],int a,int b) {
    City temp = tableau[a];
    tableau[a] = tableau[b];
    tableau[b] = temp;
}

// algo tri rapide :  http://www.dailly.info/ressources/tri/java/rapide.html
private static void triRapide(City tableau[],int deb,int fin)
    {
    if(deb<fin)
        {
        int positionPivot=partition(tableau,deb,fin);
        triRapide(tableau,deb,positionPivot-1);
        triRapide(tableau,positionPivot+1,fin);
        }
    }
