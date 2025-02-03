
class Nodo {
    int i, j;
    float F, G, H;
    Nodo padre ;
    boolean esInicial;
    boolean esFinal;
   boolean perteneceAlCamino; 
   
   
    Nodo(int i, int j) {
        this.i = i;
        this.j = j;
        this.F = 0.0;
        this.G = 0.0;
        this.H = 0.0;
        this.padre = null;
        this.esInicial = false;
        this.esFinal = false;
         this.perteneceAlCamino = false;
         
    }

    Nodo(int i, int j, float F, float G, float H, Nodo padre) {
        this(i, j); // Llama al constructor sin parámetros para evitar duplicar código
        this.F = F;
        this.G = G;
        this.H = H;
        this.padre = padre;
    }
        
public float getG() {
        return G;
    }

    public void setG(float G) {
        this.G = G;
    }
    
    public void setH(float H) {
    this.H = H;
    }
    public float getH() {
        return H;
    }
    public void setF(float F) {
        this.F = F;
    }
    public float getF() {
        return F;
    }

    public boolean esInicial() {
        return esInicial;
    }

    public void marcarComoInicial() {
        esInicial = true;
    }

    public boolean esFinal() {
        return esFinal;
    }

    public void marcarComoFinal() {
        esFinal = true;
    }
    
 public boolean esIgual(Nodo otroNodo) {
          if (otroNodo != null) {
        return this.i == otroNodo.i && this.j == otroNodo.j;
    } else {
        return false; 
    }
    }

public void setPadre(Nodo padre) {
        this.padre = padre;
    }
    
    public Nodo getPadre() {
        return padre;
    }
   
}
  
