
import java.util.*;

public class AStar {
    Grid grid;

    public AStar(Grid grid) {
        this.grid = grid;
    }

   public List<Nodo> encontrarCamino(Nodo inicio, Nodo destino) {
    List<Nodo> camino = new ArrayList<>();
    PriorityQueue<Nodo> ABIERTA = new PriorityQueue<>(Comparator.comparing(Nodo::getF));
    Set<Nodo> CERRADA = new HashSet<>();
    Map<Nodo, Float> G = new HashMap<>();

    ABIERTA.add(inicio);
    G.put(inicio, 0.0f);

    long startTime = System.nanoTime();

    while (!ABIERTA.isEmpty()) {
        Nodo N = ABIERTA.poll();

        if (N.esIgual(destino)) {
            camino = reconstruirCamino(N, G);
            break;
        }

        CERRADA.add(N);

        List<Nodo> sucesores = grid.get_neighbors(N);

        for (Nodo sucesor : sucesores) {
            if (existeEnLista(sucesor, CERRADA)) {
                continue;
            }

            float tempG = G.get(N) + calculaG(N, sucesor);

            if (!existeEnLista(sucesor, ABIERTA) || !G.containsKey(sucesor) || tempG < G.get(sucesor)) {
                sucesor.setPadre(N);
                G.put(sucesor, tempG);
                sucesor.setH(calculaH(sucesor, destino));
                sucesor.setF(tempG + sucesor.getH());

                if (!existeEnLista(sucesor, ABIERTA)) {
                    ABIERTA.add(sucesor);
                }
            }
        }
    }

    long endTime = System.nanoTime();
    long executionTime = (endTime - startTime) / 1_000_000; // Tiempo en milisegundos


   
    if (!camino.isEmpty()) {
        return camino;
    } else {
        
        return new ArrayList<>();
    }
}

    private float calculaG(Nodo a, Nodo b) {
        float dx = Math.abs(a.i - b.i);
        float dy = Math.abs(a.j - b.j);
        return dx + dy;
    }

    private float calculaH(Nodo a, Nodo b) {
        float dx = Math.abs(a.i - b.i);
        float dy = Math.abs(a.j - b.j);
        return dx + dy;
    }

    private List<Nodo> reconstruirCamino(Nodo nodo, Map<Nodo, Float> G) {
        List<Nodo> camino = new ArrayList<>();
        while (nodo != null) {
            camino.add(nodo);
            nodo = nodo.getPadre();
        }
        Collections.reverse(camino);
        return camino;
    }

    private boolean existeEnLista(Nodo nodo, Collection<Nodo> lista) {
        for (Nodo n : lista) {
            if (n.esIgual(nodo)) {
                return true;
            }
        }
        return false;
    }
}
