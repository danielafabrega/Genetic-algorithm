/// poner textos en la pantalla? se ve feo 
import java.util.Arrays;

PrintWriter output;

GA genetic_algorithm;
GA[] algorithms;
GA[] video_algorithms;
int current_generation=0;
int max_generations=50;
float y_range[] = {-5.12f, 5.12f};
float x_range[] = {-5.12f, 5.12f};
boolean experiment_mode=false;
boolean video_mode=true;
int video_counter=0;
int video_algorithms_quantity=10;

//////////////////////////////////////////// SETUP/////////////////////////////////////////////////
void setup() {
  // window settings
  size(800, 800); 
  background(0);
  stroke(255);
  frameRate(60);
  // algorithm params
  int generation_size= 500;
  int initial_individuals=10;
  int mutation_probability=40;
  
  int[] param_to_vary={0,50,100};
  
  genetic_algorithm= new GA(max_generations, generation_size, initial_individuals, mutation_probability); 
  
  if(video_mode){
    video_algorithms = new GA[video_algorithms_quantity];
    video_algorithms[0] = new GA(max_generations, 200, 10, 0);
    video_algorithms[1] = new GA(max_generations, 200, 10, 1);
    video_algorithms[2] = new GA(max_generations, 200, 10, 50);
    video_algorithms[3] = new GA(max_generations, 200, 10, 100);
    video_algorithms[4] = new GA(max_generations, 10, 10, 10);
    video_algorithms[5] = new GA(max_generations, 500, 10, 10);
    video_algorithms[6] = new GA(max_generations, 1000, 10, 10);
    video_algorithms[7] = new GA(max_generations, 200, 10, 10);
    video_algorithms[8] = new GA(max_generations, 200, 500, 10);
    video_algorithms[9] = new GA(max_generations, 200, 200, 10);
  }
  
  if(experiment_mode){
    algorithms = new GA[param_to_vary.length];
    output = createWriter("experiment_data_"+year()+"-"+month()+"-"+day()+".csv");
    for(int i = 0; i<param_to_vary.length; i++){
      algorithms[i] = new GA(max_generations, generation_size, initial_individuals, param_to_vary[i]); ;
    }
    
    run_experiments();
    
    output.close();
    exit();
  }  
}

//////////////////////////////////////////////// DRAW///////////////////////////////////
void draw(){
  
    if((current_generation < max_generations*video_algorithms_quantity) && !experiment_mode ){
      video_algorithms[current_generation/max_generations].run_generation();
      current_generation++;
      System.out.println("10");
  

  
  System.out.println(video_counter/max_generations);
  video_counter++;
  
  }


}

void run_experiments(){
  //the idea of this function it's automate de data generation in a easy way creating a csv
  for (int i=0; i<algorithms.length; i++){
    current_generation = 0;
    while (current_generation<max_generations){
      algorithms[i].run_generation();
      //print_fits(genetic_algorithm.population);
      current_generation++;
    }
    
  }  
}

float objetive_fun(float x, float y){
  return 20+((float)Math.pow(x,2)-10*cos(2*PI*x)+(float)Math.pow(y,2)-10*cos(2*PI*y));
}

void print_fits(Individual[] arr){
  for (int i=0; i<10;i++){
    System.out.println(arr[i].x+", "+arr[i].y+" objetivo: "+arr[i].objetive);
  }
  System.out.println("\n");
}

////////////////////////////// GA CLASS /////////////////////////////////////////////////
class GA{
  int prob_array[];
  Individual[] population;
  Individual[] selected_individuals;
  Individual optimal_individual;
  int generations ; 
  int generation_size ;
  int count=0;
  int initial_individuals;//=10;
  float mutation_probability= 5; // please set in percentaje ex: 2 means 2%, if you put 0.2 it means 0.2%
  Individual[] childrens;
  int generations_to_reach_best=0;
  
  GA(int generations, int generation_size, int initial_individuals, float mutation_probability){
    this.generations=generations;
    this.generation_size=generation_size;
    this.initial_individuals=initial_individuals;
    this.mutation_probability=mutation_probability;
    this.population = init_population(initial_individuals);
    this.optimal_individual = new Individual(999999);
    //draw_individuals();
    
  }
  
  void print_optimal(){
    System.out.println("El optimo es :" + this.optimal_individual.objetive);
  }
  
  void draw_individuals(){
    for (int i=1; i<this.population.length; i++){
      this.population[i].display();
    }
  };
  
  void run_generation(){
    background(0);
    this.update_optimal();
    this.sort_population_by_fit();
    this.generate_prob_array();
    this.generate_selected_individuals();
    this.generate_childrens();
    this.mutate_population_by_random_value();
    
    if(experiment_mode){
      this.log_generation_data_csv();
    }
    else{
      this.draw_individuals();
    }
    
    this.print_optimal();
  }
  
  void log_generation_data_csv(){
    
    output.print(this.optimal_individual.objetive);
    
    if (current_generation == max_generations-1){ 
      System.out.println("ESTOY EN LA ULTIMA GENERATION");
      output.println();
     }
    else{
      output.print(", ");
    }
  }
  
  Individual[] init_population(int size){
    
    Individual[] popu = new Individual[size];
    for (int i=0; i < size; i++){
      popu[i] = new Individual(random(x_range[0], x_range[1]),random(y_range[0], y_range[1]));
    }
    System.out.println("init_population");
     return popu;
  }
  
  
  void sort_population_by_fit(){
    
    Arrays.sort(this.population); 
  }

  void generate_prob_array(){
    int total_length = 1;
    int size = this.population.length;
    for(int i=1;i<=size;i++){total_length += i;}    
    int A[] = new int[total_length];
    int index = 0;
    for(int i=0; i<size;i++){
      for (int j=1;j<size-i+1;j++){ 
        A[index] = i;
        index++;
      }
    }
    this.prob_array=A; 
  }
  
  
  void generate_selected_individuals(){
    Individual[] selected_individuals = new Individual[this.generation_size];
    int prob_array_length = this.prob_array.length;
    for (int i=0; i<this.generation_size; i++){
      selected_individuals[i] = this.population[this.prob_array[(int)(Math.random() * prob_array_length)]];
    }
    this.population=selected_individuals; 
  }
  
  
  void generate_childrens(){ // generatin children by crossover 
    Individual[] childrens = new Individual[this.generation_size];
    for(int i=0; i<this.generation_size;i++){
      childrens[i] = new Individual(this.population[i].x, this.population[generation_size-i-1].y);
    }
    this.population = childrens;
  }
  
  
  void update_optimal(){
    float value;
  
    for (int i= 0; i<this.population.length; i++){
      value = this.population[i].get_objetive();
      if(optimal_individual.get_objetive()>value){
        this.optimal_individual.set_x(population[i].get_x());
        this.optimal_individual.set_y(population[i].get_y());
        this.optimal_individual.set_objetive(value);
        this.generations_to_reach_best=current_generation-((current_generation/max_generations)*max_generations);
      }
    }
    
    if(!experiment_mode){
      PFont f = createFont("Arial",8,true);
      textFont(f,15);
      fill(#00ff00);
       text("Best fitness: "+str(this.optimal_individual.get_objetive())+
       "\nGenerations to reach best: "+str(this.generations_to_reach_best)+
       "\nGeneration: "+str(current_generation-((current_generation/max_generations)*max_generations))+
       "\nMutation probability: "+str(this.mutation_probability)+
       "\nPopulation: "+str(this.population.length)+
       "\nFrame rate: "+str(frameRate)
       ,10,20);
    }
  }
  
  
  void mutate_population_by_random_value(){
    for(int i = 0; i < this.generation_size; i++){
      if(random(0, 100)<this.mutation_probability){ // if we pass this if, we must mutate x or y 
        if(random(0,1)<0.5){
          this.population[i].set_x(random(x_range[0], x_range[1]));
        }
        else{
          this.population[i].set_y(random(y_range[0], y_range[1]));
        }
      }
    }
  }
  
}

////////////////////////////////////INDIVIDUAL CLASS ///////////////////////////////////////////////////
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
