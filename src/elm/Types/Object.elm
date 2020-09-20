module Types.Object exposing (Plain, Status(..), WithKey(..))

import Types.Item


type Status
    = Exist
    | NotExist
    | Broken


type alias State =
    { status : Status
    , feature : Types.Item.Item
    }


type alias Plain =
    State


type WithKey
    = Locked Plain
    | Unlocked Plain
