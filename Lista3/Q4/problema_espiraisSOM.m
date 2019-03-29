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

%dividir entre classe 1 (espiral1, saida 0) e classe 2(espiral2,saida 1)
%gerar a resposta desejada t
Target=zeros(1,2*nAmostras);
Target(nAmostras+1:end)=1;


p=p';
%Normalizar entradas e pesos
p=p/max(max(abs(p)));

%Rede SOM
outputs=myNeuralNetworkFunction(p);

%malha -5 a 5 igualmente espaçados
inicio=-5;
fim=5;
espaco=(fim-inicio);
tamRede=20*20; 

passoMalhaX=espaco/tamRede;
passoMalhaY=espaco/(2*nAmostras);

%plot dos clusters
figure();
hold on;

x=inicio;
for lin=1:length(outputs)
    y=inicio;
    for col=1:2*nAmostras
        if outputs(lin,col)==1 %--> foi ativado
            if(Target(col)==0)%classe 1 
                plot(x,y,'ro');
            else %classe 2
                plot(x,y,'*g');
            end
        else % outputs(lin,col)==0 --> não foi ativado
            %plot(x,y,'.b');
        end
        y=y+passoMalhaY;
    end
    x=x+passoMalhaX;
end

hold off

return;
