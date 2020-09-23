module Types.Object exposing (Openable(..), Plain, Status(..), getOpenableState)

import Types.Item


type Status
    = Exist
    | Lost
    | Broken


type alias State =
    { status : Status
    , feature : Types.Item.Item
    }


type alias Plain =
    State


type Openable
    = Locked WithKeyState
    | Closed WithKeyState
    | Opened WithKeyState


type alias WithKeyState =
    { feature : Types.Item.Item
    }


getOpenableState : Openable -> WithKeyState
getOpenableState state =
    case state of
        Locked result ->
            result

        Closed result ->
            result

        Opened result ->
            result
