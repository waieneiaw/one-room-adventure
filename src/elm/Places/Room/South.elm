module Places.Room.South exposing (Model, init, update, view)

import Images.Key
import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { key : Types.Object.Plain
    , sofa : Types.Object.Plain
    , cushion : Types.Object.Plain
    , bronzeKey : Types.Object.Plain
    }


init : Model
init =
    { sofa =
        Types.Object.Exist
            { type_ = Types.Item.None
            , name = "ソファ（SOFA）"
            }
    , cushion =
        Types.Object.Exist
            { type_ = Types.Item.None
            , name = "クッション（CUSHION）"
            }
    , bronzeKey =
        Types.Object.Exist
            { type_ = Types.Item.BronzeKey
            , name = "銅色の鍵（BRONZE KEY）"
            }
    , key =
        Types.Object.Exist
            { type_ = Types.Item.Key
            , name = "鍵（KEY）"
            }
    }


update :
    Types.Argument.UpdateDirectionArgs Model
    -> ( Model, Types.Command.Result )
update { model, command } =
    let
        message : String -> ( Model, Types.Command.Result )
        message text =
            ( model
            , Types.Command.resultWithoutItem text
            )

        noop =
            ( model, Types.Command.noResults )
    in
    case ( command.noun, command.verb ) of
        ------------
        -- ONLY VERB
        ------------
        ( Types.Command.Noun.None, Types.Command.Verb.Look ) ->
            case model.key of
                Types.Object.Exist item ->
                    message (item.name ++ "が壁にかかっています。")

                _ ->
                    message "南を向いています。何もありません。"

        ------------
        -- Key
        ------------
        ( Types.Command.Noun.Key, Types.Command.Verb.Look ) ->
            case model.key of
                Types.Object.Exist _ ->
                    message "おそらくドアの鍵です。"

                _ ->
                    noop

        ( Types.Command.Noun.Key, Types.Command.Verb.Take ) ->
            case model.key of
                Types.Object.Exist item ->
                    ( { model | key = Types.Object.NotExist }
                    , Types.Command.resultWithItem item
                    )

                _ ->
                    noop

        _ ->
            noop


view : Model -> List (Svg msg)
view model =
    [ Images.Wall.view
    , Images.Key.view model.key { x = 200, y = 230 }
    ]
