module Types.Command exposing
    ( Command
    , Result
    , noResults
    , parse
    , resultWithItem
    , resultWithoutItem
    )

import List.Extra as List
import Regex
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Command =
    { verb : Types.Command.Verb.Verb
    , noun : Types.Command.Noun.Noun
    }


space : Regex.Regex
space =
    Maybe.withDefault Regex.never <|
        Regex.fromString " *  *"


splitCommand : String -> List String
splitCommand command =
    Regex.split space command


{-| テキストボックスに入力されたコマンドを動詞＋名詞に分割する。
-}
parse : String -> Command
parse rawCommand =
    let
        splittedCommand =
            splitCommand rawCommand
                |> List.take 2

        verbStr =
            List.head splittedCommand

        nounStr =
            if List.length splittedCommand == 2 then
                List.last splittedCommand

            else
                -- コマンドが動詞のみの場合
                Nothing

        command =
            { noun = Types.Command.Noun.fromString nounStr
            , verb = Types.Command.Verb.fromString verbStr
            }
    in
    command


type alias Result =
    { message : String
    , item : Maybe Types.Item.Item
    }


{-| コマンド実行の結果、何も起こらない場合。
-}
noResults : Result
noResults =
    { message = "NG!", item = Nothing }


{-| コマンド実行の結果、messageを返す場合。
-}
resultWithoutItem : String -> Result
resultWithoutItem text =
    { message = text, item = Nothing }


{-| コマンド実行の結果、messageとitemを返す場合。
-}
resultWithItem : Types.Object.Plain -> Result
resultWithItem item =
    { message = "OK!"
    , item =
        Just item.feature
    }
