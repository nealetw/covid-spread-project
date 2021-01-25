-- Authors: 
-- Brandon Starcheus
-- Tim Neale
-- Alex Shiveley
-- Daniel Hackney

-- Input a CSV with columns for each health condition.
-- Output a CSV with a susceptibility score for each student.

-- Usage: > ghc susceptibilityScore.hs -package csv
--        > ./susceptibilityScore 1-Perl-Output.csv

import Text.CSV
import System.IO
import System.Environment
main :: IO()
main = do
    args <- getArgs
    f <- Text.CSV.parseCSVFromFile(head args)

    writeNewCSV $ case f of
        Right x -> processRows x


writeNewCSV csv = do
    writeFile "2-Haskell-Output.csv" (printCSV csv)


processRows :: CSV -> [[String]]
processRows [] = []
processRows (x : xs) = (processRow x): (processRows xs)

processRow :: Record -> [String]
processRow x = [ x!!0, x!!1, calculateScore (readStrings [x!!2, x!!4, x!!5, x!!9, x!!10, x!!11, x!!12, x!!13, x!!14, x!!15]), x!!6, x!!7, x!!8 ]

readStrings [] = []
readStrings (x : xs) = (read x): (readStrings xs)

-- Given many different factors, calculate a susceptibility core out of 10
calculateScore :: (RealFrac a, Fractional a, Ord a, Num a, Show a) => [a] -> String
calculateScore x = show ( round ((age (x!!0) + 2 * (isObese (calcBMI (x!!1) (x!!2))) + 2 * x!!3 + 4 * x!!4 + 7 * x!!5 + 10 * x!!6 + 6 * x!!7 + 2 * x!!8 + 2 * x!!9) / 4.5) )
-- Maximum score is 45.  /4.5 to scale out of 10

age x
    | x < 0 = 0
    | x > 80 = 10
    | otherwise = 10 * (x/80)^2 -- Max 10

isObese bmi = if bmi > 30 then 1 else 0

calcBMI weight height = ((703) * weight) / (height * height)