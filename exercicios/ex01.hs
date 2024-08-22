main :: IO ()
main = putStrLn "Hello, world!"
{-
Exercicios
Fazer os exercícios usando head tail : ++ mod (modulo), let e pattern matching

Alguns são bem dificies de fazer usando apenas os conceitos da aula 1!
-}
--DECLARANDO ALGUMAS LISTAS
li1 = [0,1,2,3,4,5,6,7,8,9]
li2 = reverse li1
li3 = [1,3,0,4,5,14,-25]

-- 1) Tamanho de uma lista
tam list1 = if list1 == []
    then 0
    else (1+ tam(tail list1))


-- 2) Conta quantas vezes o item aparece na lista (0 se nenhuma)
qts item list = if list == []
    then 0
    else (if head list == item then 1 else 0) + qts item (tail list)
            

-- 3) Soma dos elementos de uma lista
soma list = if list == []
    then 0
    else head list + soma (tail list)

-- 4) Soma dos números pares de uma lista ( modulo = mod)
somaPar list = if list == []
    then 0
    else (if mod (head list) 2 == 0 then head list else 0) + somaPar (tail list)

-- 5) Retorna o ultimo elemento de uma lista
ultimo [] = 0
ultimo (x:xs) = if xs == [] then x else ultimo xs

-- 6) Existe item x na lista (True ou False)
existe x_ [] = False
existe x_ (x:xs) = if x_ == x then True else existe x_ xs

-- 7) dado n gera a lista de n a 1
geraList 0 = []
geraList x = (x):[] ++ geraList (x-1)

{-
range_rev n = if n==1
        then [1]
        else n:range_rev (n-1)
ou

range_rev' 1 = []
range_rev' n = n: range_rev (n-1)
-}

-- 8) posição do item na lista (0 se não esta lá, 1 se é o primeiro) **
posItem item [] = 0
posItem item (x:[]) = if item == x then 1 else 0
posItem item (x:xs) = if item == x then 1  else 0 + pos item xs


-- 9) reverte uma lista
reverte [] = []
reverte (x:xs) = reverte xs ++ [x]

-- 10) tradicional fold right
{-rev1 [] = []
rev1 (x:xs) = rev1 xs ++ [x]
-}

-- 11) com acumulador do trabalho anterior fold left
{-
rev lista = rev2 lista []
rev2 [] acc = acc
rev2 (x:xs) acc = rev2 xs (x:acc)
dado n gera a lista de 1 a n ** 
-}


-- 12) retorna a lista sem o ultimo elemento **
semUlt [] = []
semUlt (x:[]) = []
semUlt (x:xs) = [x] ++ semUlt xs

-- 13) soma dos elementos nas posições pares da lista ( o primeiro elemento esta na posição 1)



-- 14) intercala 2 listas (intercala1 e intercala2)
{-
intercala1 [1,2,3] [4,5,6,7,8]
 ==> [1,4,2,5,3,6]
intercala2 [1,2,3] [4,5,6,7,8]
 ==>  [1,4,2,5,3,6,7,8]
-}                      

-- 15) a lista já esta ordenada? Retorna True ou False
checkOrd (x:[]) = True
checkOrd (x:xs) = if [x] <= xs then checkOrd xs else False

-- 16) shift para a direita
{-
shiftr [1,2,3,4]
 ==> [4,1,2,3]

 1 2 3
   1   2 3
       2    3
            3 
            
 -}
shiftr [] = []
shiftr (x:[]) = [x]
shiftr (x:xs) = (shiftr xs)

-- 17) shiftr n lista (shift direita n vezes)

-- 18) shift left

-- 19) shift left n vezes

-- 20) remove o item da lista (1 vez só)
{-
remove1 4 [2,3,4,5,4,3,2,1]
==> [2,3,5,4,3,2,1]
-}
remove1 item [] = []
remove1 item (x:xs) = if item == x then xs else x : remove1 item xs

-- 21) remove item da lista (todas as vezes)
{-
removeall 4 [2,3,4,5,4,3,2,1,4,4,3]
==> [2,3,5,3,2,1,3]
-}
removeall item [] = []
removeall item (x:xs) = if item == x then removeall item xs else x : removeall item xs

-- 22) remove item da lista n (as primeiras n vezes)
{-
removen 4 2 [2,3,4,5,4,3,2,1,4,4,3]
==> [2,3,5,3,2,1,4,4,3]
-}
removen num qtd [] = []
removen num 0 list = list
removen num qtd (x:xs) = if num == x then removen num (qtd-1) xs else x : (removen num qtd xs)


-- 23) remove item da lista (a ultima vez que ele aparece) **
--removeUlt item pos [] = []

-- 24) troca velho por novo na lista (1 so vez)
{-
troca1 8 10 [2,4,6,8,11,12]
==> [2,4,6,10,11, 12]
-}
troca1 old new [] = []
troca1 old new (x:xs) = if x == old then new : xs else x : troca1 old new xs

-- 25) troca velho por novo na lista (todas vezes)
trocaAll old new [] = []
trocaAll old new (x:xs) = if x == old then new : trocaAll old new xs else x : trocaAll old new xs 


-- 26) troca velho por novo na lista (as primeiras n vezes)
trocaN old new n [] = []
trocaN old new 0 list = list
trocaN old new n (x:xs) = if old == x then new : trocaN old new (n-1) xs else x : trocaN old new n xs