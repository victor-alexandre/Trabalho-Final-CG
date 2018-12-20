public class LinhaDDA{

  LinhaDDA(int xi, int yi, int xf, int yf, color cor_linha){
    int dx = xf - xi;
    int dy = yf - yi;
    int steps;
    float incX;
    float incY;
    float x = xi;
    float y = yi;

    if(abs(dx) > abs(dy)){
      steps = abs(dx);  
    }  else{
      steps = abs(dy);
    }
    incX = dx/float(steps);
    incY = dy/float(steps);
    
    loadPixels();
    for(int i = 0; i <= steps; i++){
      if(x < width && x >= 0 && y < height && y >= 0)pixels[int(y)*width + int(x)] = cor_linha;
      x += incX;
      y += incY;   
    } 
   updatePixels(); 
  }
}
