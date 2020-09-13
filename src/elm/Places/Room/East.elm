module Places.Room.East exposing (Model, init, update, view)

import Images.Wall
import Svg exposing (Svg)
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { desk : Types.Object.Object
    }


init : Model
init =
    let
        desk =
            Types.Object.Exist
                { type_ = Types.Item.None
                , name = "机（DESK）"
                , weight = 5
                }
    in
    Model
        desk


noResults : Model -> ( Model, Types.Command.Result )
noResults model =
    ( model, Types.Command.noResults )


update : Model -> Types.Command.Command -> ( Model, Types.Command.Result )
update model { verb, noun } =
    case verb of
        Types.Command.Verb.Look ->
            case noun of
                Types.Command.Noun.None ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "東を向いているようです。何もありません。"
                    )

                _ ->
                    noResults model

        _ ->
            noResults model


view : Model -> List (Svg msg)
view _ =
    [ Images.Wall.view
    ]
