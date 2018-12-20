public class Objeto3D{
    int [][]P;
    int [][]L;
    int [][]info;
    int maxProfundidade;
    int maxAltura;
    
    String nomeObjeto;
    
    int projecao; 
    
    int troncoR = (int)random(51,153);
    int troncoG = (int)random(76,25);
    int troncoB = (int)random(0,0);
    
    int galhoR = (int)random(204,255);
    int galhoG = (int)random(102,204);
    int galhoB = (int)random(0,51);
    
    int folhaR = (int)random(0,178);
    int folhaG = (int)random(51,255);
    int folhaB = (int)random(0,178);
    
    int flor1R, flor1G, flor1B; 
    int flor2R, flor2G, flor2B; 
       
    int VTx, VTy, VTz;//VALORES PARA A TRANSLAÇÃO
    float VRx , VRy , VRz;//VALORES PARA A ROTAÇÃO
    float VSx, VSy, VSz;//VALORES PARA A ESCALA
    
    float EscalaProporcionalAoUniverso;
    int X_universo, Y_universo, Z_universo;

    TransV2 transformacoes;
    
    
    Objeto3D(int [][]P, int [][]L, int X_universo, int Y_universo, int Z_universo){
        this.P = P;
        this.L = L;       
      
        this.VTx = this.VTy = this.VTz = 0;
        this.VRx = this.VRy = this.VRz = 0;
        //this.VSx = this.VSy = this.VSz = 1;
       
        //Nessa linha eu seto o tamanho do universo, nas proximas tarefas deverei pegar esses valores no momento de criação do objeto
        this.X_universo = X_universo;
        this.Y_universo = Y_universo;
        this.Z_universo = Z_universo;
        
        if(this.Y_universo/(height*1.0) <= this.X_universo/(width*1.0))this.EscalaProporcionalAoUniverso = this.VSx = this.VSy = this.VSz = this.Y_universo/(height*1.0);
        else this.EscalaProporcionalAoUniverso = this.VSx = this.VSy = this.VSz = this.X_universo/(width*1.0);
                      
        //calculaCentro();println(xcentro+" " + ycentro + " " +zcentro);
        this.transformacoes = new TransV2(VTx, VTy, VTz, VRx, VRy, VRz, VSx, VSy, VSz); 
        projecao = 0;
        
        
        //lanço moeda para escolher os tipos de flores
        int moeda = round(random(0,3));        
        //Combinações TIPO1-TIPO3 // TIPO1-TIPO4// TIPO2-TIPO4// TIPO2-TIPO3
        if(moeda == 0){
            flor1R = (int)random(102,255);  flor1G = (int)random(0,204);  flor1B = (int)random(0,153); 
            flor2R = (int)random(0,153);  flor2G = (int)random(0,255);  flor2B = (int)random(102,255);     
        }    
        else if(moeda == 1){
            flor1R = (int)random(102,255);flor1G = (int)random(0,204); flor1B = (int)random(0,153);
            flor2R = (int)random(51,255);  flor2G = (int)random(0,153);  flor2B = (int)random(51,255);    
        }
        else if(moeda == 2){
            flor1R = (int)random(102,255);flor1G = (int)random(102,255); flor1B = (int)random(0,153);
            flor2R = (int)random(51,255);  flor2G = (int)random(0,153);  flor2B = (int)random(51,255);     
        } 
        else{
            flor1R = (int)random(102,255);flor1G = (int)random(102,255); flor1B = (int)random(0,153);
            flor2R = (int)random(0,153);  flor2G = (int)random(0,255);  flor2B = (int)random(102,255);
        }    
          //RANGE DOS TIPOS DE FLORES:
          //TIPO 1 
          //R 102-255
          //G 0 -204
          //B 0-153
          
          //TIPO 2 
          //R 102-255
          //G 102 -255
          //B 0-153
        
          //TIPO 3 
          //R 0-153
          //G 0 -255
          //B 102-255
        
          //TIPO 4 
          //R 51-255
          //G 0 -153
          //B 51-255                                     
    }
    
    void ObjectSetInfo(int [][]info, int maxProfundidade, int maxAltura){
        this.info = info;
        this.maxProfundidade = maxProfundidade;
        this.maxAltura = maxAltura;
        //println(this.maxAltura);
    }
    
    void desenhaObjeto3D(boolean isSelected){         
        int [][] Pontos = transformacoes.aplicarTransformacao(this.P);
        if(isSelected){
            
            for(int rows = 0; rows < L.length; rows+=2){//OBSERVE QUE HÁ X PONTOS E X/2 LINHAS POR ISSO QUE EU COLOQUEI ROWS+=2
                int xi = Pontos[L[rows][0]][0];
                int yi = Pontos[L[rows][0]][1]; 
                int xf = Pontos[L[rows][1]][0];
                int yf = Pontos[L[rows][1]][1]; 
                
                float espessura;
                
                if(this.info[L[rows][0]][0] == 0){
                    if(rows % 10 <= 7)stroke(folhaR,folhaG,folhaB);            
                    else if(rows % 10 == 8)stroke(flor1R, flor1G, flor1B);//flor   
                    else stroke(flor2R, flor2G, flor2B);//flor  
                    espessura = 3;
                    strokeWeight(espessura); 
                    line(xi, yi, xf, yf);
                }
               
                else{                    
                    espessura = map(this.info[L[rows][0]][1], 1, this.maxProfundidade, 1.5 + maxAltura/60, 1);
                    //float espessura =  (float)(Math.pow(1,-this.info[L[rows][0]][1] ) * 10 );
                    
                    //LinhaDDA temp = new LinhaDDA(xi, yi, xf, yf, color(0,255,0));
                    strokeWeight(espessura);

                    if(this.info[L[rows][0]][0] <= 5)stroke(galhoR,galhoG,galhoB);
                    else stroke(troncoR,troncoG,troncoB);
                    line(xi, yi, xf, yf);
                }
            }
        }
        //else{
        //    for(int rows = 0; rows < L.length; rows++){
        //        int xi = Pontos[L[rows][0]][0];
        //        int yi = Pontos[L[rows][0]][1]; 
        //        int xf = Pontos[L[rows][1]][0];
        //        int yf = Pontos[L[rows][1]][1];
                
        //        //LinhaDDA temp = new LinhaDDA(xi, yi, xf, yf, color(255,0,0)); 
        //        stroke(R,G,B);
        //        line(xi, yi, xf, yf);
        //    }
        //}
    } 
    
    void objectUpdate(int Tx, int Ty, int Tz, float Rx, float Ry, float Rz, float Sx, float Sy, float Sz, int projecao){
        this.VTx += Tx;
        this.VTy += Ty;
        this.VTz += Tz;
        
        this.VRx += Rx;
        this.VRy += Ry;
        this.VRz += Rz;
        
        if(VSx + Sx >= 0)this.VSx += Sx; else this.VSx = 0;
        if(VSy + Sy >= 0)this.VSy += Sy; else this.VSy = 0;
        if(VSz + Sz >= 0)this.VSz += Sz; else this.VSz = 0;
        
        this.projecao = projecao % 5;
        this.transformacoes.update(this.VTx,this.VTy,this.VTz,this.VRx,this.VRy,this.VRz,this.VSx,this.VSy,this.VSz,this.projecao);
        objectApplyTransformations();
    }
    
    void objectSet(int VTx, int VTy, int VTz, float VRx, float VRy, float VRz, float VSx, float VSy, float VSz){
        this.VTx = VTx;
        this.VTy = VTy;
        this.VTz = VTz;
        
        this.VRx = VRx;
        this.VRy = VRy;
        this.VRz = VRz;
        
        if(VSx >= 0)this.VSx = VSx; else this.VSx = 0;
        if(VSy >= 0)this.VSy = VSy; else this.VSy = 0;
        if(VSz >= 0)this.VSz = VSz; else this.VSz = 0;

        this.transformacoes.update(this.VTx,this.VTy,this.VTz,this.VRx,this.VRy,this.VRz,this.VSx,this.VSy,this.VSz,this.projecao);
        objectApplyTransformations();
    }
        
    void objectApplyTransformations(){
        this.transformacoes.rotacionarX();
        this.transformacoes.rotacionarY();
        this.transformacoes.rotacionarZ();
        this.transformacoes.escalar();       
    }
    
    void objectReset(){
        this.VTx = 0;
        this.VTy = 0;
        this.VTz = 0;
        
        this.VRx = 0;
        this.VRy = 0;
        this.VRz = 0;
        
        
        this.transformacoes.TransV2Reset();
        this.VSz = this.VSy = this.VSx = this.EscalaProporcionalAoUniverso;        
        this.transformacoes.update(this.VTx,this.VTy,this.VTz,this.VRx,this.VRy,this.VRz,this.VSx,this.VSy,this.VSz,this.projecao);
        objectApplyTransformations();
        
    } 
}
