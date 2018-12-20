import java.util.ArrayList;
import java.util.*;


public class Objeto3D_Com_Faces{
    int [][]P;
    int [][]L;
    
    String nomeObjeto;
    
    int projecao; 
      
    int VTx, VTy, VTz;//VALORES PARA A TRANSLAÇÃO
    float VRx , VRy , VRz;//VALORES PARA A ROTAÇÃO
    float VSx, VSy, VSz;//VALORES PARA A ESCALA
    float EscalaProporcionalAoUniverso;
    
    int X_universo, Y_universo;
    
    ArrayList <Face> FaceList = new ArrayList();


    TransV2 transformacoes;
    
    
    Objeto3D_Com_Faces(int [][]P, int [][]L,  ArrayList <Face> FaceList, int X_universo, int Y_universo, String nomeObjeto){
        this.P = P;
        this.L = L;       
      
        this.VTx = this.VTy = this.VTz = 0;
        this.VRx = this.VRy = this.VRz = 0;
        //this.VSx = this.VSy = this.VSz = 1;
       
        //Nessa linha eu seto o tamanho do universo, nas proximas tarefas deverei pegar esses valores no momento de criação do objeto
        this.X_universo = X_universo;
        this.Y_universo = Y_universo;

        
        this.FaceList = FaceList;
        for(int i = 0; i < FaceList.size(); i++){
            FaceList.get(i).calculaZmedio(this.P);
        }
        
        this.nomeObjeto = nomeObjeto;
        
        if(this.Y_universo/(height*1.0) <= this.X_universo/(width*1.0))this.EscalaProporcionalAoUniverso = this.VSx = this.VSy = this.VSz = this.Y_universo/(height*1.0);
        else this.EscalaProporcionalAoUniverso = this.VSx = this.VSy = this.VSz = this.X_universo/(width*1.0);
        //println("\n\n\n\n\n\n VSX: " + this.VSx + " VSY "+ this.VSy);
                      
        //calculaCentro();println(xcentro+" " + ycentro + " " +zcentro);
        this.transformacoes = new TransV2(VTx, VTy, VTz, VRx, VRy, VRz, VSx, VSy, VSz); 
        projecao = 0;                
        
        //for(int i = 0; i < this.FaceList.size(); i++){
        //    println("\n\n Pontos da Face "+ i + ": ");
        //    for(int j = 0; j < FaceList.get(i).F.length; j++){
        //        println( FaceList.get(i).F[j] + " ");
        //    }
        //}
    }
    
    //void desenhaObjeto3D(boolean isSelected){         
    //    int [][] Pontos = transformacoes.aplicarTransformacao(this.P);
    //    if(isSelected){
    //        for(int rows = 0; rows < L.length; rows++){
    //            int xi = Pontos[L[rows][0]][0];
    //            int yi = Pontos[L[rows][0]][1]; 
    //            int xf = Pontos[L[rows][1]][0];
    //            int yf = Pontos[L[rows][1]][1];
                
    //            LinhaDDA temp = new LinhaDDA(xi, yi, xf, yf, color(0,255,0));  
    //        }
    //    }
    //    else{
    //        for(int rows = 0; rows < L.length; rows++){
    //            int xi = Pontos[L[rows][0]][0];
    //            int yi = Pontos[L[rows][0]][1]; 
    //            int xf = Pontos[L[rows][1]][0];
    //            int yf = Pontos[L[rows][1]][1];
                
    //            LinhaDDA temp = new LinhaDDA(xi, yi, xf, yf, color(255,0,0));  
    //        }
    //    }
    //} 
    
    void desenhaObjeto3Dcolorido(boolean isSelected){
        int [][] Pontos = transformacoes.aplicarTransformacao(this.P);
        ArrayList <Face> FacesVisiveis = new ArrayList();
        
         //Gambiarra para fazer o chão ser sempre visivel
        if(FaceList.size() == 1)FacesVisiveis.add( new Face(FaceList.get(0).F, FaceList.get(0).R, FaceList.get(0).G, FaceList.get(0).B));
        else{
            //faço o calculo da normal de todas as faces do objeto e adiciono apenas as faces visiveis no arraylist de facesvisiveis
            for(int i = 0; i < FaceList.size(); i++){
                int P1x = Pontos[FaceList.get(i).F[2]][0];
                int P2x = Pontos[FaceList.get(i).F[1]][0];
                int P3x = Pontos[FaceList.get(i).F[0]][0];
                
                int P1y = Pontos[FaceList.get(i).F[2]][1];
                int P2y = Pontos[FaceList.get(i).F[1]][1];
                int P3y = Pontos[FaceList.get(i).F[0]][1];
             
                int P1z = Pontos[FaceList.get(i).F[2]][2];
                int P2z = Pontos[FaceList.get(i).F[1]][2];
                int P3z = Pontos[FaceList.get(i).F[0]][2];
                
                int nx = (P3y-P2y)*(P1z-P2z) - (P1y-P2y)*(P3z-P2z);
                int ny = (P3z-P2z)*(P1x-P2x) - (P1z-P2z)*(P3x-P2x);
                int nz = (P3x-P2x)*(P1y-P2y) - (P1x-P2x)*(P3y-P2y);
                
                //Pontos do observador
                int Px = 10;
                int Py = -height;
                int Pz = -3*width;
                
                //se o produto interno for maior do que 0 eu adiciono a face nas faces visiveis
                int produtointerno = nx*(Px-P2x)+ ny*(Py-P2y) + nz*(Pz-P2z);
               // println("\nPRODUTO INTERNO É: "+ produtointerno + "\n");
                if( produtointerno >= 0)
                FacesVisiveis.add( new Face(FaceList.get(i).F, FaceList.get(i).R, FaceList.get(i).G, FaceList.get(i).B));
            }        
            
            
            //calcula zMédio apenas das faces visiveis
            for(int i = 0; i < FacesVisiveis.size(); i++){
                FacesVisiveis.get(i).calculaZmedio(Pontos);
            }
            //ordeno as faces de forma que as com menor zmédio aparecerão nas primeiras posições do arraylist
            Collections.sort(FacesVisiveis, new ZmedioDescendingComparator());     
            
          //  println("numero de faces visiveis: " + FacesVisiveis.size());
            
        } 
        
        if(isSelected){
            for(int i = 0; i < FacesVisiveis.size(); i++){
              //  println("Zmédios: " + FacesVisiveis.get(i).Z_medio);
             
                //println("R "+FacesVisiveis.get(i).R + " G " + FacesVisiveis.get(i).G + " B " + FacesVisiveis.get(i).B);
                //PoligonoVF faceatual = new PoligonoVF(Pontos, L, FacesVisiveis.get(i), color(0,255,0), true, color(0,0,255));
                //PoligonoVF faceatual = new PoligonoVF(Pontos, L, FacesVisiveis.get(0), color(0,255,0), true, color(FacesVisiveis.get(0).R,FacesVisiveis.get(0).G,FacesVisiveis.get(0).B));
                PoligonoVF faceatual = new PoligonoVF(Pontos, L, FacesVisiveis.get(i), color(0,255,0), true, color(FacesVisiveis.get(i).R,FacesVisiveis.get(i).G,FacesVisiveis.get(i).B));
            }
        }
        else{
            for(int i = 0; i < FacesVisiveis.size(); i++){
                PoligonoVF faceatual = new PoligonoVF(Pontos, L, FacesVisiveis.get(i), color(255,0,0), true, color(FacesVisiveis.get(i).R,FacesVisiveis.get(i).G,FacesVisiveis.get(i).B));
                //PoligonoVF faceatual = new PoligonoVF(Pontos, L, FacesVisiveis.get(i), color(255,0,0), true, color(0,0,255));
            }
        }
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

class ZmedioDescendingComparator implements Comparator<Face> {    
    int compare(Face face1, Face face2) {
        return face1.Z_medio - face2.Z_medio;  
        
    }  
}
