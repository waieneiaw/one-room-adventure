module Types.Argument exposing (..)

import Types.Command
import Types.Direction
import Types.Item


type alias UpdatePlaceArgs model =
    { direction : Types.Direction.Direction
    , items : Types.Item.Items
    , model : model
    , command : Types.Command.Command
    }


type alias UpdateDirectionArgs model =
    { items : Types.Item.Items
    , model : model
    , command : Types.Command.Command
    }
