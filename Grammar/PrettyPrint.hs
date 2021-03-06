module Grammar.PrettyPrint where

import Grammar.Grammar
import Grammar.Board
import Cards.Cards

prettyPrintBoard :: Board -> String
prettyPrintBoard board =

  "Current weather: " ++ prettyPrintWeather (weather board) ++
  "Board: \n" ++ "Player A\nScore: " ++
  (show playerAScore) ++ "\n" ++ playerACards ++
  "\nPlayer B\nScore: " ++ (show playerBScore) ++
    "\n" ++ playerBCards ++
  "-------------"++ curPlayer ++  "------------- \n" ++
  "\n Current Hand:\n" ++ (prettyPrintCards currentHand)
  where
    playerACards = prettyPrintCards (cardsOnBoard (a board))
    playerBCards = prettyPrintCards (cardsOnBoard (b board))
    playerAScore = fst (roundScore board)
    playerBScore = snd (roundScore board)
    currentHand  = if (isATurn board) then (cardsInHand (a board))
                                      else (cardsInHand (b board))
    curPlayer    = if (isATurn board) then ("Player A's turn")
                                      else ("Player B's turn")

prettyPrintStatus :: Board -> String
prettyPrintStatus board =
     "\nPlayer A's Lives: " ++ (show livesA)
  ++ " Player B's Lives: " ++ (show livesB)
  ++ "\n"
  where
    z = zip (lives $ a board) (lives $ b board)
    ties = foldl (\acc x -> if x == (0, 0) then acc+1 else acc) 0 z
    wonByA = foldl (\acc x -> if x == (1, 0) then acc+1 else acc) 0 z
    wonByB = foldl (\acc x -> if x == (0, 1) then acc+1 else acc) 0 z
    livesA = 2 - ties - wonByB
    livesB = 2 - ties - wonByA

prettyPrintCard :: Card -> String
prettyPrintCard (CWeather n row)   = n ++ " "
prettyPrintCard (CSpecial n _ a)  = "(" ++ n ++ " " ++ (show a) ++ ") "
prettyPrintCard (CUnit n _ a dmg) = "(" ++ n ++ " " ++ (show a) ++ " (D: " ++ (show dmg) ++ ")) "
prettyPrintCard (CLeader l)        = prettyPrintLeader l
prettyPrintCard (CPass)            = "Passed"

prettyPrintCards :: [Card] -> String
prettyPrintCards [] = ""
prettyPrintCards cards = concat $ zipWith prettyPrintRow [0..3] rows
  where
    zeroes = filter (cardInRow 0) cards
    ones   = filter (cardInRow 1) cards
    twos   = filter (cardInRow 2) cards
    threes = filter (cardInRow 3) cards
    rows   = [zeroes, ones, twos, threes]

prettyPrintWeather :: Weather -> String
prettyPrintWeather w =
  case w of
    (False, False, False) -> "No weather\n"
    (True, False, False)  -> "Biting Frost (1)\n"
    (False, True, False)  -> "Impenetrable Fog (2)\n"
    (False, False, True)  -> "Torrential Rain (3)\n"
    (True, True, False)   -> "Biting Frost and Impenetrable Fog (1, 2)\n"
    (False, True, True)   -> "Impenetrable Fog and Torrential Rain (2, 3)\n"
    (True, False, True)   -> "Biting Frost and Torrential Rain (1, 3)\n"
    (True, True, True)    -> "Biting Frost, Impenetrable Fog and Torrential Rain (1,2,3)\n"

prettyPrintRow :: Row -> [Card] -> String
prettyPrintRow r c = show r ++ ": " ++ (concat (map prettyPrintCard c)) ++ "\n"

prettyPrintLeader  :: Leader -> String
prettyPrintLeader SteelForged      = "SteelForged"
prettyPrintLeader Siegemaster      = "Siegemaster"
prettyPrintLeader NorthCommander   = "North Commander"
prettyPrintLeader KingTemeria      = "King Temeria"
prettyPrintLeader Relentless       = "Relentless"
prettyPrintLeader WhiteFlame       = "White Flame"
prettyPrintLeader EmperorNilfgaard = "Emperor Nilfgaard"
prettyPrintLeader ImperialMajesty  = "Imperial Majesty"
prettyPrintLeader Canceled         = "Your leader's ability has been canceled."

prettyPrintCountry :: Country -> String
prettyPrintCountry Northern  = "Northern"
prettyPrintCountry Nilfgaard = "Nilfgaard"
