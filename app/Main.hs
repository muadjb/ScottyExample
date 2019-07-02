{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import GHC.Generics

import Web.Scotty
import Data.Time (getCurrentTime)
import Data.Aeson
import Data.Text
import qualified Data.ByteString.Lazy as B

data Person = Person {
  firstName  :: !Text
  , lastName   :: !Text
  , age        :: Int
  , likesPizza :: Bool
  } deriving (Show,Generic)

instance ToJSON Person 
instance FromJSON Person

jsonFile :: FilePath
jsonFile = "src/pizza.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile

-- jb = encode (Person {name = "Joe", age = 12}) "{\"name\":\"Joe\",\"age\":12}"

greet name = "Hello " ++ name ++ "!"

printTime = do
  time <- getCurrentTime
  putStrLn (show time)

-- main = do
--   printTime
--   putStrLn (greet "World")

-- main = scotty 3000 $
--   get "/:word" $ do
--     beam <- param "word"
--     html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]

-- main = scotty 3000 $ do
--   get "/" $ do
--     html "Hello World!"

-- main :: IO ()
-- main = do
--   port <- fromMaybe 3000
--         . join
--         . fmap readMaybe <$> lookupEnv "PORT"
--   scotty port $ do
--          middleware $ staticPolicy (noDots >-> addBase "static/images") -- for favicon.ico
--          middleware logStdoutDev
--          home >> login >> post

main :: IO ()
main = do
  d <- (eitherDecode <$> getJSON) :: IO (Either String [Person])
  -- If d is Left, the JSON was malformed.
  -- In that case, we report the error.
  -- Otherwise, we perform the operation of
  -- our choice. In this case, just print it.
  case d of
    Left err -> putStrLn err
    Right ps -> print ps