/*
EXERCICIOS 
Da aula 1 e 2 e haskell - use acumuladores quando necessario.

o append(+,+, -)

append([],A,A).
append([X|R],A,AA) :- append(R,A,RR), AA = [X|RR].

ou 

append([],A,A).
append([X|R], A, [X|RR]) :- append(R,A,RR).

*/

/* 1 -  tamanho de uma lista 
    ?- tam([1,2,3,4,5,6], X).
    X = 6.
*/
tam([], 0).
tam([_|R], N) :- tam(R, N1), N is N1+1 .


/* 2 - soma dos elementos nas posições pares da lista ( o primeiro elemento esta na posicao 1. somapospar(+LISTA,-SOMA) 
    ?- somapospar([1,2,3,4,5,6,7,8], X).
    X = 20.
*/
somapospar([],0).
somapospar([_,B|R], SUM) :- somapospar(R, SUM1), SUM is SUM1+B . 


/* 3 - existe item na lista `elem(+IT,+LISTA) */
existe(It, [It|_]).
existe(It, [_|R]) :- existe(It, R).


/* 4 - posição do item na lista: 1 se é o primeiro, falha se nao esta na lista pos(+IT,+LISTA,-POS) 
    ?- pos(1, [5,4,3,2,1], POS).
    POS = 5 .
*/
pos(IT, [IT|_], 1).
pos(IT, [_|R], POS) :- pos(IT,R,POS1), POS is POS1+1. 


/* 5 - conta quantas vezes o item aparece na lista (0 se nenhuma) conta(+IT,+LISTA,-CONTA) 
    ?- conta(1, [1,1,3,1,5], CONTA).
    CONTA = 3 
*/
conta(_, [], 0).
conta(IT, [IT|R], CONTA) :- conta(IT, R, CONTA1), CONTA is CONTA1 + 1.
conta(IT, [_|R], CONTA) :- conta(IT, R, CONTA).


/* 6 - reverte uma lista. reverte(+LISTA,-LISTAR) 
    ?- reverte([1,2,3,4,5,6], Lista).
    Lista = [6, 5, 4, 3, 2, 1].
*/
reverte(List,Rev):- 
            reverteAcc(List,[],Rev).
            reverteAcc([], Rev, Rev).
            reverteAcc([L|LX], Aux, Rev) :- reverteAcc(LX, [L|Aux], Rev).


/* 7 - intercala 2 listas (intercala1 e intercala2) 

intercala1([1,2,3], [4,5,6,7,8], X).
 X =  [1,4,2,5,3,6]
intercala2([1,2,3], [4,5,6,7,8], Y),
 Y =   [1,4,2,5,3,6,7,8]
*/

intercala1([], _, []).
intercala1(_, [] , []).
intercala1([L1|L1R], [L2|L2R], [L1,L2 | X]):- intercala1(L1R, L2R, X).


intercala2([], L2, L2).
intercala2(L1, [] , L1).
intercala2([L1|L1R], [L2|L2R], [L1,L2 | X]):- intercala2(L1R, L2R, X).


/* 8 - a lista ja esta ordenada? ordenada(+LISTA) 
    ?- ordenada([1,2,0]).
    false.
*/
ordenada([]).
ordenada([_]).
ordenada([X,Y|R]):- X =< Y, ordenada([Y|R]).


/* 9 - dado n gera a lista de n a 1 range(+N,-LISTA) 
    ?- geraList(9, Lista).
    Lista = [9, 8, 7, 6, 5, 4, 3, 2, 1] 
*/
geraList(0, []).
geraList(N, [N|R]):-    N > 0,
                        N1 is N - 1,
                        geraList(N1, R).


/* 10 - retorna o ultimo elemento de uma lista ultimo(+LISTA, -ULT) 
    ?- ultimo([1,2,3],Ult).
    Ult = 3 .
*/
ultimo([], []).
ultimo([X], X).
ultimo([_|R], X):- R \= [], ultimo(R, X).


/* 11 - retorna a lista sem o ultimo elemento: semultimo(+L,-LSEMULT) 
    ?- semultimo([1,2,3,4], Lista).
    Lista = [1, 2, 3].
*/
semultimo([],[]).
semultimo([_],[]).
semultimo([L1|L1R], [L1|X]):- L1R \= [], semultimo(L1R, X). 


/* 12 - shift right 
    shiftr([1,2,3,4],X)
    X = [4,1,2,3]
*/
shiftr([],[]).
shiftr([X],[X]).
shiftr(L1, X):- semultimo(L1, Y),
                ultimo(L1, Z),
                X =[Z|Y].


/* 13 - shiftr n lista (shift right n vezes) 
    ?- shiftrn(2, [1,2,3,4], X).
    X = [3, 4, 1, 2] .
*/
shiftrn(0, X, X).
shiftrn(N, L1, X):- shiftr(L1, Y),
                    N1 is N-1,
                    shiftrn(N1, Y, X).
                    

/* 14 - shift left 
    ?- shiftl([1,2,3,4], X).
    X = [2, 3, 4, 1].
*/
shiftl([],[]).
shiftl([X],[X]).
shiftl([L|LS], X):- append(LS, [L], X) . 


/* 15 - shift left n vezes 
    ?- shiftln(3, [1,2,3,4], X).
    X = [4, 1, 2, 3].
*/
shiftln(0, X, X).
shiftln(N, L1, X):- shiftl(L1, Y),
                    N1 is N-1,
                    shiftln(N1, Y, X).
                    

/* 16 - remove item da lista (1 vez só): remove(+IT,+LISTA,-LISTASEM). 
    ?- remove(4, [1,2,3,4,5,6,7], X).
    X = [1, 2, 3, 5, 6, 7] .
*/
remove(_, [], []).
remove(IT, [IT|LS], LS).
remove(IT, [L|LS], [L|X]):- remove(IT, LS, X).


/* 17 - remove item da lista (todas as vezes) 
    ?- removeAll(4, [4,1,2,3,4,4,4,5,6,7,4], X).
    X = [1, 2, 3, 5, 6, 7] .
*/
removeAll(_, [], []).
removeAll(IT, [IT|LS], X):- removeAll(IT, LS, X).
removeAll(IT, [L|LS], [L|X]):- removeAll(IT, LS, X).


/* 18 - remove item da lista n (as primeiras n vezes) 
    ?- removeN(4, 4, [4,1,2,3,4,4,8,4], X).
    X = [1, 2, 3, 8] .
*/
removeN(_, _,  [], []).
removeN(_, 0,  X, X).
removeN(IT, N, [IT|LS], X):- N1 is N - 1, removeN(IT, N1, LS, X).
removeN(IT, N, [L|LS], [L|X]):- removeN(IT, N, LS, X).


/* 19 - remove item da lista (a ultima vez que ele aparece) 
    ?- removeUltimaVez(1, [1,2,3,4,5,1,0,10,30], X).
    X = [1, 2, 3, 4, 5, 0, 10, 30] .
*/
removeUltimaVez(_, [], []).
removeUltimaVez(IT, [L|LS], X):- reverte([L|LS], Rev),
                                 remove(IT, Rev, Y),
                                 reverte(Y, X).


/* 20 - troca velho por novo na lista (1 só vez): troca(+L,+VELHO,+NOVO, -LISTAtrocada) 
    ?- troca([1,2,3,4], 2, 20, X).
    X = [1, 20, 3, 4] .
*/
troca([], _, _, []).
troca([Velho|LS], Velho, Novo, [Novo|LS]).
troca([L|LS], Velho, Novo, [L|X]):- troca(LS, Velho, Novo, X).


/* 21 - troca velho por novo na lista (todas vezes) 
    ?- trocaAll([1,2,3,4,2,2], 2, 20, X).
    X = [1, 20, 3, 4, 20, 20] .
*/
trocaAll([], _, _, []).
trocaAll([Velho|LS], Velho, Novo, [Novo|X]):- trocaAll(LS, Velho, Novo, X).
trocaAll([L|LS], Velho, Novo, [L|X]):- trocaAll(LS, Velho, Novo, X).

/* 22 - troca velho por novo na lista n (as primeiras n vezes) 
    trocaN([1,2,3,4,2,2,2,2,2], 2, 20,4, X).
    X = [1, 20, 3, 4, 20, 20, 20, 2, 2].
*/
trocaN([], _, _, _, []).
trocaN(X, _, _, 0, X).
trocaN([Velho|LS], Velho, Novo, N, [Novo|X]):- N1 is N - 1, trocaN(LS, Velho, Novo, N1, X).
trocaN([L|LS], Velho, Novo, N, [L|X]):- trocaN(LS, Velho, Novo, N, X).

