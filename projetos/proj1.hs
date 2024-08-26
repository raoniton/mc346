{-
###############################################################################
#                 MC346 - PARADIGMAS DE PROGRAMACAO - 2S_2024                 #
#                 PROFo:  JACQUES WAINER                                      #
#                 NOME:   RAONITON ADRIANO DA SILVA                           #
#                 RA:     186291                                              #
###############################################################################

1 - Implemente a função trocatodos que recebe o valor velho e o valor novo e uma lista e retorna a lista com todas 
as instancias de velho na lista trocada por novo.

trocatodos 4 10 [1,2,3,4,5,4,6,7,4] 
==> [1, 2, 3, 10, 5, 10, 6, 7, 10]

trocatodos 4 10 [1,2,3,5,6,7]
==> [1,2,3,5,6,7]
-}
trocatodos velho novo [] = []
trocatodos velho novo (x:xs) = if x == velho then novo : trocatodos velho novo xs else x : trocatodos velho novo xs

--versao com guards
trocatodos' velho novo [] = []
trocatodos' velho novo (x:xs)
    | x == velho = novo : trocatodos' velho novo xs
    | otherwise = x : trocatodos' velho novo xs

{-
2 - Implemente a função cumsum que dado uma lista de números retorna a lista com a soma cumulativa desses números. 
(na lista retornarda, a posição i contem a soma dos elementos da lista original até a posição)

cumsum [4]
==> [4]

cumsum [5,10,2,3]
==> [5,15,17,20]
-}

cumsum [] = 0:[]
cumsum list = cumsum' 0 list
    where cumsum' acum [] = [acum]
          cumsum' acum (x:[]) = (acum + x):[]
          cumsum' acum (x:xs) = (acum + x): cumsum' (acum + x) xs

--versao com guards
cumsum2 [] = 0:[]
cumsum2 list = cumsum2' 0 list
    where cumsum2' acum (x:xs)
            | xs == [] = (acum + x): []
            | otherwise = (acum + x): cumsum2' (acum + x) xs

{-
Detalhes
As duas funções devem estar num mesmo arquivo submetido tarefa1.hs

Eu nao vou rodar o arquivo em batch assim não se preocupe com as mensagens de erro sobre a função main

Para as 2 funções, voce pode definir funções auxiliares (fora do corpo) ou funções locais mas as funções trocatodos 
recebe 2 valores e uma lista apenas, e a cumsum 1 lista apenas, respectivamente.

As implementações não podem usar funções pre-definidas do Haskell, com a excessão dos operadores matemáticos e as 
funções head e tail. Se vc precisa de alguma função, precisa implementa-la

haverá uma pequena perda na nota se as funções não usam o mecanismo de regras e pattern matching. 
Nao é necessario usar guards, mas pense em usa-los se for o caso.
-}