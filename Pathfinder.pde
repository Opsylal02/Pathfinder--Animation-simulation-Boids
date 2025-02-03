/* Camino A* con  evacuación de un grupo de agentes.Seguir al lider: Sólo se calculará 1 camino para todo el
grupo. Cuando cualquier agente llega al nodo del camino
buscado, todos buscan el siguiente nodo y así hasta el
final.*/

final int DISPLAY_SIZE_X = 1200;                      // Display width (pixels)  
final int DISPLAY_SIZE_Y = 900;                      // Display height (pixels)
final int[] BACKGROUND_COLOR = {220, 200, 210};      // Background color (RGB)
final int[] TEXT_COLOR = {0, 0, 0};
color[][] _colors;

Grid myGrid;
Flock flock;
Path path;
AStar aStar;
List<Nodo> caminoOptimo;
Nodo inicio;  // Declaración de la variable inicio
Nodo destino; // Declaración de la variable destino
ArrayList<Long> tiemposEjecucion = new ArrayList<Long>();
boolean guardarDatos = true;

void settings() {
  size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup() {
  myGrid = new Grid(30);
  flock = new Flock();
  path = new Path(myGrid);
  aStar = new AStar(myGrid);


  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
}

void draw() {
   background(0);
  
  myGrid.drawDestino();
  myGrid.drawmyGrid(true);
  
  // Llama al algoritmo A* para encontrar el camino óptimo
  if (inicio != null && destino != null) {
    caminoOptimo = aStar.encontrarCamino(inicio, destino);

    path = new Path(myGrid);
    for (Nodo nodo : caminoOptimo) {
      path.addPoint(nodo);
    }

    for (Boid b : flock.boids) {
      b.run(flock.boids);
      b.followPath(path);
    }
  }

 

  path.display();
  
  
 // realizarPruebas();
 
}
void mousePressed() {
  int xClic = mouseX;
  int yClic = mouseY;

  int xInicio = int(xClic / myGrid.cell_size);
  int yInicio = int(yClic / myGrid.cell_size);

  inicio = new Nodo(xInicio, yInicio);
  println("Inicio: (" + xInicio + ", " + yInicio + ")");

  destino = myGrid.getDestino();
  println("Destino: (" + destino.i + ", " + destino.j + ")");

  // Calcula el camino óptimo
  caminoOptimo = aStar.encontrarCamino(inicio, destino);

  // Crea un nuevo camino óptimo específico para este boid
  for (int i = 0; i < 5; i++) {
    Boid newBoid = new Boid(xClic, yClic, myGrid, path);
    flock.addBoid(newBoid);
  }

  path = new Path(myGrid);
  for (Nodo nodo : caminoOptimo) {
    path.addPoint(nodo);
  }
}

  
  /*código para realizar gráficas -> cálculo tiempo ejecución + crear csv
void realizarPruebas() {
  if (guardarDatos) {
    int numeroDePruebas = 10; // Cambia esto al número deseado de pruebas
    long[] tiemposDeEjecucion = new long[numeroDePruebas];

    for (int i = 0; i < numeroDePruebas; i++) {
      long startTime = System.nanoTime(); // Registro del tiempo de inicio en microsegundos

      // Verifica que 'inicio' y 'destino' no sean nulos antes de llamar a aStar.encontrarCamino
      if (inicio != null && destino != null) {
        caminoOptimo = aStar.encontrarCamino(inicio, destino);
      } else {
        System.out.println("Inicio o destino es nulo.");
        // Puedes tomar medidas adecuadas si 'inicio' o 'destino' son nulos
      }

      long endTime = System.nanoTime(); // Registro del tiempo de finalización en microsegundos
      long executionTime = (endTime - startTime) / 1000; // Convierte a microsegundos
      tiemposDeEjecucion[i] = executionTime;
    }

     String filePath = "2.csv";
    String[] lines = new String[tiemposDeEjecucion.length];
    for (int i = 0; i < tiemposDeEjecucion.length; i++) {
      lines[i] = String.valueOf(tiemposDeEjecucion[i]);
    }
    saveStrings(filePath, lines);
    guardarDatos = false; // Evita guardar los datos nuevamente
  
  }
}*/
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------------------------------------------------
  /*Navegación independiente: 1 camino para cada agente.
En este escenario sólo emplearemos la separación entre
agentes. //<>//
final int DISPLAY_SIZE_X = 1200;
final int DISPLAY_SIZE_Y = 900;
final int[] BACKGROUND_COLOR = {220, 200, 210};
color[][] _colors;

Grid myGrid;
Flock flock;
AStar aStar;
Path path;
List<Nodo> caminoOptimo;
Nodo inicio;
Nodo destino;
boolean calcularNuevoCamino = false; 
ArrayList<Long> tiemposEjecucion = new ArrayList<Long>();
void settings() {
  size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup() 
{
  myGrid = new Grid(30);
  flock = new Flock();
  path = new Path(myGrid); 
  aStar = new AStar(myGrid);
//realizarPruebas();
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  
}

void draw() {
  background(0);

  myGrid.drawDestino();
  myGrid.drawmyGrid(true);

  if (calcularNuevoCamino) {
    
    caminoOptimo = aStar.encontrarCamino(inicio, destino);
    path.update(caminoOptimo);
    calcularNuevoCamino = false; 
  }

  for (Boid b : flock.boids) {
    b.run(flock.boids);
    b.followPath(path);
  }

  path.display(); 
}

void mousePressed() {
   int xClic = mouseX;
  int yClic = mouseY;

  int xInicio = int(xClic / myGrid.cell_size);
  int yInicio = int(yClic / myGrid.cell_size);

  inicio = new Nodo(xInicio, yInicio);
  System.out.println("Inicio: (" + xInicio + ", " + yInicio + ")");

  destino = myGrid.getDestino();
  System.out.println("Destino: (" + destino.i + ", " + destino.j + ")");

  calcularNuevoCamino = true; // Establece la variable para calcular un nuevo camino

 
  List<Nodo> caminoOptimoParaBoid = aStar.encontrarCamino(inicio, destino);
  Path pathParaBoid = new Path(myGrid);
  pathParaBoid.update(caminoOptimoParaBoid);

  
  Boid newBoid = new Boid(xClic, yClic, myGrid, pathParaBoid);
  flock.addBoid(newBoid);

 
}
/*void realizarPruebas() {
  // Realiza pruebas de rendimiento de A* aquí
  // Puedes medir el tiempo de ejecución y agregarlo a 'tiemposEjecucion'

  // Luego, cuando hayas completado todas las pruebas, guarda los tiempos:
  String[] lines = new String[tiemposEjecucion.size()];
  for (int i = 0; i < tiemposEjecucion.size(); i++) {
    lines[i] = tiemposEjecucion.get(i).toString();
  }
  saveStrings("tiempos_ejecucion.csv", lines);
}
