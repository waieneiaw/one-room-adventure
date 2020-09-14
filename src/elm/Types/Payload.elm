module Types.Payload exposing (..)

import Types.Command
import Types.Direction
import Types.Item


type alias UpdatePlacePayload model =
    { direction : Types.Direction.Direction
    , items : Types.Item.Items
    , model : model
    , command : Types.Command.Command
    }


type alias UpdateDirectionPayload model =
    { items : Types.Item.Items
    , model : model
    , command : Types.Command.Command
    }
