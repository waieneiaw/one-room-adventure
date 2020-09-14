module Types.Command.Verb exposing (Verb(..), fromString)


type Verb
    = NoOp -- 何もしない
    | Open -- 開ける
    | Close -- 閉める
    | Take -- 取る
    | Put -- 置く
    | Throw -- 捨てる
    | Look -- 見る
    | Use -- 使う
    | Read -- 読む


fromString : Maybe String -> Verb
fromString value =
    let
        verb =
            value
                |> Maybe.map (\value_ -> value_)
                |> Maybe.withDefault ""
                |> String.toLower
    in
    case verb of
        "open" ->
            Open

        "close" ->
            Close

        "take" ->
            Take

        "get" ->
            Take

        "read" ->
            Read

        "put" ->
            Put

        "throw" ->
            Throw

        "look" ->
            Look

        "use" ->
            Use

        _ ->
            NoOp
