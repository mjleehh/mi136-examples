module Initial exposing (initialState, initialEntry)

import State exposing (State, Entry, Tabs(..), Status(..))
import Action exposing (Action)
import Api.Entries exposing (loadEntries)
import Api.Material exposing (updateMaterial)

initialEntry : Entry
initialEntry =
    {
        name = "",
        surname = Nothing,
        company = Nothing,
        email = "",
        phone = Nothing,
        tags = []
    }

initialState : (State, List (Cmd msg))
initialState =
    ({
        ui = {
            activeListItem = Nothing,
            tab = LIST_VIEW,
            search = Nothing,
            newEntry = initialEntry,
            modifyEntry = ("", initialEntry)
        },
        data = {
            status = LOADING,
            entries = []
        }
    }, [updateMaterial, loadEntries])

sampleEntry name surname company phone email tags =
    {
        name = name,
        surname = Just surname,
        company = Just company,
        email = email,
        phone = Just phone,
        tags = tags
    }

sampleList : List Entry
sampleList =
    [
        sampleEntry "Bob" "Rich" "Big Money Corp" "87143981" "bob.rich@bigmoney.com" ["biz", "job", "golf"],
        sampleEntry "Jeff" "Dollar" "World Petroleum Ltd" "239874893" "jeff@wp.com" ["headhunters", "newjob"]
    ]