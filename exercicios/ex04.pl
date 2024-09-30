/*Exercício
- 1) escreva a regra para irmao(X,Y) ou na verdade meio-irmão (um parente em comum). 
Sua solução nao vai estar 100% certa. Discutiremos esse problema na próxima aula
*/

/*
- 2) escreva a regra para irmao_cheio(X,Y) - 2 pessoas com os mesmos 2 parentes
*/

/*
- 3)Suponha um banco de dados com fatos pai e mae.

pai(antonio, beatriz).
pai(cassio, durval).
...
mae(tereza, beatriz).
mae(valeria, durval).

para esse banco de fatos escreva a regra para avo(A,N) onde A é um dos avôs de N (neto/neta) . 
Note que há duas formas de ser avô, pai do pai ou pai da mae. Serão 2 regras para avo.
*/

/*
- 4) escreva a regra recursiva descendente(D,A) onde D é um descendente de A (antecessor). 
Assuma o banco de dados original, com um predicado parent
*/

/* 1 */

parent(andre, mauricio).
parent(andre, bianca).
parent(andre, leonardo).
parent(pedro, carla).
parent(pedro, eduardo).
parent(diana, rose).
parent(diana, mauricio).
parent(diana, bianca).
parent(elza, rose).

parent(alberto,beatriz).
parent(alberto,carlos).
parent(alberto,zeca).
parent(denise,beatriz).
parent(denise,zeca).
parent(elisa,carlos).
parent(beatriz,flavio).
parent(gustavo,flavio).

meio_irmao(X,Y) :- parent(Z, X), parent(Z, Y), \+ X=Y.

/* 2 */
irmao_cheio(X,Y):- parent(P, X), parent(P, Y),
                     parent(M, X), parent(M, Y), \+ X=Y, \+ M=P.


/* 3 */
pai(anderson, barbara).
pai(anderson, carlos).
pai(pedro, julio).
pai(pedro, vitoria).
pai(jorge, anderson).
pai(jorge, pedro).
pai(julio, ana).

mae(sara, anderson).
mae(sara, pedro).
mae(sara, bruna).

avo(A, N) :- pai(X, N), pai(A,X).
avo(A, N) :- mae(Y, N), pai(A, Y).            




/* 4 */
% esse exemplo esta na aula 12
descende(X,Ansestral) :- parent(PAI, X), descende(PAI,Ansestral).