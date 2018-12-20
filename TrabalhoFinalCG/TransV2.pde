public class TransV2 {
    float [][]MT = new float[3][3];
    //int xcentro;
    //int ycentro;
    //int zcentro; 
    float [][]MU = new float[3][3];
    
    int projecao = 0; 
    
    int Tx, Ty, Tz;//INCREMENTOS PARA A TRANSLAÇÃO
    float Rx , Ry , Rz;//INCREMENTOS PARA A ROTAÇÃO
    float Sx, Sy, Sz;//INCREMENTOS PARA A ESCALA
    
    float URx , URy , URz;//INCREMENTOS PARA A ROTAÇÃO DO UNIVERSO
    
    TransV2(int Tx, int Ty, int Tz, float Rx, float Ry, float Rz, float Sx, float Sy, float Sz){
        //this.xcentro = xcentro;
        //this.ycentro = ycentro;
        //this.zcentro = zcentro;
        
        this.Tx = Tx;
        this.Ty = Ty;
        this.Tz = Tz;
        
        this.Rx = Rx;
        this.Ry = Ry;
        this.Rz = Rz;
        
        
        this.Sx = Sx;
        this.Sy = Sy;
        this.Sz = Sz;
        
        this.MT = matrizIdentidade();
        this.MU = matrizIdentidade();
    }
   
    void UrotacionarX(){MU = multiplicaMatriz3X3(MU, matrizRotacaoX(URx));}
    void UrotacionarY(){MU = multiplicaMatriz3X3(MU, matrizRotacaoY(URy));}
    void UrotacionarZ(){MU = multiplicaMatriz3X3(MU, matrizRotacaoZ(URz));} 
    
    
    void rotacionarX(){MT = multiplicaMatriz3X3(MT, matrizRotacaoX(Rx));}
    void rotacionarY(){MT = multiplicaMatriz3X3(MT, matrizRotacaoY(Ry));}
    void rotacionarZ(){MT = multiplicaMatriz3X3(MT, matrizRotacaoZ(Rz));}
    
    void escalar(){{MT = multiplicaMatriz3X3(MT, matrizEscala(Sx, Sy, Sz));}}
    
    
    
    
    float [][] multiplicaMatriz3X3(float [][]a, float [][]b){
        float [][]resultado = new float [3][3];
               
        resultado[0][0] = a[0][0]*b[0][0] + a[0][1]*b[1][0] + a[0][2]*b[2][0];
        resultado[0][1] = a[0][0]*b[0][1] + a[0][1]*b[1][1] + a[0][2]*b[2][1];
        resultado[0][2] = a[0][0]*b[0][2] + a[0][1]*b[1][2] + a[0][2]*b[2][2];
        
        resultado[1][0] = a[1][0]*b[0][0] + a[1][1]*b[1][0] + a[1][2]*b[2][0];
        resultado[1][1] = a[1][0]*b[0][1] + a[1][1]*b[1][1] + a[1][2]*b[2][1];
        resultado[1][2] = a[1][0]*b[0][2] + a[1][1]*b[1][2] + a[1][2]*b[2][2];
        
        resultado[2][0] = a[2][0]*b[0][0] + a[2][1]*b[1][0] + a[2][2]*b[2][0];
        resultado[2][1] = a[2][0]*b[0][1] + a[2][1]*b[1][1] + a[2][2]*b[2][1];
        resultado[2][2] = a[2][0]*b[0][2] + a[2][1]*b[1][2] + a[2][2]*b[2][2];      
    
        return resultado;
    }  
    
    int [][]aplicarTransformacao(int [][]Pontos){
        int [][]resultado = new int [Pontos.length][3];
        
        for(int i = 0; i < Pontos.length; ++i){
            float x,y,z;
            
            //trago os pontos para a origen
            //Pontos[i][0] -= xcentro;
            //Pontos[i][1] -= ycentro;
            //Pontos[i][2] -= zcentro;  
            
            
            //faço os calculos das transformações 
            x = (Pontos[i][0]*MT[0][0] + Pontos[i][1]*MT[1][0] + Pontos[i][2]*MT[2][0]);
            y = (Pontos[i][0]*MT[0][1] + Pontos[i][1]*MT[1][1] + Pontos[i][2]*MT[2][1]);
            z = (Pontos[i][0]*MT[0][2] + Pontos[i][1]*MT[1][2] + Pontos[i][2]*MT[2][2]);
            
            //aplico as translações que existirem

            x += Tx;
            y += Ty;
            z += Tz;
            
            if(Universe){
                UrotacionarX();
                UrotacionarY();
                UrotacionarZ();
                float tempx = (x*MU[0][0] + y*MU[1][0] + z*MU[2][0]);
                float tempy = (x*MU[0][1] + y*MU[1][1] + z*MU[2][1]);
                float tempz = (x*MU[0][2] + y*MU[1][2] + z*MU[2][2]);
                x = tempx;
                y = tempy;
                z = tempz; 

                MU = matrizIdentidade();
                
            }


            //reverto o processo dos pontos para não alterar o objeto inicial
            //Pontos[i][0] = Pontos[i][0] + xcentro;
            //Pontos[i][1] = Pontos[i][1] + ycentro;
            //Pontos[i][2] = Pontos[i][2] + zcentro;   
            
            
            if(projecao == 0){
            //aplico projeçao cavaleira + reflexão no eixo y por causa das coordenadas do processing + translado a origem para o centro da tela
            resultado[i][0] = round(x + z*sqrt(2)/2) + round(width/2);            
            resultado[i][1] = -1*round(y + z*sqrt(2)/2) + round(height/2);     
            }
            
            else if(projecao == 1){
            //aplico projeçao cabinet + reflexão no eixo y por causa das coordenadas do processing + translado a origem para o centro da tela
            resultado[i][0] = round(x + z*sqrt(2)/4) + round(width/2);            
            resultado[i][1] = -1*round(y + z*sqrt(2)/4) + round(height/2);     
            }         
            
            else if(projecao == 2){
            //aplico projeçao Isométrica + reflexão no eixo y por causa das coordenadas do processing + translado a origem para o centro da tela
            resultado[i][0] = round(x*0.707 + z*0.707) + round(width/2);            
            resultado[i][1] = -1*round(x*0.408 + y*0.816 - z*0.408) + round(height/2);     
            }         
                      
            else if(projecao == 3){
            //aplico projeçao Ponto de fuga em Z + reflexão no eixo y por causa das coordenadas do processing + translado a origem para o centro da tela
            //estou considerando o ponto de fuga de z como sendo -100
            resultado[i][0] = round(x/(1-(z/-8000))) + round(width/2);            
            resultado[i][1] = -1*round(y/(1-(z/-8000))) + round(height/2);     
            }  
            
            else if(projecao == 4){
            //aplico projeçao Ponto de fuga em X e Z  + reflexão no eixo y por causa das coordenadas do processing + translado a origem para o centro da tela
            //estou considerando o ponto de fuga de z como sendo -100 e o de x 180
            resultado[i][0] = round(x/(1-(x/2000)-(z/-8000))) + round(width/2);            
            resultado[i][1] = -1*round(y/(1-(x/2000)-(z/-8000))) + round(height/2);     
            }
            
            //era pra mim converter 3D para 2D, (ou seja elimina eixo z  essa é a projeção ortográfica), mas estou guardando esse Z para calcular o zmedio 
            resultado[i][2] = round(z);
            

        }
        return resultado;
    }
    
    float [][]matrizRotacaoZ(float Rz){
        float [][]m = {{cos(Rz), sin(Rz), 0}, {-sin(Rz), cos(Rz), 0}, {0, 0, 1}};
        return m;
    
    }
 
    float [][]matrizRotacaoX(float Rx){
        float [][]m = {{1, 0, 0}, {0, cos(Rx), sin(Rx)}, {0, -sin(Rx), cos(Rx)} };
        return m;
    
    }    
 
    float [][]matrizRotacaoY(float Ry){
        float [][]m = {{cos(Ry), 0, -sin(Ry)}, {0, 1, 0}, {sin(Ry), 0, cos(Ry)} };
        return m;
    
    }     
    
    float [][] matrizEscala(float Sx, float Sy, float Sz){
        float m[][] = {{Sx, 0, 0}, {0, Sy, 0}, {0, 0, Sz}};
        return m;
    }
    
    float [][] matrizIdentidade(){
        float m[][] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
        return m;
    }
    
    void updateUniverse(float URotx, float URoty, float URotz){
        this.URx += URotx;
        this.URy += URoty;
        this.URz += URotz;
    }
    
    void ResetUniverse(){
        this.URx = 0;
        this.URy = 0;
        this.URz = 0;  
    }
            
    void update(int Tx, int Ty, int Tz, float Rx, float Ry, float Rz, float Sx, float Sy, float Sz, int projecao){
        this.MT = matrizIdentidade();
        
        this.projecao = projecao;
        
        this.Tx = Tx;
        this.Ty = Ty;
        this.Tz = Tz;
        
        
        this.Rx = Rx;
        this.Ry = Ry;
        this.Rz = Rz;
        
        
        this.Sx = Sx;
        this.Sy = Sy;
        this.Sz = Sz;               
    } 
    
    void TransV2Reset(){
        this.URx = 0;
        this.URy = 0;
        this.URz = 0;        
        
        this.Tx = 0;
        this.Ty = 0;
        this.Tz = 0;
        
        this.Rx = 0;
        this.Ry = 0;
        this.Rz = 0;
        
        this.Sz = this.Sy = this.Sx = 1;  
        MU = MT = matrizIdentidade();
    }            
}
