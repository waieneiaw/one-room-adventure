module Types.Door exposing (Door(..))


type alias State =
    { opened : Bool
    }


type Door
    = Locked
    | Unlocked State
