import java.util.ArrayList;
import java.util.*;

public class PoligonoVF {
    int global_YMIN, global_YMAX;
    ArrayList <MatrixAuxiliar> tabelaAux = new ArrayList();
    
    PoligonoVF(int[][] P, int [][] L, Face face, color cor_linha, boolean preenche, color cor_preenchimento){             
        global_YMIN = 1500;//são numeros aleatorios que não vao me atrapalhar
        global_YMAX = 0;   //são numeros aleatorios que não vao me atrapalhar     
        
        //Nesse for construo minha tabela/matrix auxilar com os valores de ymin, ymax, x_for_ymin e slope
        for(int rows = 0; rows < face.F.length; rows++){
            int xi, xf, yi, yf;
            if(rows == face.F.length-1){
                xi = P[face.F[rows]][0];
                yi = P[face.F[rows]][1]; 
                xf = P[face.F[0]][0];
                yf = P[face.F[0]][1]; 
               // println("\n xi: " + xi+ " yi " + yi + " xf " + " yf " +yf);
            }
            else{
                xi = P[face.F[rows]][0];
                yi = P[face.F[rows]][1]; 
                xf = P[face.F[rows+1]][0];
                yf = P[face.F[rows+1]][1]; 
            }    
           // println("cheguei aqui ");

            
            //essas variaveis são para saber o YMAX E YMIN GLOBAIS
            int tempYmin = min(yi, yf);
            int tempYmax = max(yi, yf);
           
            if(global_YMIN > tempYmin) global_YMIN = tempYmin;
            if(global_YMAX < tempYmax) global_YMAX = tempYmax;
            
            int x_for_ymin;
            
            if(yi == tempYmin)x_for_ymin = xi;
            else x_for_ymin = xf;
            
            float slope = calc_Inverse_M(xi, yi, xf, yf);
            
            //só adicionaremos as linhas que não sejam paralelas ao eixo x
            if(slope != Integer.MAX_VALUE)
                tabelaAux.add(new MatrixAuxiliar(tempYmin, tempYmax, x_for_ymin, slope));          
        }
        
        //só colore o poligono se a flag de preencher for true, se não será desenhado apenas as bordas
        //Se a funcao do processing for true então será usado uma função do processing para pintar o poligono se não será usado minha propria função
        if(preenche && !FuncaoDoProcessing)colorePoligono(cor_preenchimento);
        if(preenche && FuncaoDoProcessing)colore_com_FuncaoDoProcessing(P,face.F,cor_preenchimento);
        
        //desenhaPoligono(P, face, cor_preenchimento);
    } 
    
    void desenhaPoligono(int[][] P, Face face, color cor_linha){
        for(int rows = 0; rows < face.F.length; rows++){
            int xi, xf, yi, yf;
            if(rows == face.F.length-1){
                xi = P[face.F[rows]][0];
                yi = P[face.F[rows]][1]; 
                xf = P[face.F[0]][0];
                yf = P[face.F[0]][1]; 
            }
            else{
                xi = P[face.F[rows]][0];
                yi = P[face.F[rows]][1]; 
                xf = P[face.F[rows+1]][0];
                yf = P[face.F[rows+1]][1]; 
            }
            //LinhaDDA temp = new LinhaDDA(xi, yi, xf, yf, cor_linha);
            strokeWeight(16);
            stroke(cor_linha);
            line(xi, yi, xf, yf);
        }
    }
    
    void colorePoligono(color cor_preenchimento){
        loadPixels();
        for(int scan_y = global_YMIN; scan_y <= global_YMAX; scan_y++){
            ArrayList<Intersecoes> xList = new ArrayList();//array com todas as interseções
            
            for(int i = 0; i < tabelaAux.size(); i++){
                if(scan_y < tabelaAux.get(i).ymin || scan_y > tabelaAux.get(i).ymax) continue;
                
                boolean  ymax = false, ymin = false;
                if(tabelaAux.get(i).ymax == scan_y){
                    ymax = true;
                }
                if(tabelaAux.get(i).ymin == scan_y){
                    ymin = true;
                }
                
                Intersecoes ponto = new Intersecoes(calc_Intersection(tabelaAux.get(i).ymin, tabelaAux.get(i).x_for_ymin, tabelaAux.get(i).slope, scan_y), ymax, ymin);    
                xList.add(ponto);                
            }
            
            Collections.sort(xList, new IntersecoesXAscendingComparator());

            for(int i = 0; i < xList.size()-1; i++){
                if(xList.get(i).x == xList.get(i+1).x && ((xList.get(i).ymin == true && xList.get(i+1).ymin == true ) || (xList.get(i).ymax == true && xList.get(i+1).ymax == true))){
                    xList.remove(i);
                    xList.remove(i);
                    continue;
                }
               if(xList.get(i).x == xList.get(i+1).x && ((xList.get(i).ymin == true && xList.get(i+1).ymax == true) || (xList.get(i).ymax == true && xList.get(i+1).ymin == true)))
                    xList.remove(i);
            }        

            for(int i = 0; i < xList.size()-1; i+=2){
               // if(i%2 != 0)continue;
                LinhaDDA desenha = new LinhaDDA(xList.get(i).x, scan_y, xList.get(i+1).x, scan_y, cor_preenchimento);   
            }       
           
            updatePixels();
        }
    }
    
    void colore_com_FuncaoDoProcessing (int[][] Pontos, int[] Linhas, color cor_preenche) {
      noStroke();
      fill(cor_preenche);
      beginShape();
      for (int i = 0; i < Linhas.length; i++) {
        vertex(Pontos[Linhas[i]][0], Pontos[Linhas[i]][1]);
      }
      endShape(CLOSE);                      
    }

    float calc_Inverse_M(int xi, int yi, int xf, int yf){
        if(yf-yi == 0) return Integer.MAX_VALUE;//essa linha é paralela ao eixo x, então iremos retornar esse valor para identificar que era será eliminada
        else return 1.0*(xf-xi)/(yf-yi);
    }
  
    int calc_Intersection(int ymin, int xmin, float slope, int yscan){
        return round((slope * (yscan - ymin) + xmin));
    }
}

class MatrixAuxiliar{
    int ymin, ymax, x_for_ymin;
    float slope;   
    MatrixAuxiliar(int ymin, int ymax, int x_for_ymin, float slope){
        this.ymax = ymax;
        this.ymin = ymin;
        this.x_for_ymin = x_for_ymin;
        this.slope = slope;
    }    
}

class Intersecoes {
    int x;
    boolean ymax, ymin;
    Intersecoes(int x, boolean ymax, boolean ymin){
        this.x = x;
        this.ymax = ymax;
        this.ymin = ymin;   
    }
}

class IntersecoesXAscendingComparator implements Comparator<Intersecoes> {    
    int compare(Intersecoes i1, Intersecoes i2) {
        return i1.x - i2.x;   
    }  
}
