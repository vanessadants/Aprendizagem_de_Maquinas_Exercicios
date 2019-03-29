%criando elementos de cada classe
nAmostras=100;

%para espiral 1:  x=(teta/4)cos(teta) y=(teta/4)sen(teta)   teta?0
%para espiral 2:  x= ((teta/4)+0.8)cos(teta)     y= ((teta/4)+0.8)sen(teta)    teta?0
%fazendo teta assumir 100 igualmente espacados valores entre 0 e 20 radianos.

MAX=20;
MIN=0;
passo=(MAX-MIN)/nAmostras;
C=[];
espiral1=[]; %x1=(teta/4)*cos(teta) y1=(teta/4)*sin(teta)   teta?0
espiral2=[]; %x2= ((teta/4)+0.8)*cos(teta)     y2= ((teta/4)+0.8)*sin(teta)    teta?0

for teta=MIN:passo:MAX
    x1=(teta/4)*cos(teta);
    y1=(teta/4)*sin(teta);
    x2=((teta/4)+0.8)*cos(teta); 
    y2=((teta/4)+0.8)*sin(teta);
    espiral1=[espiral1;x1 y1];
    espiral2=[espiral2;x2 y2];
end
teta=[MIN:passo:MAX]';
espiral1=espiral1(1:(end-1),:);
espiral2=espiral2(1:(end-1),:);

C=[espiral1;espiral2];
Treino=[];
Validacao=[];
for i=1:2*nAmostras
   if(mod(i,2)==0) %treino
      Treino=[Treino;C(i,1) C(i,2)];
   else %validacao
      Validacao=[Validacao;C(i,1) C(i,2)];
   end
end

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
TargetTreino=zeros(1,nAmostras);
TargetTreino(nAmostras/2+1:end)=1;

EspelhoValidacao=zeros(1,nAmostras);
EspelhoValidacao(nAmostras/2+1:end)=1;


%MLP
TreinoT=Treino;
Treino=Treino';

ValidacaoT=Validacao';

%uso da nntool
%saída
load('mlp5.mat');
outputs=mlp5(ValidacaoT);

%plot da classificação dos pontos validados
figure();
%plot semicirculos e seus centros
hold on

plot(espiral1(:,1),espiral1(:,2),'r');
plot(espiral2(:,1),espiral2(:,2),'g');

 for i=1:nAmostras
     x=TreinoT(i,1);
     y=TreinoT(i,2);
     if(TargetTreino(i)==1)
         plot(x,y,'*g'); %classe interseccao
     else
         plot(x,y,'+r'); %classe nao interseccao
     end 
 end

 for i=1:nAmostras
     x=Validacao(i,1);
     y=Validacao(i,2);
     if(round(outputs(i))==1)
         plot(x,y,'*c'); %classe interseccao
     else
         plot(x,y,'+m'); %classe nao interseccao
     end 
 end
hold off

%verificar acerto mlp
%plot semicirculos e seus centros
figure();
hold on
plot(espiral1(:,1),espiral1(:,2),'r');
plot(espiral2(:,1),espiral2(:,2),'g');

cont=0;
%matriz de confusão

for i=1:nAmostras
    x=Validacao(i,1);
    y=Validacao(i,2);
    if(round(outputs(i))~=EspelhoValidacao(i))
        cont=cont+1;
        plot(x,y,'*r'); %erro
    else
        plot(x,y,'*g'); %acerto
    end 
end
erro=cont/(nAmostras)




hold off




