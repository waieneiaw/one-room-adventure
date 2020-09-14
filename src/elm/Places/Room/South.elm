module Places.Room.South exposing (Model, init, update, view)

import Images.Key
import Images.Wall
import Svg exposing (Svg)
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object
import Types.Payload


type alias Model =
    { key : Types.Object.Object
    }


init : Model
init =
    let
        key =
            Types.Object.Exist
                { type_ = Types.Item.Key
                , name = "鍵（KEY）"
                , weight = 1
                }
    in
    Model key


noResults : Model -> ( Model, Types.Command.Result )
noResults model =
    ( model, Types.Command.noResults )


update :
    Types.Payload.UpdateDirectionPayload Model
    -> ( Model, Types.Command.Result )
update { model, command } =
    case ( command.verb, command.noun ) of
        ( Types.Command.Verb.Look, Types.Command.Noun.None ) ->
            case model.key of
                Types.Object.Exist _ ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "鍵(KEY)が壁にかかっています。"
                    )

                _ ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "南を向いています。何もありません。"
                    )

        ( Types.Command.Verb.Look, Types.Command.Noun.Key ) ->
            case model.key of
                Types.Object.Exist _ ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "おそらくドアの鍵です。"
                    )

                _ ->
                    noResults model

        ( Types.Command.Verb.Take, Types.Command.Noun.Key ) ->
            case model.key of
                Types.Object.Exist item ->
                    ( { model | key = Types.Object.NotExist }
                    , Types.Command.resultWithItem
                        "鍵を取りました。"
                        item
                    )

                _ ->
                    noResults model

        _ ->
            noResults model


view : Model -> List (Svg msg)
view model =
    [ Images.Wall.view
    , Images.Key.view model.key { x = 200, y = 230 }
    ]
