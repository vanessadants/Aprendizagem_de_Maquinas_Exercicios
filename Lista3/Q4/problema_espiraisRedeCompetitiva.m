%Criação das Espirais e pontos%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%criando elementos de cada classe
nAmostras=51;

%para espiral 1:  x=(teta/4)cos(teta) y=(teta/4)sen(teta)   teta>=0
%para espiral 2:  x= ((teta/4)+0.8)cos(teta)     y= ((teta/4)+0.8)sen(teta)    teta>=0
%fazendo teta assumir 51 igualmente espacados valores entre 0 e 20 radianos.

MAX=20;
MIN=0;
passo=(MAX-MIN)/nAmostras;
C=[];
espiral1=[]; %x1=(teta/4)*cos(teta) y1=(teta/4)*sin(teta)   teta>=0
espiral2=[]; %x2= ((teta/4)+0.8)*cos(teta)     y2= ((teta/4)+0.8)*sin(teta)    teta>=0
p1=[];
p2=[];
for teta=MIN:passo:MAX
    x1=(teta/4)*cos(teta);
    y1=(teta/4)*sin(teta);
    x2=((teta/4)+0.8)*cos(teta); 
    y2=((teta/4)+0.8)*sin(teta);
    espiral1=[espiral1;x1 y1];
    espiral2=[espiral2;x2 y2];
    
    p1=[p1;x1 y1 0];
    p2=[p2;x2 y2 100];
    
end
teta=[MIN:passo:MAX]';
espiral1=espiral1(1:(end-1),:);
espiral2=espiral2(1:(end-1),:);
p1=p1(1:(end-1),:,:);
p2=p2(1:(end-1),:,:);

C=[espiral1;espiral2];
p=[p1;p2];

%plotando em relação a teta
teta=teta(1:(end-1));

hold on
plot(teta,espiral1,'r');
plot(teta,espiral2,'g');
plot(teta,espiral1,'+r');
plot(teta,espiral2,'*g');

hold off

%plotando em relação a ao plano x y cartesiano
figure();
hold on

plot(C(:,1),C(:,2),'*black');
plot(espiral1(:,1),espiral1(:,2),'r');
plot(espiral2(:,1),espiral2(:,2),'g');

hold off


%embaralhar ordem das colunas
aux=randperm(2*nAmostras);
p=p';
C=C';
C=C(:,aux);%desse modo trocamos a ordem das colunas
p=p(:,aux);
Target=Target(:,aux);
C=C';

%Normalizar entradas e pesos
p=p/max(max(abs(p)));

%Rede Competitiva
%criação rede competitiva
nNeuronios=2;
net = competlayer(nNeuronios);


%weights will initialized to the centers of the input ranges with the function midpoint
wts = midpoint(nNeuronios,p);

%The initial biases are computed by initcon
biases = initcon(nNeuronios);


%treinar rede
epocas=100;%número de epocas
net.trainParam.epochs = epocas; 
net = train(net,p);
net.trainFcn

%calculo da resposta
a = sim(net,p);
outputs = vec2ind(a);

%look at the final weights and biases
%net.IW{1,1}
%net.b{1}

%plot
figure();

hold on
plot(espiral1(:,1),espiral1(:,2),'r');
plot(espiral2(:,1),espiral2(:,2),'g');

comp=p';
if(outputs(1)==1 && comp(1,3)==0)
    %classe 1 outputs=1
    %classe 2 outputs=2
    classe1=1;
    classe2=2;
else %outputs(1)==1 && comp(1,3)==100
    %classe 2 outputs=1
    %classe 1 outputs=2
    classe1=2;
    classe2=1;
end 

for i=1:2*nAmostras
     x=C(i,1);
     y=C(i,2);
     if(outputs(i)==1 && classe1==1)
         plot(x,y,'ro'); %classe 1
     elseif(outputs(i)==1 && classe1==2)
         plot(x,y,'*g'); %classe 2
     elseif(outputs(i)==2 && classe2==1)
         plot(x,y,'ro'); %classe 1
     else %outputs(i)==2 && classe2==2
         plot(x,y,'*g'); %classe 2
     end 
 end

hold off

%erro e matriz de confusão
%plot e calculo do erro
figure();

erro=0;
hold on
plot(espiral1(:,1),espiral1(:,2),'r');
plot(espiral2(:,1),espiral2(:,2),'g');
   
%classe1==1 e classe2==2
if(classe1==1)
    for i=1:2*nAmostras
       
        x=C(i,1);
        y=C(i,2);
        if((outputs(i)==1 && classe1==1)||(outputs(i)==2 && classe2==2))
            plot(x,y,'bo'); %acerto
        else
            erro=erro+1;
            plot(x,y,'*m'); %erro
        end 
    end
else %classe1==2 e classe2==1
    for i=1:2*nAmostras
        x=C(i,1);
        y=C(i,2);
       
        if((outputs(i)==1 && classe1==2)||(outputs(i)==2 && classe2==1))
            plot(x,y,'bo'); %acerto
        else
            erro=erro+1;
            plot(x,y,'*m'); %erro
        end 
    end
end




disp(['Número de erros = ' num2str(erro)]);
disp(['Percentual de erro= ' num2str(erro/(2*nAmostras)) '%']);

hold off



return;




