import java.util.ArrayList;
import java.util.*;
import java.awt.event.KeyEvent;

String PATH = "/home/accelerator/Documents/4 semestre/computaçãografica/trees/models/tree2d";
int NumeroDeArquivos = new File(PATH).list().length;
//int NumeroDeArquivos = 15;
int MaxTrees = 50;

boolean Universe = true;
PImage imgMENU;
PImage imgBackground;
boolean menu = true;
boolean FuncaoDoProcessing = true;


PFont projection_font;
int projecao;

int Tx, Ty, Tz;//INCREMENTOS PARA A TRANSLAÇÃO
float Rx , Ry , Rz;//INCREMENTOS PARA A ROTAÇÃO
float Sx, Sy, Sz;//INCREMENTOS PARA A ESCALA

ArrayList <Objeto3D> ObjectList = new ArrayList();
ArrayList <Objeto3D_Com_Faces> ObjectList_Com_Faces = new ArrayList();

void setup(){
    //PRIMEIRA COISA QUE ESTOU FAZENDO É ADICIONAR O CHÃO DA FLORESTA
    int [][]Floor_Points = {{3*width/8, 0, 2*width/8}, {3*width/8, 0, -2*width/8},
                            {-3*width/8, 0, 2*width/8}, {-3*width/8, 0, -2*width/8}};

    int [][]Floor_Lines = {{0,2}, {2,3}, {3,1}, {1,0}};
    int []Floor_Faces_Points = {0,2,3,1};
    ArrayList <Face> Floor_Faces_Indexes = new ArrayList();
    Floor_Faces_Indexes.add(new Face(Floor_Faces_Points, 255, 204, 153));
    int Floor_X_universo = width;
    int Floor_Y_universo = height;
    ObjectList_Com_Faces.add(new Objeto3D_Com_Faces(Floor_Points, Floor_Lines, Floor_Faces_Indexes, Floor_X_universo, Floor_Y_universo, "Floor"));
    
    
    fullScreen();
    background(0); 
    Rx = 0;
    Ry = 0;
    Rz = 0;
    
    Tx = 0;
    Ty = 0;
    Tz = 0;
    
    Sx = 0;
    Sy = 0;
    Sz = 0;

    
    projecao = 0;
    
    imgBackground = loadImage("ceu.jpeg");
    imgMENU = loadImage ("menu.png");
    projection_font = createFont("Meera", 12,true);

      
    //Z RANGE = 680
    //X RANGE = 1020
    IntList random_X = new IntList();
    for(int i = -3*width/8 ; i < 3*width/8; i+=15)random_X.append(i);
    
    IntList random_Z= new IntList();
    for(int i = -2*width/8 ; i < 2*width/8; i+=15)random_Z.append(i);
    
    IntList random_Files= new IntList();
    for(int i = 0; i < NumeroDeArquivos; i++)random_Files.append(i);
    

    random_X.shuffle();
    random_Z.shuffle();
    random_Files.shuffle();
   
    //LEIO todos os modelos da pasta.
    for(int k = 0; k < NumeroDeArquivos; k++){      
        String pad = "";
        int numeroDoArquivo = random_Files.get(k);
        if(numeroDoArquivo<10) pad = "00";
        if(numeroDoArquivo>=10) pad = "0";
        if(numeroDoArquivo>=100) pad = "";
        String[] lines = loadStrings(PATH+ "/"+"tree"+pad+numeroDoArquivo+".txt");
        int NumeroDePontos = lines.length;
        int Figure_X_universo = width, Figure_Y_universo = height;
        int [][]pontos = new int[NumeroDePontos][3];
        int [][]info = new int[NumeroDePontos][2];
        int [][]linhas = new int [NumeroDePontos][2];
        int maxProfundidade = 1;
        int maxAltura = 0;
        

        int  translacaoX = random_X.get((k+20)%random_X.size());
        int  translacaoZ = random_Z.get(k%random_Z.size());

            
       // println("random x: " + translacaoX + "     random z: " + translacaoZ);
        for(int i = 0; i < NumeroDePontos; i+=2){
            String []parts = lines[i].split(" ");
            int xi = round(Float.parseFloat(parts[0]));
            int yi = round(Float.parseFloat(parts[1]));
            int zi = round(Float.parseFloat(parts[2]));
            int nivel = round(Float.parseFloat(parts[3]));
            int stroke_weight = round(Float.parseFloat(parts[4]));            
            
            parts = lines[i+1].split(" ");
            int xf = round(Float.parseFloat(parts[0]));
            int yf = round(Float.parseFloat(parts[1]));
            int zf = round(Float.parseFloat(parts[2]));

            if(maxAltura < yi)maxAltura = yi;
            if(maxAltura < yf)maxAltura = yf;
            
            int nivel1 = round(Float.parseFloat(parts[3]));
            int stroke_weight1 = round(Float.parseFloat(parts[4]));    
            
            pontos[i][0] = xi + translacaoX;
            pontos[i][1] = yi;
            pontos[i][2] = zi + translacaoZ;
            info[i][0] = nivel;
            info[i][1] = stroke_weight;
            if(maxProfundidade < stroke_weight) maxProfundidade = stroke_weight;
            
            pontos[i+1][0] = xf + translacaoX;
            pontos[i+1][1] = yf;
            pontos[i+1][2] = zf + translacaoZ;
            info[i+1][0] = nivel1;
            info[i+1][1] = stroke_weight1;
            if(maxProfundidade < stroke_weight1) maxProfundidade = stroke_weight1;
            
            linhas[i][0]=i;
            linhas[i][1]= i+1;                 
        }
        ObjectList.add(new Objeto3D(pontos, linhas, Figure_X_universo, Figure_Y_universo, Figure_X_universo));
        //println(maxAltura);
        ObjectList.get(ObjectList.size()-1).ObjectSetInfo(info, maxProfundidade, maxAltura);
    }
    
    
    long seed = System.nanoTime();
    Collections.shuffle(ObjectList, new Random(seed));
    Sort_First_N_Elements(ObjectList, MaxTrees);
}

void draw(){             
    if(menu){
        background(255);
        image(imgMENU,width/6,height/10);      
    } //<>//
    
    else{        
        background(0);
        image(imgBackground,0,0,width,height);
        textFont(projection_font,25);
        String projection_name = "Projeção: ";
        if(projecao % 5 == 0)projection_name = projection_name + "Cavaleira";
        else if(projecao % 5 == 1)projection_name = projection_name + "Cabinet";
        else if(projecao % 5 == 2)projection_name = projection_name + "Isométrica";
        else if(projecao % 5 == 3)projection_name = projection_name + "Ponto de fuga em Z";
        else if(projecao % 5 == 4)projection_name = projection_name + "Ponto de fuga em X e Z";             

        if(!ObjectList_Com_Faces.isEmpty()){
            for(int i = 0; i < ObjectList_Com_Faces.size(); i++){
                ObjectList_Com_Faces.get(i).objectUpdate(-4*Tx, -4*Ty, -4*Tz, 0, 0, 0, 2*Sx, 2*Sy, 2*Sz, projecao);
                ObjectList_Com_Faces.get(i).transformacoes.updateUniverse(Rx, Ry, Rz);
            }
        }
        
        if(!ObjectList.isEmpty()){
            for(int i = 0; i < ObjectList.size(); i++){
                ObjectList.get(i).transformacoes.updateUniverse(Rx, Ry, Rz);
                ObjectList.get(i).objectUpdate(-4*Tx, -4*Ty, -4*Tz, 0, 0, 0, 2*Sx, 2*Sy, 2*Sz, projecao);                                                
            }
        }
        reset();
        
        for(int i = 0; i < ObjectList_Com_Faces.size(); i++){
            ObjectList_Com_Faces.get(i).desenhaObjeto3Dcolorido(false);
        }
        
          for(int i = 0; i < MaxTrees; i++){
            ObjectList.get(i).desenhaObjeto3D(true);
        } 
        
        
        fill(255);
        text(projection_name, 4*width/5, 27);   
    } //<>//
}

//implementação para fazer funcionar a entrada de mais de uma tecla no caso o shift+tab
//void keyReleased(){
//    if(key == CODED){
//        if(keyCode == SHIFT)shiftPressed = false;
//    }
//} //<>//
void keyPressed(){
    if(key == 'R' || key == 'r')ResetAll();
    
    //COMENTEI AS FUNÇÕES ABAIXO PARA ELAS NUNCA SEREM ALTERADAS E SEMPRE FICAREM ATIVAS
    //if(key == 'F' || key == 'f')FuncaoDoProcessing = !FuncaoDoProcessing;
    //if(key == 'U' || key == 'u'){
    //    Universe = !Universe; 
    //}        
        
    //KEYS PARA TRANSLADAR //<>//
    if(key == '1')Tz=-5;
    if(key == '2')Tz=5;
    if(key == CODED){
        if(keyCode == UP)Ty=5;
        if(keyCode == DOWN)Ty=-5;
        if(keyCode == LEFT)Tx=-5;
        if(keyCode == RIGHT)Tx=5;        
        //Key DO MENU
        if (keyCode == KeyEvent.VK_F1)menu = !menu;      
   }

     
   
    
    //KEYS PARA REESCALAR OS EIXOS INDIVIDUALMENTE
    if(key == 'w' || key == 'W')Sy = 0.2; 
    if(key == 's' || key == 'S')Sy = -0.2; 
    if(key == 'd' || key == 'D')Sx = 0.2; 
    if(key == 'a' || key == 'A')Sx = -0.2; 
    if(key == 'e' || key == 'E' )Sz = 0.2; 
    if(key == 'q' || key == 'Q')Sz = -0.2;     
    //KEYS PARA REESCALAR PROPORCIALNALMENTE TODAS AS COORDENADAS
    if(key == '4'){
        Sx = -0.2;
        Sy = -0.2;
        Sz = -0.2;    
    }
    if(key == '5'){
        Sx = 0.2;
        Sy = 0.2;
        Sz = 0.2;    
    }

    //KEYS PARA ROTACIONAR
    if(key == 'i' || key == 'I')Ry = 0.02; 
    if(key == 'k' || key == 'K')Ry = -0.02; 
    if(key == 'l' || key == 'L')Rx = 0.02; 
    if(key == 'j' || key == 'J')Rx = -0.02; 
    if(key == '7')Rz = -0.02; 
    if(key == '8')Rz = 0.02;    
   
    //Key para controlar qual projeção será aplicada
    if(key == 'p' || key == 'P'){projecao++; if(projecao % 5 == 3)  Tz += 220; if(projecao % 5 == 0)  Tz -= 220;}
    
    if(key == 'n' || key == 'N'){
        long seed = System.nanoTime();
        Collections.shuffle(ObjectList, new Random(seed));
        Sort_First_N_Elements(ObjectList, MaxTrees);
    }

}

//FUNÇÃO PRA RESETAR OS PARAMETROS DE TRANSLAÇÃO, ROTACÃO E ESCALA
void reset(){        
    Rx = 0;
    Ry = 0;
    Rz = 0;
           
    Tx = 0;
    Ty = 0;
    Tz = 0;
    
    Sx = 0;
    Sy = 0;
    Sz = 0;
}

void ResetAll(){
    reset();
    projecao = 0;
    if(!ObjectList.isEmpty()){
        for(int i = 0; i < ObjectList.size(); i++)ObjectList.get(i).objectReset();
    }
   if(!ObjectList_Com_Faces.isEmpty()){
        for(int i = 0; i < ObjectList_Com_Faces.size(); i++)ObjectList_Com_Faces.get(i).objectReset();
    }     
}

void Sort_First_N_Elements(ArrayList <Objeto3D> ObjectList, int n){
    for(int i = 0; i < n; i++){
        for(int j = i+1; j < n; j++){
            if(ObjectList.get(i).P[0][2] >  ObjectList.get(j).P[0][2]){//essa comparação é com o valor de Z do chão, ou seja, eu não preciso usar Z médio aqui
                Collections.swap(ObjectList, i, j);
            } 
        }
    }
}
