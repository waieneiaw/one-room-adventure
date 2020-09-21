module Types.Command.Verb exposing (Verb(..), fromString)


type Verb
    = NoOp -- 何もしない
    | Open -- 開ける
    | Close -- 閉める
    | Take -- 取る
    | Input -- 入力する
    | Put -- 置く
    | Throw -- 捨てる
    | Look -- 見る
    | Use -- 使う
    | Read -- 読む
    | Unlock -- 解錠する


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
        "close" ->
            Close

        "get" ->
            Take

        "input" ->
            Input

        "look" ->
            Look

        "open" ->
            Open

        "put" ->
            Put

        "read" ->
            Read

        "take" ->
            Take

        "throw" ->
            Throw

        "unlock" ->
            Use

        "use" ->
            Use

        _ ->
            NoOp
