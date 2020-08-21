//pseudocodigo
// PENDING:
// while que encapsula todo
// elitismo ???
// mutaciones ???
// dar color a los puntos a partir de un mapa de color relativo para el intervalo????? o es mucho lucho?

// parametrizacion de los limites => cambiarlos en los random que generan numeros tanto en inicializacion como en el mutation 
    // tambien es necesario parametrizar el dibujo en funcion del width y height relacionados con el eje x y el eje y respectivamente. 
import java.util.Arrays;

int prob_array[];
Individual[] population;
Individual optimal_individual;
float x_range[] = {-5.12f, 5.12f}; // {x_inferior_limit, y_inferior_limit}
float y_range[] = {-5.12f, 5.12f};
//crear individuo

//int main() {
void setup() {
  
  size(512, 512); // TODO: refactory drawing in terms of width and height
  background(0);
  stroke(255);
 
  
  Individual hijo= new Individual(1,1);
  hijo.display();
  Individual hijo2= new Individual(0,0);
  hijo2.display();
  
  System.out.println(random(0, 100));
  int generations = 100; 
  int generation_size = 500;
  int count=0;
  int initial_individuals=10;
  float mutation_probability= 5; // please set in percentaje ex: 2 means 2%, if you put 0.2 it means 0.2%
  Individual[] childrens;
  //Individual[] mutated_population;
  population = init_population(initial_individuals);
  optimal_individual = new Individual(999999);
  System.out.println(optimal_individual.objetive);
  Individual[] selected_individuals;
  
  draw_individuals(initial_individuals);
  
  //////////////////////////////
  
  while(count<generations){
    
    print_fits(population);
    update_optimal();
    Arrays.sort(population);
    print_fits(population);
    
    prob_array = generate_prob_array(population);
    selected_individuals = generate_selected_individuals(generation_size, prob_array); // TO DO: separate individual var
    print_fits(selected_individuals);
    childrens = generate_childrens(selected_individuals, generation_size);
    print_fits(childrens);
    
    population= childrens;
    mutate_population(mutation_probability, generation_size); 
    print_fits(population);
    count++;
  }  
  
  //System.out.println("el optimo es"+optimal_individual.get_objetive()); 
   
   //System.out.println(width+"  "+(x_range[1]-x_range[0]));
   //System.out.println((hijo.get_x()-x_range[0])/(x_range[1]-x_range[0])*width);
   
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
  public void set_x(float new_value){
    this.x=new_value;
  }
  public void set_y(float new_value){
    this.y=new_value;
  }
  public void set_objetive(float new_value){
    this.objetive=new_value;
  }
  public float get_x(){
    return this.x;
  }
  public float get_y(){
    return this.y;
  }
  public float get_objetive(){
    return this.objetive;
  }
  
  void display(){
    circle((this.x-x_range[0])/(x_range[1]-x_range[0])*width,(this.y-y_range[0])/(y_range[1]-y_range[0])*height,3);
  }
  
  @Override
  public int compareTo(Individual i) {
    if(this.objetive < i.get_objetive()) return -1;
    if(this.objetive == i.get_objetive()) return 0;
       //if(this.age > p.getAge()) return 1;
    else return 1;
    }
  
}

void draw_individuals(int p){
  for (int i=1; i<p; i++){
    population[i].display();
  }
};


void print_fits(Individual[] arr){
  for (int i=0; i<10;i++){
    System.out.println(arr[i].x+", "+arr[i].y+" objetivo: "+arr[i].objetive);
  }
  System.out.println("\n");
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

void update_optimal(){
  float value;
  
  for (int i= 0; i<population.length; i++){
    value = population[i].get_objetive();
    if(optimal_individual.get_objetive()>value){
      optimal_individual.set_x(population[i].get_x());
      optimal_individual.set_y(population[i].get_y());
      optimal_individual.set_objetive(value);
    }
  }
}

void mutate_population(float percentaje, int population_size){
  
  for(int i = 0; i < population_size; i++){
    if(random(0, 100)<percentaje){ // if we pass this if, we must mutate x or y 
      if(random(0,1)<0.5){
        population[i].set_x(random(-5.12, 5.12));
      }
      else{
        population[i].set_y(random(-5.12, 5.12));
      }
    }
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
