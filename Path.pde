public class Path {
    private ArrayList<Nodo> pathPoints;
  private Grid grid;
 

    public Path(Grid grid) {
        pathPoints = new ArrayList<>();
          this.grid = grid;
    }

    public void addPoint(Nodo point) {
        pathPoints.add(point);
    }

    public Nodo getPoint(int index) {
        if (index >= 0 && index < pathPoints.size()) {
            return pathPoints.get(index);
        } else {
            return null; // Manejar errores aquí
        }
    }

    public int getNumPoints() {
        return pathPoints.size();
    }
public void update(List<Nodo> newPoints) { //<>//
      
        pathPoints.addAll(newPoints);
    
    }
    public void display() {
  noFill(); // Sin relleno
  stroke(255); // Color rojo para los puntos (puedes ajustar el color)
  float originalStrokeWeight = 1; // Valor original del grosor de línea para las celdas del grid
  float pointRadius = 7; // Tamaño de los puntos

  for (Nodo point : pathPoints) {
    float x = point.i * grid.cell_size + grid.cell_size / 2;
    float y = point.j * grid.cell_size + grid.cell_size / 2;
    
    fill(255); // Establece el color de relleno en blanco (puedes ajustar el color)
    ellipse(x, y, pointRadius, pointRadius); // Dibuja un punto relleno en el centro de cada celda
  }
  
  strokeWeight(originalStrokeWeight);
}
}
