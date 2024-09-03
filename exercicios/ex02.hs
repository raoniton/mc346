{-
refaça os exercicios da aula passada usando variaveis locais, recursão com acumulador, 
list comprehension, funções retornando tuplas, combinando funções ja implementadas, etc se for o caso. 
Em particular tente usar acumuladores para aprender a pensar dessa forma.

Alem disso faça:

-- posicoes - dado um item e uma lista, retorna uma lista com todas as posicoes (primeiro elemento esta na posição 1) do item na lista

-- split - dado um item e uma lista retorna uma lista de listas, todos os elementos da lista antes do item (a primeira vez que ele aparece) e todos depois

-- split "qwertyuiopoiuyt" 't' 
-- ==> ["qwer", "yuiopoiuyt"]
-- splitall - mesma coisa que o split mas retorna todas as sublistas
splitall "qwertyuiopoiuytxxt" 't' 
-- ==> ["qwer", "yuiopoiuy", "xx", ""]  ou  ["qwer", "yuiopoiuy", "xx"]
-- drop n lista - a lista sem os n primeiros elementos - essa função já esta implementada no Prelude

-- take n lista - os primeiros n elementos da lista - essa função já esta implementada no Prelude
-}

-- ## EXERCICIOS DA AULA 1 e 2 (Fazendo ou refazendo os que não consegui fazer anteriomente)

-- 1) Tamanho de uma lista
tam list1 = if list1 == []
    then 0
    else (1+ tam(tail list1))

--tam'::[a]->Int
-- Tamanho da lista utilizando guards e pattern matching
tam'[] = 0
tam' (x:xs)
    | otherwise = (1 + tam' (xs))


---------------------------------------------------------------------------------------
-- 2) Conta quantas vezes o item aparece na lista (0 se nenhuma)
qts item list = if list == []
    then 0
    else (if head list == item then 1 else 0) + qts item (tail list)

-- Função utlizando guards e pattern matching
qts' item [] = 0
qts' item (x:xs)
    | x == item = 1 + qts' item xs
    | otherwise = 0 + qts' item xs 


---------------------------------------------------------------------------------------
-- 3) Soma dos elementos de uma lista
soma list = if list == []
    then 0
    else head list + soma (tail list)

-- Soma utilizando acumuladores
{- Na hora de chamar temos que chamar passando 0 (zero)
    ex: soma' 0 [1,2,3,4] 
    ou fazer uma funcao auxiliar que passa a lista e chama soma' internamente
    ex: soma list = soma' 0 list
        where (E AQUI DEFINIMOS A FUNCAO soma')
-}
somaAc list = soma' 0 list
    where soma' acc [] = acc
          soma' acc (x:xs) = soma' (acc + x) xs


---------------------------------------------------------------------------------------
-- 4) Soma dos números pares de uma lista ( modulo = mod)
somaPar list = if list == []
    then 0
    else (if mod (head list) 2 == 0 then head list else 0) + somaPar (tail list)

-- Soma dos numeros pares de uma lista, utilizando acumulador
somaParAc' list = somaPar' 0 list
    where somaPar' acc [] = acc
          somaPar' acc (x:xs) =    if(x `mod` 2 == 0) 
                                    then somaPar' (acc + x) xs
                                    else somaPar' (acc) xs


---------------------------------------------------------------------------------------
-- 5) Retorna o ultimo elemento de uma lista
ultimo [] = 0
ultimo (x:xs) = if xs == [] then x else ultimo xs

-- retorna o ultimo elemento de uma lista utilizando where guards
ultimo' [] = 0
ultimo' (x:xs) 
    | xs == [] = x
    | otherwise = ultimo' xs


---------------------------------------------------------------------------------------
-- 6) Existe item x na lista (True ou False)
existe item [] = False
existe item (x:xs) = if item == x then True else existe item xs


-- existe item x na lista (true ou false) utilizando guards
existe' item [] = False
existe' item (x:xs)
    | x == item = True
    | otherwise = existe' item xs


---------------------------------------------------------------------------------------
-- 7) dado n gera a lista de n a 1
geraList 0 = []
geraList x = (x):[] ++ geraList (x-1)


-- gera lista de n a 1 utilizando guards
geraList' x
    | x == 0 = []
    | otherwise = (x): geraList'(x-1) 

{-
range_rev n = if n==1
        then [1]
        else n:range_rev (n-1)
ou

range_rev' 1 = []
range_rev' n = n: range_rev (n-1)
-}



---------------------------------------------------------------------------------------
-- 8) posição do item na lista (0 se não esta lá, 1 se é o primeiro) **
pos item (x:xs) = pos' item (x:xs) 1   -- inicio o acumulador acc = 1, para que a contagem funcione corretamente se o item nao for o primeiro
    where pos' item [] acc = 0        -- se a lista estiver vazia, retorna 0
          pos' item (x:xs) acc 
            | (x == item) && (acc == 0) = 1
            | x == item = acc
            | otherwise = pos' item xs (acc+1)

{-
posicao it [] = 0
posicao it (x:xs) 
  | it == x = 1
  | otherwise = if (posicao it xs) == 0 then 0 else (posicao it xs) + 1  
  --- dupla recursao a nao ser que (posicao it xs) == 0
-}



---------------------------------------------------------------------------------------
-- 9) reverte uma lista
reverte [] = []
reverte (x:xs) = reverte xs ++ [x]

-- reverte uma lista utilizando guards
reverte' [] = []
reverte' (x:xs)
    | otherwise = (reverte' xs)++ [x]

-- reverte uma lista utilizando list comprehension
reverte'' list = reverte' [x | x <- list]


-- 10) tradicional fold right
{-rev1 [] = []
rev1 (x:xs) = rev1 xs ++ [x]
-}


---------------------------------------------------------------------------------------
-- 11) com acumulador do trabalho anterior fold left
{-
rev lista = rev2 lista []
rev2 [] acc = acc
rev2 (x:xs) acc = rev2 xs (x:acc)
dado n gera a lista de 1 a n ** 
-}


---------------------------------------------------------------------------------------
-- 12) retorna a lista sem o ultimo elemento **
semUlt [] = []
semUlt (x:[]) = []
semUlt (x:xs) = [x] ++ semUlt xs

-- retorna a lista sem o ultimo elemento, utilizando guards
semUlt' [] = []
semUlt' (x:xs)
    | xs == [] = []
    | otherwise = x:semUlt' xs



---------------------------------------------------------------------------------------
-- 13) soma dos elementos nas posições pares da lista ( o primeiro elemento esta na posição 1)
{- fiz utilizando 2 acumuladores, 
i - controla a posicao
acc - acumula a soma dos pares 
-} 

somaPosPar list = somaPosPar' list 1 0
    where somaPosPar' [] i acc = acc
          somaPosPar' (x:xs) i acc
            | i `mod` 2 == 0 = somaPosPar' xs (i + 1) (acc + x)
            | otherwise = somaPosPar' xs (i+1) acc



---------------------------------------------------------------------------------------
-- 14) intercala 2 listas (intercala1 e intercala2)
{-
intercala1 [1,2,3] [4,5,6,7,8]
 ==> [1,4,2,5,3,6]
intercala2 [1,2,3] [4,5,6,7,8]
 ==>  [1,4,2,5,3,6,7,8]
-}                      
{- AINDA NAO FUNCIONA
intercala1 list1 list2 = intercala list1 list2 0
    where   intercala [] [] i = [] 
            intercala (x:xs) (y:ys) i 
                | x == [] = (y) : intercala [] (ys) (i+1)
                | y == [] = (x) : intercala (xs) [] (i+1)
                | i `mod` 2 == 0 = (x):intercala xs (y:ys) (i+1)
                | otherwise = (y):intercala (x:xs) (ys) (i+1)
-}

---------------------------------------------------------------------------------------
-- 15) a lista já esta ordenada? Retorna True ou False
checkOrd (x:[]) = True
checkOrd (x:xs) = if [x] <= xs then checkOrd xs else False


---------------------------------------------------------------------------------------
-- 16) shift para a direita
{-
shiftr [1,2,3,4]
 ==> [4,1,2,3]        
 -}
-- utilizei as funcoes "ultimo" do exercicios 5, e "semUlt" do exercicio 12
shiftr [] = []
shiftr (x:xs) =
    let a = ultimo' (x:xs)
        b = semUlt (x:xs)
    in a : b

---------------------------------------------------------------------------------------
-- 17) shiftr n lista (shift direita n vezes)
-- utilizei a funcao shiftr do exercicio 16

shiftr' n [] = []
shiftr' n (x:xs)
    | (n == 0) = (x:xs)
    | otherwise = shiftr' (n - 1) (shiftr (x:xs))


---------------------------------------------------------------------------------------
-- 18) shift left


---------------------------------------------------------------------------------------
-- 19) shift left n vezes


---------------------------------------------------------------------------------------
-- 20) remove o item da lista (1 vez só)
{-
remove1 4 [2,3,4,5,4,3,2,1]
==> [2,3,5,4,3,2,1]
-}
remove1 item [] = []
remove1 item (x:xs) = if item == x then xs else x : remove1 item xs


---------------------------------------------------------------------------------------
-- 21) remove item da lista (todas as vezes)
{-
removeall 4 [2,3,4,5,4,3,2,1,4,4,3]
==> [2,3,5,3,2,1,3]
-}
removeall item [] = []
removeall item (x:xs) = if item == x then removeall item xs else x : removeall item xs


---------------------------------------------------------------------------------------
-- 22) remove item da lista n (as primeiras n vezes)
{-
removen 4 2 [2,3,4,5,4,3,2,1,4,4,3]
==> [2,3,5,3,2,1,4,4,3]
-}
removen num qtd [] = []
removen num 0 list = list
removen num qtd (x:xs) = if num == x then removen num (qtd-1) xs else x : (removen num qtd xs)


---------------------------------------------------------------------------------------
-- 23) remove item da lista (a ultima vez que ele aparece) **
--removeUlt item pos [] = []


---------------------------------------------------------------------------------------
-- 24) troca velho por novo na lista (1 so vez)
{-
troca1 8 10 [2,4,6,8,11,12]
==> [2,4,6,10,11, 12]
-}
troca1 old new [] = []
troca1 old new (x:xs) = if x == old then new : xs else x : troca1 old new xs


---------------------------------------------------------------------------------------
-- 25) troca velho por novo na lista (todas vezes)
trocaAll old new [] = []
trocaAll old new (x:xs) = if x == old then new : trocaAll old new xs else x : trocaAll old new xs 


---------------------------------------------------------------------------------------
-- 26) troca velho por novo na lista (as primeiras n vezes)
trocaN old new n [] = []
trocaN old new 0 list = list
trocaN old new n (x:xs) = if old == x then new : trocaN old new (n-1) xs else x : trocaN old new n xs

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- ## EXERCICIOS DA AULA 3 e 4
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

-- 1) posicoes - dado um item e uma lista, retorna uma lista com todas as posicoes (primeiro elemento esta na posição 1) do item na lista
--posicoes _ [] = []
posicoes item list = posic item list 1
    where   posic item [] acc = []
            posic item (x:xs) acc 
                | item == x = (acc,x) : posic item xs (acc+1)
                | otherwise = posic item xs (acc+1)
                

-- 2) split - dado um item e uma lista retorna uma lista de listas, todos os elementos da lista antes do item (a primeira vez que ele aparece) e todos depois
{-
split "qwertyuiopoiuyt" 't' 
-- ==> ["qwer", "yuiopoiuyt"]
-}


--texto [] = []
--texto list = list
--
--
--split list item = split' list item 0
--    where   split' [] item acc = []
--            split' (x:xs) item acc
--                | item == x = x : split' xs item 0
--                | otherwise = xs

-- 3) splitall - mesma coisa que o split mas retorna todas as sublistas
--splitall "qwertyuiopoiuytxxt" 't' 
-- ==> ["qwer", "yuiopoiuy", "xx", ""]  ou  ["qwer", "yuiopoiuy", "xx"]
-- drop n lista - a lista sem os n primeiros elementos - essa função já esta implementada no Prelude

-- take n lista - os primeiros n elementos da lista - essa função já esta implementada no Prelude
