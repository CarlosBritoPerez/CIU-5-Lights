import gifAnimation.*;
PGraphics lienzo;
PImage mapTexture, pcTexture, dataTexture, tutoTexture, postItTexture;

float minlat,minlon,maxlat,maxlon;

float[] lats,lons;
String[] nombres;
int nest = 0;
int r = 5;

float zoom;
int x;
int y;

Table Estaciones;

String state = "OFF";

GifMaker gif;
int gifCount = 0;

void setup() {
  size(800, 672, P3D);
  
  //Imagen del Mapa
  mapTexture=loadImage("map2.png");
  pcTexture=loadImage("pc.png");
  dataTexture=loadImage("datos.PNG");
  tutoTexture=loadImage("tutorial.PNG");
  postItTexture=loadImage("postIt.jpg");
  
  //Creamos lienzo par el mapa
  lienzo = createGraphics(pcTexture.width, pcTexture.height);
  lienzo.beginDraw();
  lienzo.background(20);
  lienzo.endDraw();

  //Latitud y longitud de los extremos del mapa de la imagen
  minlon = -15.5304;
  maxlon = -15.3656;
  minlat = 28.0705;
  maxlat = 28.1817;

  //Inicializa desplazamiento y zoom
  x = 0;
  y = 0;
  zoom = 1;

  //Compone imagen con estaciones sobre el lienzo
  dibujaMapayEstaciones(); 
  
  //gif = new GifMaker(this, "visualisation.gif");
  //gif.setRepeat(0);
}

void draw(){
  ambientLight(102, 102, 102);
  
  switch(state){
    case "MAP":
      map();
      postIt();
      break;
    case "DATA":
      data();
      postIt();
      break;
    case "OFF":
      pcOff();
      postIt();
      break;
    case "TUTO":
      tutorial();
      postIt();
      break;
    case "MAPZOOM":
      mapZoom();
      break;
    case "DATAZOOM":
      dataZoom();
      break;
    case "TUTOZOOM":
      tutoZoom();
      break;
  }
  gif();
}

void map() {
  background(8);
  translate(width/2,height/2,0);
  translate(-pcTexture.width/2+x,-pcTexture.height/2+y);
  image(lienzo, 0,0);
  
  screen(mapTexture, 248, 232, 210);
  moveBall();
}

void data(){
  background(8);
  translate(width/2,height/2,0);
  translate(-pcTexture.width/2+x,-pcTexture.height/2+y);
  image(lienzo, 0,0);
  
  screen(dataTexture, 212, 248, 248);
  moveBall();
}

void pcOff(){
  background(8);
  translate(width/2,height/2,0);
  translate(-pcTexture.width/2+x,-pcTexture.height/2+y);
  image(lienzo, 0,0);
  moveBall();
  
}

void tutorial(){
  background(8);
  translate(width/2,height/2,0);
  translate(-pcTexture.width/2+x,-pcTexture.height/2+y);
  image(lienzo, 0,0);

  screen(tutoTexture, 137, 235, 63);
  moveBall();
}

void mapZoom(){
  screenZoomed(mapTexture, 248, 232, 210);
}

void dataZoom(){
  screenZoomed(dataTexture, 212, 248, 248);
}

void tutoZoom(){
  screenZoomed(tutoTexture, 137, 235, 63);
}

void moveBall(){
  pushMatrix();
  if (mousePressed && mouseButton == RIGHT) {
    noStroke();
    translate(mouseX, mouseY, 150);
    sphere(60);
  }
  popMatrix();
}

void screen(PImage texture, int r, int g, int b){
  pushMatrix();
  pointLight(r, g, b, pcTexture.width/2+80, pcTexture.height/2-100, 90);
  textureMode(NORMAL);
  beginShape();
  texture(texture);
  vertex(pcTexture.width/2-25, pcTexture.height/2-180, 0, 0, 0);
  vertex(pcTexture.width/2+240, pcTexture.height/2-180, 0, 1, 0);
  vertex(pcTexture.width/2+240, pcTexture.height/2+10, 0, 1, 1);
  vertex(pcTexture.width/2-25, pcTexture.height/2+10, 0, 0, 1);
  endShape();
  popMatrix();
}

void screenZoomed(PImage texture, int r, int g, int b){
  pointLight(r, g, b, pcTexture.width/2+80, pcTexture.height/2-100, 400);
  textureMode(NORMAL);
  beginShape();
  texture(texture);
  vertex(0, 0, 0, 0, 0);
  vertex(pcTexture.width+200, 0, 0, 1, 0);
  vertex(pcTexture.width+200, pcTexture.height+200, 0, 1, 1);
  vertex(0, pcTexture.height+200, 0, 0, 1);
  endShape(); 
}

void postIt(){
  pushMatrix();
  textureMode(NORMAL);
  beginShape();
  texture(postItTexture);
  vertex(pcTexture.width/2-280, pcTexture.height/2-60, 0, 0, 0);
  vertex(pcTexture.width/2-160, pcTexture.height/2-60, 0, 1, 0);
  vertex(pcTexture.width/2-160, pcTexture.height/2+40, 0, 1, 1);
  vertex(pcTexture.width/2-280, pcTexture.height/2+40, 0, 0, 1);
  endShape();
  popMatrix();
}

//Rueda del ratón para modificar el zoom
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom += e/10;
  if (zoom<1)
    zoom = 1;
}

void keyReleased(){
  if(key == ENTER){ // turn on/off the screen
    if(state == "OFF"){
      state = "TUTO";
    }else{
      state = "OFF";
    }
  }
  if(key == TAB){ // swicth between screens
    if(state == "TUTO"){
      state = "DATA";
    }else if(state == "DATA"){
      state = "MAP";
    }else if(state == "MAP"){
      state = "TUTO";
    }else if(state == "TUTOZOOM"){
      state = "DATAZOOM";
    }else if(state == "DATAZOOM"){
      state = "MAPZOOM";
    }else if(state == "MAPZOOM"){
      state = "TUTOZOOM";
    }
  }
  if(key == ' '){ // zoom to the screen
    if(state == "MAP"){
      state = "MAPZOOM";
    }else if(state == "DATA"){
      state = "DATAZOOM";
    }else if(state == "TUTO"){
      state = "TUTOZOOM";
    }else if(state == "DATAZOOM"){
      state = "DATA";
    }else if(state == "TUTOZOOM"){
      state = "TUTO";
    }else if(state == "MAPZOOM"){
      state = "MAP";
    }
  }
}

void dibujaMapayEstaciones(){
  //Dibuja sobre el lienzo
  lienzo.beginDraw();
  //Imagen de fondo
  lienzo.image(pcTexture, lienzo.width-pcTexture.width, lienzo.height-pcTexture.height,pcTexture.width,pcTexture.height);
  lienzo.endDraw();
}

void gif(){
  if(gifCount % 5 == 0){
    gif.addFrame();    
  }
  if(gifCount > 700){
     gif.finish(); 
  }
  gifCount++;
}
