%criando elementos de cada classe
%quadrado centrado na origem com arestas E
%E=[1 1 -1 -1;...
%   1 -1 1 -1];

nAmostras=2000; %1000 para teste e 1000 para validação

%dentro desse quadrado temos 4 semicirculos centrados em
%(1,0),(-1,0),(0,1),(0,-1)

passo=2/(nAmostras);
semiCX1=[]; %centrado em (1,0)
semiCX2=[]; %centrado em (-1,0)
semiCY1=[]; %centrado em (0,1)
semiCY2=[]; %centrado em (0,-1)
for i=-1:passo/2:1
    semiCY1=[semiCY1;semicirculo(1,i,1) i]; %calculamos o x
    semiCY2=[semiCY2;semicirculo(1,i,-1) i];
    
    semiCX1=[semiCX1;i semicirculo(1,i,1)];%calculamos o y
    semiCX2=[semiCX2;i semicirculo(1,i,-1)];
end

j=[-1:passo/2:1]';
%plot semicirculos e seus centros
figure();
hold on
plot(1,0,'*b');
plot(-1,0,'*r');
plot(0,1,'*y');
plot(0,-1,'*g');
plot(semiCY1,j,'.b');
plot(semiCY2,j,'.r');
plot(j,semiCX1,'.y');
plot(j,semiCX2,'.g');

%remover j do gráfico
for i=-1:passo/2:1
    if(i~=0)
        plot(i,i,'.w');
    end
end
%plotar origem
plot(0,0,'*black');
%sorteando pontos dentro do quadrado

C=[];

for i=1:nAmostras
    x=rand(1)*2-1;
    y=rand(1)*2-1;
    C=[C;x y];
    plot(x,y,'+m');
end
Treino=C(1:(nAmostras/2),:);
Validacao=C((nAmostras/2 + 1):end,:);

%dividir entre classe 1 (com intersecção) e classe 2(sem intersecção)
%gerar a resposta desejada t

%plot do espaço C e da resposta desejada
t=zeros(1,nAmostras);%supor que nao pertence a interseccao
for i=1:nAmostras
    x=C(i,1);
    y=C(i,2);
    
    %para x positivo ->pode pertencer ao Y1 e X1 ou ao Y1 e X2
    if(x>=0 && x>=semicirculo(1,y,1))%pertence a Y1
        if(y>=semicirculo(1,x,1))%pertence a X1
            t(i)=1;%intersecção
            plot(x,y,'+c');
        end
        if(y<=semicirculo(1,x,-1))%pertence a X2
            t(i)=1;%intersecção
            plot(x,y,'+c');
        end
    end
    %para x negativo ->pode pertencer ao Y2 e X1 ou ao Y2 e X2
    if(x<=0 && x<=semicirculo(1,y,-1))%pertence a Y2
        if(y>=semicirculo(1,x,1))%pertence a X1
            t(i)=1;%intersecção
            plot(x,y,'+c');
        end
        if(y<=semicirculo(1,x,-1))%pertence a X2
            t(i)=1;%intersecção
            plot(x,y,'+c');
        end
    end
    
end

TargetTreino=t(1:(nAmostras/2));
EspelhoValidacao=t((nAmostras/2 +1):end);


hold off


%uso da svm
figure();
hold on
plot(1,0,'*b');
plot(-1,0,'*r');
plot(0,1,'*y');
plot(0,-1,'*g');
plot(semiCY1,j,'.b');
plot(semiCY2,j,'.r');
plot(j,semiCX1,'.y');
plot(j,semiCX2,'.g');

%remover j do gráfico
for i=-1:passo:1
    if(i~=0)
        plot(i,i,'.w');
    end
end
%plotar origem
plot(0,0,'*black');
%uso da svm
%treino
svmStruct=svmtrain(Treino,TargetTreino,'showplot','true','kernel_function','rbf',...
'boxconstraint',1,'kktviolationlevel',0.05,'tolkkt',5e-3);


%validacao
Group=svmclassify(svmStruct,Validacao,'Showplot',true);

hold off
%Matriz de Confusao

figure();
hold on
plot(1,0,'*b');
plot(-1,0,'*r');
plot(0,1,'*y');
plot(0,-1,'*g');
plot(semiCY1,j,'.b');
plot(semiCY2,j,'.r');
plot(j,semiCX1,'.y');
plot(j,semiCX2,'.g');

%remover j do gráfico
for i=-1:passo:1
    if(i~=0)
        plot(i,i,'.w');
    end
end
%plotar origem
plot(0,0,'*black');

%matriz de confusão

cont=0;
for i=1:nAmostras/2
    x=Validacao(i,1);
    y=Validacao(i,2);
    if(Group(i)~=EspelhoValidacao(i))
        cont=cont+1;
        plot(x,y,'*r'); %erro
    else
        plot(x,y,'*g'); %acerto
    end 
end
erro=cont/(nAmostras/2)



hold off