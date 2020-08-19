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

int prob_array[];
 Individual[] population;
 Individual optimal_individual;
//crear individuo

//int main() {
void setup() {
  int generation_size = 500;
  Individual[] childrens;
  population = init_population(10);
  optimal_individual = new Individual(999999);
  System.out.println(optimal_individual.objetive);
  //////////////////////////////
  update_best();
  print_fits(population);
  Arrays.sort(population);
  print_fits(population);
  
  prob_array = generate_prob_array(population);
  Individual[] selected_individuals = generate_selected_individuals(generation_size, prob_array); // TO DO: separate individual var
  print_fits(selected_individuals);
  childrens = generate_childrens(selected_individuals, generation_size);
  print_fits(childrens);
  //System.out.println("wena larry:" + (int)(Math.random() * 50));
}

void print_fits(Individual[] arr){
  for (int i=0; i<10;i++){
    System.out.println(arr[i].x+", "+arr[i].y+" objetivo: "+arr[i].objetive);
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
  Individual(float objetive){
    this.objetive=objetive;
  }
  
  @Override
  public int compareTo(Individual i) {
    if(this.objetive < i.get_objetive_value()) return -1;
    if(this.objetive == i.get_objetive_value()) return 0;
       //if(this.age > p.getAge()) return 1;
    else return 1;
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

int[] generate_prob_array(Individual[] ind){
  int total_length = 1;
  int size = ind.length;
  int index = 0;
  for(int i=1;i<=ind.length;i++){total_length += i;}
  System.out.println(total_length);
  int A[] = new int[total_length];
  for(int i=0; i<size;i++){
   for (int j=1;j<size-i+1;j++){ 
      A[index] = i;
      index++;
   }
  }
  return A;
}

Individual[] generate_selected_individuals(int generation_size, int[] prob_array){
  Individual[] selected_individuals = new Individual[generation_size];
  int prob_array_length = prob_array.length;
  for (int i=0; i<generation_size; i++){
    selected_individuals[i] = population[prob_array[(int)(Math.random() * prob_array_length)]];
  }
  return selected_individuals;
}

Individual[] generate_childrens(Individual[] selected_individual, int generation_size){ // generatin children by crossover 
  Individual[] childrens = new Individual[generation_size];
  
  for(int i=0; i<generation_size;i++){
    childrens[i] = new Individual(selected_individual[i].x,selected_individual[generation_size-i-1].y);
  }
  
  return childrens;
}

void update_best(){
  for (int i= 0; i<population.length; i++){
    //if 
  }
}

//float z = funtion(population[1].x,population[1].y);
//System.out.println(population[1].x);

//Falta:
/*
seleccionar padres en base a probabilidad del rank
reproducir los padres 
guardar la siguiente generacion en el mismo arreglo
realizar mutaciones
guardar mejor

*/
