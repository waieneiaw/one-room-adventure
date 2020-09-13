module Places.Room exposing (Model, init, update, view)

import Places.Room.East
import Places.Room.North
import Places.Room.South
import Places.Room.West
import Svg exposing (Svg)
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
    let
        north =
            Places.Room.North.init

        east =
            Places.Room.East.init

        west =
            Places.Room.West.init

        south =
            Places.Room.South.init
    in
    Model
        north
        east
        west
        south


update :
    Types.Direction.Direction
    -> Model
    -> Types.Command.Command
    -> ( Model, Types.Command.Result )
update direction model command =
    case direction of
        Types.Direction.North ->
            let
                ( newModel, result ) =
                    Places.Room.North.update model.north command
            in
            ( { model | north = newModel }, result )

        Types.Direction.East ->
            let
                ( newModel, result ) =
                    Places.Room.East.update model.east command
            in
            ( { model | east = newModel }, result )

        Types.Direction.West ->
            let
                ( newModel, result ) =
                    Places.Room.West.update model.west command
            in
            ( { model | west = newModel }, result )

        Types.Direction.South ->
            let
                ( newModel, result ) =
                    Places.Room.South.update model.south command
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
