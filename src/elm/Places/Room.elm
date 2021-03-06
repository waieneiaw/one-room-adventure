module Places.Room exposing (Model, init, update, view)

import Places.Room.East
import Places.Room.North
import Places.Room.South
import Places.Room.West
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Direction exposing (Direction)


type alias Model =
    { north : Places.Room.North.Model
    , east : Places.Room.East.Model
    , west : Places.Room.West.Model
    , south : Places.Room.South.Model
    }


init : Model
init =
    { north = Places.Room.North.init
    , east = Places.Room.East.init
    , west = Places.Room.West.init
    , south = Places.Room.South.init
    }


update :
    Types.Argument.UpdatePlaceArgs Model
    -> ( Model, Types.Command.Result )
update { items, direction, model, command } =
    case direction of
        Types.Direction.North ->
            let
                ( newModel, result ) =
                    Places.Room.North.update
                        { model = model.north
                        , command = command
                        , items = items
                        }
            in
            ( { model | north = newModel }, result )

        Types.Direction.East ->
            let
                ( newModel, result ) =
                    Places.Room.East.update
                        { model = model.east
                        , command = command
                        , items = items
                        }
            in
            ( { model | east = newModel }, result )

        Types.Direction.West ->
            let
                ( newModel, result ) =
                    Places.Room.West.update
                        { model = model.west
                        , command = command
                        , items = items
                        }
            in
            ( { model | west = newModel }, result )

        Types.Direction.South ->
            let
                ( newModel, result ) =
                    Places.Room.South.update
                        { model = model.south
                        , command = command
                        , items = items
                        }
            in
            ( { model | south = newModel }, result )


view : Direction -> Model -> List (Svg msg)
view direction model =
    case direction of
        Types.Direction.North ->
            Places.Room.North.view model.north

        Types.Direction.East ->
            Places.Room.East.view model.east

        Types.Direction.West ->
            Places.Room.West.view model.west

        Types.Direction.South ->
            Places.Room.South.view model.south
