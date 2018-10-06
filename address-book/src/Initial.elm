module Initial exposing (initialState, initialEntry)

import State exposing (State, Entry, Tabs(..))
import Action exposing (Action, CmdList)
import Ports exposing (updateMaterial, loadData)

initialEntry : Entry
initialEntry =
    {
        id = Nothing,
        name = "",
        surname = Nothing,
        company = Nothing,
        email = "",
        phone = Nothing,
        tags = []
    }

initialState : (State, CmdList)
initialState =
    ({
        ui = {
            tab = LIST_VIEW,
            search = Nothing,
            newEntry = initialEntry
        },
        data = {
            entries = sampleList
        }
    }, [updateMaterial, loadData])

sampleEntry name surname company phone email tags =
    {
        id = Nothing,
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