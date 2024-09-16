{-
Exercícios
- reimplemente os exercicios da aula 1 e 2 usando as funcoes de alto nivel (map, filter, fold)

- uma matrix é implementada como uma lista de linhas (que são listas)

   1   2   3
   4   5   6
   7   8   9
   0   0   -1

   [[1,2,3],[4,5,6],[7,8,9],[0,0,-1]]

- implemente transposta que transpoe uma matrix

- implemente matmul que dado duas matrizes de formatos apropriados multiplica-as.

-}
-- ## EXERCICIOS DA AULA 1 e 2 (refazendo os exercicios)

-- 1) Tamanho de uma lista
tam list = foldr (\a b -> b + 1) 0 list 
-- nesse caso, eh possivel omitir o `list` e o `a`,  mas precisamos definir a assinatura da funcao
tam' :: [a] -> Int
tam' = foldr (\_ b -> b + 1) 0


---------------------------------------------------------------------------------------
-- 2) Conta quantas vezes o item aparece na lista (0 se nenhuma)
qtsA item = foldr (\x acc -> if item == x then acc + 1 else acc) 0


---------------------------------------------------------------------------------------
-- 3) Soma dos elementos de uma lista
soma :: Num a => [a] -> a
soma list = foldr (+) 0 list


---------------------------------------------------------------------------------------
-- 4) Soma dos números pares de uma lista ( modulo = mod)
somaPar :: [Int] -> Int
somaPar = foldr (\x acc -> if x `mod` 2 == 0 then acc + x else acc) 0

-- na assinatura usamos o Integral, porque em filter usamos o mod, e eh em Integral que temos essa restricao.
somaPar' :: Integral a => [a] -> a
somaPar' list = soma (filter (\x -> x `mod` 2 == 0) list )


---------------------------------------------------------------------------------------
-- 5) Retorna o ultimo elemento de uma lista
{-
Função	    Valor Inicial   	        Lida com lista vazia?	    Ordem de processamento
--------+-----------------------------+----------------------------+------------------------
foldr       Sim (valor explícito)	            Sim	                    Direita para esquerda
foldr1	    Não (usa o último da lista)	        Não	                    Direita para esquerda
foldl	    Sim (valor explícito)	            Sim	                    Esquerda para direita
foldl1	    Não (usa o primeiro da lista)	    Não	                    Esquerda para direita
-}
-- Essa implementacao nao cobre o caso [](lista vazia)
ultimo :: [Int] -> Int
ultimo = foldr1 (\x acc -> acc) 

-- Essa implementacao cobre o caso [](lista vazia)
ultimo' :: [Int] -> Maybe Int
ultimo' [] = Nothing
ultimo' xs = Just (foldr1 (\_ acc -> acc) xs)



---------------------------------------------------------------------------------------
-- 6) Existe item x na lista (True ou False)
existe item list = not $ null $ filter (== item) list  
-- existe item list = not ( null ( filter (== item) list ) )

---------------------------------------------------------------------------------------
-- 7) dado n gera a lista de n a 1



---------------------------------------------------------------------------------------
-- 8) posição do item na lista (0 se não esta lá, 1 se é o primeiro) **
pos item list = foldr (\x acc -> if x == item then 1 else 
                                                        (if acc == 0 then 0 else acc + 1) ) 0 list


---------------------------------------------------------------------------------------
-- 9) reverte uma lista
reverte list = foldr (\x acc -> acc ++ [x]) [] list
-- reverte [1,2,3]
-- 1 f (2 f (3 : []))
-- 1 f (2 f ([3]))
-- 1 f [3,2]
-- [3,2,1]

---------------------------------------------------------------------------------------
-- 11) com acumulador do trabalho anterior fold left
reverte' list = foldl (\x acc -> (acc:x)) [] list

---------------------------------------------------------------------------------------
-- 12) retorna a lista sem o ultimo elemento **
semUlt list = let u = ultimo list 
              in filter (/= u) list

---------------------------------------------------------------------------------------
-- 13) soma dos elementos nas posições pares da lista ( o primeiro elemento esta na posição 1)
somaPosPar list =  soma ( map snd ( filter (\(x,y) -> x `mod` 2 == 0 ) (zip [1..] list) ) )

-- nesse caso foi mais facil fazer por partes


---------------------------------------------------------------------------------------
-- 14) intercala 2 listas (intercala1 e intercala2)
{-
intercala1 [1,2,3] [4,5,6,7,8]
 ==> [1,4,2,5,3,6]
-}                 
-- essa primeira versao intercala enquanto as duas listas tem elementos, se uma delas 
-- acabar primeiro, interrompe a intercalacao retornando vazio.




{-
intercala2 [1,2,3] [4,5,6,7,8]
 ==>  [1,4,2,5,3,6,7,8]
-} 


---------------------------------------------------------------------------------------
-- 15) a lista já esta ordenada? Retorna True ou False
ordenada :: (Ord a) => [a] -> Bool
ordenada [] = True  
ordenada [x] = True  
ordenada xs = foldr (\(a,b) acc -> acc && a <= b)  True (zip xs (tail xs))

---------------------------------------------------------------------------------------
-- 16) shift para a direita
shiftr list =   let u = ultimo list
                in u: semUlt list
---------------------------------------------------------------------------------------
-- 17) shiftr n lista (shift direita n vezes)
--shiftrn n list = map shiftr list
---------------------------------------------------------------------------------------
-- 18) shift left

---------------------------------------------------------------------------------------
-- 19) shift left n vezes

---------------------------------------------------------------------------------------
-- 20) remove o item da lista (1 vez só)

---------------------------------------------------------------------------------------
-- 21) remove item da lista (todas as vezes)

---------------------------------------------------------------------------------------
-- 22) remove item da lista n (as primeiras n vezes)

---------------------------------------------------------------------------------------
-- 23) remove item da lista (a ultima vez que ele aparece) **
        
---------------------------------------------------------------------------------------
-- 24) troca velho por novo na lista (1 so vez)

---------------------------------------------------------------------------------------
-- 25) troca velho por novo na lista (todas vezes)

---------------------------------------------------------------------------------------
-- 26) troca velho por novo na lista (as primeiras n vezes)

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- ## EXERCICIOS DA AULA 3 e 4
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

-- 1) posicoes - dado um item e uma lista, retorna uma lista com todas as posicoes (primeiro elemento esta na posição 1) do item na lista



-- 2) split - dado um item e uma lista retorna uma lista de listas, todos os elementos da lista antes do item (a primeira vez que ele aparece) e todos depois
{-
split "qwertyuiopoiuyt" 't' 
-- ==> ["qwer", "yuiopoiuyt"]
-}

-- 3) splitall - mesma coisa que o split mas retorna todas as sublistas
{-
splitall "qwertyuiopoiuytxxt" 't' 
==> ["qwer", "yuiopoiuy", "xx", ""]  ou  ["qwer", "yuiopoiuy", "xx"]
-}


-- 4) drop n lista - a lista sem os n primeiros elementos - essa função já esta implementada no Prelude

-- 5) take n lista - os primeiros n elementos da lista - essa função já esta implementada no Prelude

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- ## EXERCICIOS DA AULA 6
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

{-
- uma matrix é implementada como uma lista de linhas (que são listas)

   1   2   3
   4   5   6
   7   8   9
   0   0   -1

   [[1,2,3],[4,5,6],[7,8,9],[0,0,-1]]

   1  4  7  0
   2  5  8  0
   3  6  9  -1
[[1,4,7,0],[2,5,8,0],[3,6,9,-1]]

- implemente transposta que transpoe uma matrix
-}
transposta :: [[a]] -> [[a]]
transposta [] = []
transposta ([]:_) = []
transposta list = map head list : transposta (map tail list)

-- implemente matmul que dado duas matrizes de formatos apropriados multiplica-as.
{-
[[1,2][2,4]] [[5,6],[7,8]]

|1 2| * | 5 6 | = |  |
|3 4|   | 7 8 |   |  |

se eu pegar a primeira e multiplicar pela transposta da segunda
|1 2| * | 5 7 | = | (1*5 + 2*7) (1*6 + 2*8) | = | 19  22 |
|3 4|   | 6 8 |   | (3*5 + 4*7) (3*6 + 4*8) |   | 43  66 |

-}
{- Ao inves de fazer o convencional linha * coluna, para multiplicar 2 matrizes, utilizei 
a transposta da segunda matriz, fazendo assim uma multplicacao m1 * m2transp, eh o mesmo que fazer
linha da matriz * cada uma das linhas da matriz transposta.

E para fazer a multiplicacao elemento a elemento, utilizo o zipWith

FAZ CALCULOS ERRADOS QUANDO AS MATRIZES NAO SAO COMPATIVEIS
-}
multMat [] _ = []
multMat _ [] = []
multMat m1 m2 = multMat' m1 (transposta m2)
    where   multMat' [] _ = [] 
            multMat' (x:xs) m2' =  [soma $ zipWith (*) x  lin | lin <- m2' ] : multMat' xs m2'
