//pseudocodigo

//crear población inicial;
//Mientras  !criterio de parada hacer:
//Evaluar poblacion
//Obtener reproductores
//reproducir individuos
//evaluar descendientes
//reemplazar el arreglo original por descendientes sobrevivientes segun esquema de reemplazo
//siguiente generacion 
//fin while
import java.util.Arrays;

//crear individuo

//int main() {
void setup() {
  Individual[] population = init_population(10);
  print_fits(population);
  Arrays.sort(population);
  print_fits(population);
  
  System.out.println(objetive_fun(population[1].x, population[1].y));
}

void print_fits(Individual[] population){
  for (int i=0; i<10;i++){
    System.out.println(population[i].x+", "+population[i].x+" objetivo: "+population[i].objetive);
  }
  System.out.println("\n");
}


class Individual implements Comparable<Individual>{
  float x,y,objetive;
  
  Individual(float x, float y){
    this.x=x;
    this.y=y;
    this.objetive=objetive_fun(this.x,this.y);
  }
  
  @Override
  public int compareTo(Individual i) {
    if(this.objetive < i.get_objetive_value()) return 1;
    if(this.objetive == i.get_objetive_value()) return 0;
       //if(this.age > p.getAge()) return 1;
    else return -1;
    }
  
  void update_objetive(){
    this.objetive=objetive_fun(this.x, this.y);
  }
  
  float get_objetive_value(){
    return this.objetive;
  }
}

//funcion objetivo
void print(){
  System.out.println("Hola");
}

float objetive_fun(float x, float y){
  return 20+((float)Math.pow(x,2)-10*cos(2*PI*x)+(float)Math.pow(y,2)-10*cos(2*PI*y));
}

Individual[] init_population(int size){
  Individual[] popu = new Individual[size];
   for (int i=0; i < size; i++){
     popu[i] = new Individual(random(-5.12, 5.12),random(-5.12, 5.12));
     //System.out.println("gola");
   }
   return popu;
}

//float z = funtion(population[1].x,population[1].y);
//System.out.println(population[1].x);
