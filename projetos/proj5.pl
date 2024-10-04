/*
###############################################################################
#                 MC346 - PARADIGMAS DE PROGRAMACAO - 2S_2024                 #
#                 PROFo:  JACQUES WAINER                                      #
#                 NOME:   RAONITON ADRIANO DA SILVA                           #
#                 RA:     186291                                              #
###############################################################################

Projeto 5 - Prolog
ATE meia noite de 7/10

Compressão e descompressão de listas
dada a lista
[4,4,4,7,7,4,4,0,3,7,7,7,7]
vamos definir uma lista comprimida cujos elementos são listas de 2 elementos [item, quantidade], 
onde quantidade é o número de vezes que o item aparece sequenciamente na lista. 
Assim, a compressão dessa lista seria:
[[4,3],[7,2],[4,2],[0,1],[3,1],[7,4]]

- 1) Implemente o predicado comprime(ListaOriginal, ListaComprimida)

?- comprime([3,3,3,4,5,6,5,5,5,5,7], X].
X =  [[3,3],[4,1],[5,1],[6,1],[5,4],[7,1]]


- 2) Implemente a função descomprime(ListaComprimida, ListaExpandida) que é o inverso de comprime

?- descomprime([[3,3],[4,1],[5,1],[6,1],[5,4],[7,1]], X).
X =  [3,3,3,4,5,6,5,5,5,5,7]
*/


/* COMPRIME ESTA FUNCIONANDO DE FORMA BIDIRECIONAL - (COM/DESCOM)PRIME */
comprime(List, X):-  
        comprimeAux(List, 1, X).
        comprimeAux([], _, []).
        
        % Nas 3 linhas seguintes realizo a descompressao caso a lista seja do tipo [[A,B], [C,D]], nesse caso B e D sao numeros.
        comprimeAux([[A,B]|R], _, [A|X]):- B > 1, B1 is B - 1, comprimeAux([[A,B1]| R],_, X).
        comprimeAux([[A,1]|R], _, [A|X]):- comprimeAux(R,_, X).
        comprimeAux([[_,0]|R], _, X):- comprimeAux(R,_, X). % esse caso eh so para prevenir erro caso tente descomprimir uma lista [[A,0]]

        % Nas 3 linhas seguintes, realizo a compressao caso a lista seja do tipo [A,A,A,B,B,C,C]
        comprimeAux([A,A|R], N, X):- N1 is N + 1, comprimeAux([A|R], N1, X).
        comprimeAux([A,B|R], N, [[A,N]|X]):- A \= B, comprimeAux([B|R], 1, X).
        comprimeAux([A], N, [[A,N]]).

/*
socomprime(List, X):-  
        comprimeA(List, 1, X).
        comprimeA([], _, []).
        comprimeA([A,A|R], N, X):- N1 is N + 1, comprimeA([A|R], N1, X).
        comprimeA([A,B|R], N, [[A,N]|X]):- A \= B, comprimeA([B|R], 1, X).
        comprimeA([A], N, [[A,N]]).

sodescomprime(List, X):- 
        descomprimeAux(List, X).
        descomprimeAux([], []).
        descomprimeAux([[A,B]|R], [A|X]):- B > 1, B1 is B - 1, descomprimeAux([[A,B1]| R], X).
        descomprimeAux([[A,1]|R], [A|X]):- descomprimeAux(R, X).
        descomprimeAux([[_,0]|R], X):- decomprimeAux(R, X).
*/



/*
Comentário (Sugestao do professor).
É possivel que voce so precise escrever um predicado comprime(A,B) que quando dado A computa em B a compressão, 
e quando dado B (uma lista comprimida) e A é uma variavel sem valor, retorna em A a lista original. 
Nós ja vimos pelo menos dois predicados que funcionam dessa forma bidirecional o tam (tamanho de uma lista) e o append. 
Em ambos, nao pensamos explicitamente em implementar o predicado de forma bidirecional. Isso aconteceu sem querer. 
Isso pode acontecer nesse problema. Eu ainda nao implementei esse predicado mas minha intuição diz que isso pode acontecer. 
Mesmo com a minha experiencia de Prolog eu nao sei como escrever predicados que deliberadamente funcionem de forma 
bidirecional mesmo quando isso é possivel. Em suma, implementem o comprime, e testem se ele funciona de 
forma bidirecional - e assim voce não precisarão implementar o descomprime.
*/