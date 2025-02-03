// The Boid class
/*Camino A* con  evacuación de un grupo de agentes.Seguir al lider: Sólo se calculará 1 camino para todo el
grupo. Cuando cualquier agente llega al nodo del camino
buscado, todos buscan el siguiente nodo y así hasta el
final.*/
class Boid {

 PVector position;
 PVector location;
 PVector velocity;
 PVector acceleration;
 float r;
 float maxforce;    // Maximum steering force
 float maxspeed;    // Maximum speed
 float weight ; 
 int currentVertexIndex;
 int timer = 0;  // Inicializa el temporizador
 int targetVertex = 0;  // Inicializa el objetivo del vértice
// Nodo targetNode;
PVector target = new PVector(0, 0); 
  int radio=1;
  PVector direccionMouse = new PVector(0, 0); 
 Path path;
   Grid grid;
   
   Boid(float  x, float y, Grid grid,Path path) {
    acceleration = new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
     position = new PVector(x,y);
    r = 4.0;
    maxspeed = 1.8;
    maxforce = 0.04;
    weight = 1.0;
    this.grid = grid;
    this.path= path;
     //targetNode = grid.getDestino();
    
     
   
  }

  void run(ArrayList<Boid> boids) {
   
    flock(boids);    
    //separate(boids);
    fleeWalls(grid);
 
    update();  
    render();
  }
  

  void applyForce(PVector force) {
    
    acceleration.add(force);
  }
  

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
   
    
    
   if (keyPressed) {
       
    if (key == '1') 
    {
      cogerMouse(); // Comportamiento "seek" activado al presionar '1'
    }  if (key == '2')
    {
      fleeMouse();
      //borders(); // Comportamiento "flee" activado al presionar '2'
    }  if (key == '3') 
    {
       //followPath(path); // Activa el comportamiento "followPath" al presionar '3'
       }
   }
  }
      
  

void cogerMouse(){
  PVector v = new PVector(mouseX - position.x, mouseY - position.y);
  v.limit(0.2); 
  v.normalize();
  applyForce(v);
}

void fleeMouse() {
 float fleeRadius = 60; // Radio de huida
  float d = dist(mouseX, mouseY, position.x, position.y);

  if (d < fleeRadius) {
    // Calcular la dirección hacia la que huir
    PVector escape = new PVector(mouseX - position.x, mouseY - position.y);
    escape.normalize();

    // Invertir la dirección para que sea un rebote
    escape.mult(-1);

    // Aplicar la fuerza de rebote
    applyForce(escape);
  }
}

void seekMouse(){
  PVector v = new PVector(mouseX*1.2 - position.x, mouseY*1.2 - position.y);
  v.limit(0.2); 
  v.normalize();
  applyForce(v);
}
  // Method to update position
 void update() {
  // Elige un vértice al azar
  
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    steer.mult(weight);
    return steer;
  }
  
  PVector arrive(PVector target) {
  PVector desired = PVector.sub(target, position);
  float d = desired.mag();
  desired.normalize();

  
  float maxArrivalSpeed = maxspeed;
  float slowRadius = 50; // Radio para comenzar a reducir la velocidad
  if (d < slowRadius) {
    maxArrivalSpeed = map(d, 0, slowRadius, 0, maxspeed);
  }
  desired.mult(maxArrivalSpeed);

  // Calcular la fuerza de dirección y aplicarla
  PVector steer = PVector.sub(desired, velocity);
  steer.limit(maxforce);
  return steer;
}


  void render() {
   
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound

    
 void borders() {
  

   float buffer = 100;

  if (position.x < buffer) {
    PVector desired = new PVector(maxspeed, velocity.y);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  if (position.y < buffer) {
    PVector desired = new PVector(velocity.x, maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  if (position.x > width - buffer) {
    PVector desired = new PVector(maxspeed, velocity.y);
    PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce);
    applyForce(steer);
  }
  if (position.y > height - buffer) {
    PVector desired = new PVector(velocity.x, maxspeed);
    PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
  }
 // Esta función calcula el punto normal desde un punto (p) a un segmento (a-b)
PVector getNormalPoint(PVector p, PVector a, PVector b) {
  PVector ap = PVector.sub(p, a);
  PVector ab = PVector.sub(b, a);
  ab.normalize();
  ab.mult(ap.dot(ab));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}

void followPath(Path path) {
  if (path != null && path.getNumPoints() > 0) {
    Nodo targetNode = path.getPoint(currentVertexIndex);

    if (targetNode != null) {
      PVector target = new PVector(targetNode.i * myGrid.cell_size + myGrid.cell_size / 2, targetNode.j * myGrid.cell_size + myGrid.cell_size / 2);
      PVector desired = PVector.sub(target, position);
      float d = desired.mag();

      if (d < 4 || (d < 10 && currentVertexIndex == path.getNumPoints() - 1)) {
    // Cambia al siguiente punto en el camino si estás lo suficientemente cerca del nodo destino
    if (currentVertexIndex < path.getNumPoints() - 1) {
        currentVertexIndex++;
    } else {
        
    }
} else {
    // Continúa moviéndote hacia el nodo destino
    desired.setMag(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
}

    }
  }
}


  
  void fleeWalls(Grid grid) {
    ArrayList<PVector> wallPositions = new ArrayList<PVector>();

    for (int[] wall : grid.gridWalls) {
        // Convierte las coordenadas de int[] a PVector
        float x = wall[0] * grid.cell_size + grid.cell_size / 2;
        float y = wall[1] * grid.cell_size + grid.cell_size / 2;
        PVector wallPosition = new PVector(x, y);
        wallPositions.add(wallPosition);
    }

   
    for (PVector wallPosition : wallPositions) {
        float fleeRadius = 20.0; // Radio de huida de las paredes
        float d = PVector.dist(position, wallPosition);

        if (d < fleeRadius) {
            // Calcular la dirección para huir de la pared
            PVector escape = PVector.sub(position, wallPosition);
            escape.normalize();

            escape.mult(1.1); 

           
            applyForce(escape);
        }
    }
}

}
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------

/*Navegación independiente: 1 camino para cada agente.
En este escenario sólo emplearemos la separación entre
agentes.
// The Boid class

class Boid {

 PVector position;
 PVector location;
 PVector velocity;
 PVector acceleration;
 float r;
 float maxforce;    // Maximum steering force
 float maxspeed;    // Maximum speed
 float weight ; 
 int currentVertexIndex;
 int timer = 0;  // Inicializa el temporizador
 int targetVertex = 0;  // Inicializa el objetivo del vértice
// Nodo targetNode;
PVector target = new PVector(0, 0); 
  int radio=1;
  PVector direccionMouse = new PVector(0, 0); 
 Path path;
   Grid grid;
   private Path individualPath;
   Boid(float  x, float y, Grid grid,Path path) {
    acceleration = new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
     position = new PVector(x,y);
    r = 5.0;
    maxspeed = 1.8;
    maxforce = 0.04;
    weight = 1.0;
    this.grid = grid;
    this.path= path;
     individualPath = new Path(grid); 
   
  
  // Copia los puntos del camino global al camino individual uno por uno
  for (int i = 0; i < path.getNumPoints(); i++) {
    individualPath.addPoint(path.getPoint(i));
   
  }
   }

  void run(ArrayList<Boid> boids) {
   
    flock(boids);    
    //separate(boids);
    fleeWalls(grid);
 
    update();  
    render();
  }
  

  void applyForce(PVector force) {
    
    acceleration.add(force);
  }
  

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
   
    
    
   if (keyPressed) {
       
    if (key == '1') 
    {
      cogerMouse(); // Comportamiento "seek" activado al presionar '1'
    }  if (key == '2')
    {
      fleeMouse();
      //borders(); // Comportamiento "flee" activado al presionar '2'
    }  if (key == '3') 
    {
       //followPath(path); // Activa el comportamiento "followPath" al presionar '3'
       }
       if (key == '4') 
    {
       borders(); // Activa el comportamiento "followPath" al presionar '3'
       }
         
          
              
              
  } 

  }

void cogerMouse(){
  PVector v = new PVector(mouseX - position.x, mouseY - position.y);
  v.limit(0.2); 
  v.normalize();
  applyForce(v);
}

void fleeMouse() {
 float fleeRadius = 60; // Radio de huida
  float d = dist(mouseX, mouseY, position.x, position.y);

  if (d < fleeRadius) {
    // Calcular la dirección hacia la que huir
    PVector escape = new PVector(mouseX - position.x, mouseY - position.y);
    escape.normalize();

    // Invertir la dirección para que sea un rebote
    escape.mult(-1);

    // Aplicar la fuerza de rebote
    applyForce(escape);
  }
}

void seekMouse(){
  PVector v = new PVector(mouseX*1.2 - position.x, mouseY*1.2 - position.y);
  v.limit(0.2); 
  v.normalize();
  applyForce(v);
}
  // Method to update position
 void update() {
  // Elige un vértice al azar
  
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    steer.mult(weight);
    return steer;
  }
  
  PVector arrive(PVector target) {
  PVector desired = PVector.sub(target, position);
  float d = desired.mag();
  desired.normalize();

  // Controlar la velocidad basada en la distancia al objetivo
  float maxArrivalSpeed = maxspeed;
  float slowRadius = 50; // Radio para comenzar a reducir la velocidad
  if (d < slowRadius) {
    maxArrivalSpeed = map(d, 0, slowRadius, 0, maxspeed);
  }
  desired.mult(maxArrivalSpeed);

  // Calcular la fuerza de dirección y aplicarla
  PVector steer = PVector.sub(desired, velocity);
  steer.limit(maxforce);
  return steer;
}


  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound

    
 void borders() {
  

   float buffer = 100;

  if (position.x < buffer) {
    PVector desired = new PVector(maxspeed, velocity.y);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  if (position.y < buffer) {
    PVector desired = new PVector(velocity.x, maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  if (position.x > width - buffer) {
    PVector desired = new PVector(maxspeed, velocity.y);
    PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce);
    applyForce(steer);
  }
  if (position.y > height - buffer) {
    PVector desired = new PVector(velocity.x, maxspeed);
    PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
  }
 // Esta función calcula el punto normal desde un punto (p) a un segmento (a-b)
PVector getNormalPoint(PVector p, PVector a, PVector b) {
  PVector ap = PVector.sub(p, a);
  PVector ab = PVector.sub(b, a);
  ab.normalize();
  ab.mult(ap.dot(ab));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}



void followPath(Path path) {
  if (individualPath != null && individualPath.getNumPoints() > 0) {
    Nodo targetNode = individualPath.getPoint(currentVertexIndex);

    if (targetNode != null) {
      PVector target = new PVector(targetNode.i * myGrid.cell_size + myGrid.cell_size / 2, targetNode.j * myGrid.cell_size + myGrid.cell_size / 2);
      PVector desired = PVector.sub(target, position);
      float d = desired.mag();

      if (d < 10) {
        // Verifica si el boid ha alcanzado el nodo destino
        if (currentVertexIndex < individualPath.getNumPoints() - 1) {
          // Cambia al siguiente punto en el camino si estás lo suficientemente cerca del nodo actual
          currentVertexIndex++;
        } else {
          // El boid ha llegado al nodo destino
          currentVertexIndex = individualPath.getNumPoints() - 1; // Asegura que el índice esté en el último nodo
          velocity.mult(0); // Detiene el boid
        }
      } else {
        desired.setMag(maxspeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce);
        applyForce(steer);
      }
    }
  }
}



  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  
  void fleeWalls(Grid grid) {
    ArrayList<PVector> wallPositions = new ArrayList<PVector>();

    for (int[] wall : grid.gridWalls) {
        // Convierte las coordenadas de int[] a PVector
        float x = wall[0] * grid.cell_size + grid.cell_size / 2;
        float y = wall[1] * grid.cell_size + grid.cell_size / 2;
        PVector wallPosition = new PVector(x, y);
        wallPositions.add(wallPosition);
    }

    // Calcular la fuerza de huida de las paredes y aplicarla a este boid
    for (PVector wallPosition : wallPositions) {
        float fleeRadius = 17.0; // Radio de huida de las paredes
        float d = PVector.dist(position, wallPosition);

        if (d < fleeRadius) {
            // Calcular la dirección para huir de la pared
            PVector escape = PVector.sub(position, wallPosition);
            escape.normalize();

            // Invertir la dirección para que sea un rebote
            escape.mult(1); // Aumenta la magnitud para un mejor rebote

            // Aplicar la fuerza de rebote
            applyForce(escape);
        }
    }
}

}*/
