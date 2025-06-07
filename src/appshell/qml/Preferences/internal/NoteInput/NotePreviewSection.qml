/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-Studio-CLA-applies
 *
 * MuseScore Studio
 * Music Composition & Notation
 *
 * Copyright (C) 2025 MuseScore Limited
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.15

import Muse.Ui 1.0
import Muse.UiComponents 1.0

import "../../internal"

BaseSection {
    id: root

    property alias playNotesWhenEditing: playNotesToggle.checked
    property alias playChordWhenEditing: playChordBox.checked
    property alias playChordSymbolWhenEditing: playChordSymbolBox.checked
    property alias playPreviewNotesInInputByDuration: playPreviewNotesInInputByDurationBox.checked
    property alias notePlayDurationMilliseconds: notePlayDurationControl.currentValue
    property alias notePreviewVolume: previewVolumeControl.currentValue

    property alias playNotesOnMidiInput: playNotesOnMidiInputBox.checked
    property alias playNotesOnMidiInputBoxEnabled: playNotesOnMidiInputBox.enabled

    function dynamicName(volume) {
        const levels = [0, 7.5, 12.5, 17.5, 22.5, 27.5, 32.5, 37.5, 42.5,
                        47.5, 50, 52.5, 57.5, 62.5, 67.5, 72.5,
                        77.5, 82.5, 87.5, 92.5, 100]
        const names = ["ppppppppp", "pppppppp", "ppppppp", "pppppp", "ppppp",
                       "pppp", "ppp", "pp", "p", "mp", "natural",
                       "mf", "f", "ff", "fff", "ffff", "fffff",
                       "ffffff", "fffffff", "ffffffff", "fffffffff"]

        var idx = 0
        var minDiff = Math.abs(volume - levels[0])
        for (var i = 1; i < levels.length; ++i) {
            var diff = Math.abs(volume - levels[i])
            if (diff < minDiff) {
                minDiff = diff
                idx = i
            }
        }
        return names[idx]
    }

    signal playNotesWhenEditingChangeRequested(bool play)
    signal playChordWhenEditingChangeRequested(bool play)
    signal playChordSymbolWhenEditingChangeRequested(bool play)
    signal playPreviewNotesInInputByDurationChangeRequested(bool play)
    signal notePlayDurationChangeRequested(int duration)
    signal notePreviewVolumeChangeRequested(int volume)

    signal playNotesOnMidiInputChangeRequested(bool play)

    title: qsTrc("appshell/preferences", "Note preview")

    Row {
        width: parent.width
        height: playNotesToggle.height

        spacing: 6

        ToggleButton {
            id: playNotesToggle

            navigation.name: "PlayNotesToggle"
            navigation.panel: root.navigation
            navigation.row: 0

            navigation.accessible.name: playNotesBoxLabel.text

            onToggled: {
                root.playNotesWhenEditingChangeRequested(!checked)
            }
        }

        StyledTextLabel {
            id: playNotesBoxLabel

            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.Wrap

            text: qsTrc("appshell/preferences", "Hear playback when adding, editing, and selecting notes")
        }
    }

    IncrementalPropertyControlWithTitle {
        id: notePlayDurationControl

        title: qsTrc("appshell/preferences", "Playback duration:")

        enabled: root.playNotesWhenEditing

        columnWidth: root.columnWidth
        spacing: root.columnSpacing

        //: Abbreviation of "milliseconds"
        measureUnitsSymbol: qsTrc("global", "ms")

        navigation.name: "NotePlayDurationControl"
        navigation.panel: root.navigation
        navigation.row: 1

        onValueEdited: function(newValue) {
            root.notePlayDurationChangeRequested(newValue)
        }
    }

    IncrementalPropertyControlWithTitle {
        id: previewVolumeControl

        title: qsTrc("appshell/preferences", "Preview volume:")

        enabled: root.playNotesWhenEditing

        columnWidth: root.columnWidth
        spacing: root.columnSpacing

        measureUnitsSymbol: "%"

        navigation.name: "NotePreviewVolumeControl"
        navigation.panel: root.navigation
        navigation.row: 2

        minValue: 0
        maxValue: 100

        valueDescriptionProvider: root.dynamicName

        onValueEdited: function(newValue) {
            root.notePreviewVolumeChangeRequested(newValue)
        }
    }

    CheckBox {
        id: playChordBox
        width: parent.width

        text: qsTrc("appshell/preferences", "Play chord when editing")

        enabled: root.playNotesWhenEditing

        navigation.name: "PlayChordBox"
        navigation.panel: root.navigation
        navigation.row: 3

        onClicked: {
            root.playChordWhenEditingChangeRequested(!checked)
        }
    }

    CheckBox {
        id: playChordSymbolBox
        width: parent.width

        text: qsTrc("appshell/preferences", "Play chord symbols and Nashville numbers")

        enabled: root.playNotesWhenEditing

        navigation.name: "PlayChordSymbolBox"
        navigation.panel: root.navigation
        navigation.row: 4

        onClicked: {
            root.playChordSymbolWhenEditingChangeRequested(!checked)
        }
    }

    CheckBox {
        id: playPreviewNotesInInputByDurationBox
        width: parent.width

        text: qsTrc("appshell/preferences", "Play when setting pitch (input by duration mode only)")

        enabled: root.playNotesWhenEditing

        navigation.name: "PlayPreviewNotesInInputByDurationBox"
        navigation.panel: root.navigation
        navigation.row: 5

        onClicked: {
            root.playPreviewNotesInInputByDurationChangeRequested(!checked)
        }
    }

    CheckBox {
        id: playNotesOnMidiInputBox
        width: parent.width

        text: qsTrc("appshell/preferences", "Play MIDI input")

        navigation.name: "PlayNotesOnMidiInputBox"
        navigation.panel: root.navigation
        navigation.row: 6

        onClicked: {
            root.playNotesOnMidiInputChangeRequested(!checked)
        }
    }
}
