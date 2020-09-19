module Types.Object exposing (Plain(..), WithKey(..))

import Types.Item


type Plain
    = Exist Types.Item.Item
    | NotExist


type WithKey
    = Locked Plain
    | Unlocked Plain
