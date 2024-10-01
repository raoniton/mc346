/*
tarefa 4
remove item da lista (todas as vezes)

Escreva o predicado removetodos com 3 argumentos. 
O primeiro é um item, o segundo uma lista e o terceiro uma lista que é a segunda 
lista onde todos os elementos que são iguais ao item foram removidos. 
Para programar esse predicado assuma que o item e a lista são dados 
e voce precisa computar a lista com todas as instancias do item removidos.

?- removetodos(4, [1,2,4,5,6,4,3,2], X).
X = [1,2,5,6,3,2]
 
?- removetodos(44, [1,2,4,5,6,4,3,2], X).
X = [1,2,4,5,6,4,3,2]
*/

/* removetodos(+_, +[], -[])*/
removetodos(_, [], []).                             
removetodos(Item, [Item|R], New) :- removetodos(Item, R, New).
removetodos(Item, [X|R], [X|New]) :- X \= Item, removetodos(Item, R, New).
