module Places.Room.West exposing (Model, init, update, view)

import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { desk : Types.Object.Plain
    , drawer1 : Types.Object.Plain
    , drawer2 : Types.Object.WithKey
    , scissors : Types.Object.Plain
    , paper1 : Types.Object.Plain
    , notebook : Types.Object.Plain
    }


init : Model
init =
    { desk =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "机（DESK）"
            }
        }
    , drawer1 =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "上段の抽斗（DRAWER1）"
            }
        }
    , drawer2 =
        Types.Object.Locked
            { status = Types.Object.Exist
            , feature =
                { type_ = Types.Item.None
                , name = "下段の抽斗（DRAWER2）"
                }
            }
    , scissors =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.Scissors
            , name = "はさみ（SCISSORS）"
            }
        }
    , paper1 =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.PaperOfSafeTips
            , name = "紙1（PAPER1）"
            }
        }
    , notebook =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "ノート（NOTEBOOK）"
            }
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
            message "西を向いています。何もありません。"

        _ ->
            noop


view : Model -> List (Svg msg)
view _ =
    [ Images.Wall.view
    ]
