import java.util.*;


class Grid {
  
  int cell_size;
  int nrows, ncols;
  Boolean g [][]; 
  ArrayList <int []> Walls;
  ArrayList <int []> gridWalls;
  Nodo destino;

  int SX, SY;
  
  Grid(int csize){
    
    Walls = new ArrayList();
    gridWalls = new ArrayList();
    load_map("mapa.txt");
    
    cell_size = csize;
    nrows = int(SX / (cell_size));
    ncols = int(SY / (cell_size));
    println("nrows,ncols:",nrows,ncols);
    
    g = new Boolean[nrows][ncols];
    for (int i=0;i<nrows;i++)
      for (int j=0;j<ncols;j++)
        g[i][j] = false;
        
    for (int[] w:Walls){
      int i1 = w[0]; 
      int j1 = w[1];
      int i2 = w[2]; 
      int j2 = w[3];
      for (int i=i1; i<=i2; i++)
       for (int j=j1; j<=j2; j++) {
         int [] c = pix2cell(i,j);   
         if (g[c[0]][c[1]] == false){
           g[c[0]][c[1]] = true;
           gridWalls.add(c);
         }
       }
    }
    

 generarNodoDestinoAleatorio();
  }
  
  int[] pix2cell(int x, int y){
  
    int[] c = new int[2];
    c[0] = int(x/cell_size);
    c[1] = int(y/cell_size);
    
    return c;
  }
 

  
  void load_map(String file_name){
    
    
    String[] lines = loadStrings(file_name);
    println("there are " + lines.length + " lines");
    for (int i = 0 ; i < lines.length; i++) {
      println(lines[i]);
      String[] toks = split(lines[i], " ");
      if (toks[0].startsWith("SIZE_X"))
        SX = int(toks[1]);
      else if (toks[0].startsWith("SIZE_Y"))
        SY = int(toks[1]);
      else if (toks[0].startsWith("W")){
        int w[] = new int[4];
        w[0] = int(toks[1]);
        w[1] = int(toks[2]);
        w[2] = int(toks[3]);
        w[3] = int(toks[4]);
        Walls.add(w);
      }
    }
}

 List<Nodo> get_neighbors(Nodo n) {
    List<Nodo> vecinos = new ArrayList<Nodo>();

    int i = n.i;
    int j = n.j;

    if (i + 1 < ncols && !g[i + 1][j]) {
        vecinos.add(new Nodo(i + 1, j));
    }
    if (j + 1 < nrows && !g[i][j + 1]) {
        vecinos.add(new Nodo(i, j + 1));
    }
    if (i - 1 >= 0 && !g[i - 1][j]) {
        vecinos.add(new Nodo(i - 1, j));
    }
    if (j - 1 >= 0 && !g[i][j - 1]) {
        vecinos.add(new Nodo(i, j - 1));
    }

    return vecinos;
}

  
  void drawmyGrid(Boolean show_lines){
    // lines
    if (show_lines){
    for (int i=0;i<ncols;i++)
      line(0,i*cell_size, width,i*cell_size);
      
    for (int j=0;j<nrows;j++)
      line(j*cell_size,0,  j*cell_size,height);  
    }
    
    fill(255);
    for (int i=0;i<nrows;i++){
      for (int j=0;j<ncols;j++)
         if ( g[i][j] == true)
             rect(i*cell_size, j*cell_size, cell_size, cell_size);
    }
   noFill();
  }   
  
  
  
 void drawDestino() {
        if (destino != null) {
            fill(0, 255, 0);  // Color verde para el nodo destino
            rect(destino.i * cell_size, destino.j * cell_size, cell_size, cell_size);
        }
    }
   void setDestino(Nodo nodoDestino) {
        destino = nodoDestino;
    }
   
    void  generarNodoDestinoAleatorio() {
  int randomX = int(random(SX)); // Genera una coordenada x aleatoria dentro de los límites del mapa
    int randomY = int(random(SY)); // Genera una coordenada y aleatoria dentro de los límites del mapa

    // Convierte las coordenadas aleatorias en una celda de la cuadrícula
    int[] destinoCell = pix2cell(randomX, randomY);

    // Crea un nuevo nodo destino usando la celda de la cuadrícula
    destino = new Nodo(destinoCell[0], destinoCell[1]);
  
}
public Nodo getDestino() {
        return destino;
    }

  boolean isCellOccupied(int[] cell) {
  int i = cell[0];
  int j = cell[1];
  if (i >= 0 && i < nrows && j >= 0 && j < ncols) {
    return g[i][j];  
  } else {
    return true; 
  }
}
  
}
//---------------------------------------------------------------------------------------------------------------------------------
