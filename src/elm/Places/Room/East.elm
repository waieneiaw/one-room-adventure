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
