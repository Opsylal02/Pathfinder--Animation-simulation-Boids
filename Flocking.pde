class Flock {
  ArrayList<Boid> boids;
 
  Flock() {
    boids = new ArrayList<Boid>();
  }

  void run() {
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid b = boids.get(i);
      b.run(boids);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
   ArrayList<Boid> getBoids() {
    return boids;
  }
 
  
}
