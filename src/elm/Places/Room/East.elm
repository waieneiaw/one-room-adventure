module Places.Room.East exposing (Model, init, update, view)

import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { rack : Types.Object.Plain
    , safe : Types.Object.WithKey
    , box : Types.Object.WithKey
    , machine : Types.Object.Plain
    }


init : Model
init =
    { rack =
        Types.Object.Exist
            { type_ = Types.Item.None
            , name = "机（DESK）"
            }
    , safe =
        Types.Object.Locked
            (Types.Object.Exist
                { type_ = Types.Item.None
                , name = "金庫（SAFE）"
                }
            )
    , box =
        Types.Object.Locked
            (Types.Object.Exist
                { type_ = Types.Item.None
                , name = "鍵のついた箱（BOX）"
                }
            )
    , machine =
        Types.Object.Exist
            { type_ = Types.Item.None
            , name = "謎の機械（MACHINE）"
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
            message "東を向いています。何もありません。"

        _ ->
            noop


view : Model -> List (Svg msg)
view _ =
    [ Images.Wall.view
    ]
