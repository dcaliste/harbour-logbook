/*************************************************************************************
**
** Copyright (C) 2020-2021 Damien Caliste <dcaliste@free.fr>.
** 
** This file is part of the logbook demonstration application for Buteo log viewing.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the copyright holder nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
** 
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
*************************************************************************************/

import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Calendar 1.0
import org.nemomobile.calendar 1.0
import org.nemomobile.dbus 2.0

Column {
    property alias model: eventList.identifiers
    property var failureMessages

    EventListModel {
        id: eventList
    }

    DBusInterface {
        id: calendar

        service: "com.jolla.calendar.ui"
        path: "/com/jolla/calendar/ui"
        iface: "com.jolla.calendar.ui"
    }

    width: parent.width

    Repeater {
        width: parent.width
        model: eventList
        delegate:  Column {
            width: parent.width
            CalendarEventListDelegate {
                timeText: {
                    if (model.occurrence.startTime.getFullYear() == model.occurrence.endTime.getFullYear()
                        && model.occurrence.startTime.getMonth() == model.occurrence.endTime.getMonth()
                        && model.occurrence.startTime.getDate() == model.occurrence.endTime.getDate()) {
                        return (Format.formatDate(model.occurrence.startTime, Formatter.DateMedium) + " "
                            + (model.event.allDay
                               ? "all day"
                               : (Format.formatDate(model.occurrence.startTime, Formatter.TimeValue) + "-"
                                  + Format.formatDate(model.occurrence.endTime, Formatter.TimeValue))))
                    } else {
                        return (Format.formatDate(model.occurrence.startTime, Formatter.DateMedium)
                            + (model.event.allDay ? "" : (" " + Format.formatDate(model.occurrence.startTime, Formatter.TimeValue)))
                            + " - " + Format.formatDate(model.occurrence.endTime, Formatter.DateMedium)
                            + (model.event.allDay ? "" : (" " + Format.formatDate(model.occurrence.endTime, Formatter.TimeValue))))
                    }
                }
                onClicked: {
                    calendar.call("viewEvent",
                        [
                            model.event.uniqueId,
                            model.event.recurrenceId,
                            Qt.formatDateTime(model.occurrence.startTime, Qt.ISODate)
                        ])
                }
            }
            Label {
                property bool hasMessage: failureMessages[model.identifier] !== undefined
                x: Theme.horizontalPageMargin + Theme.paddingLarge
                width: parent.width - x - Theme.horizontalPageMargin
                visible: hasMessage
                text: hasMessage ? failureMessages[model.identifier] : ""
                color: Theme.secondaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                font.family: "monospace"
            }
        }
    }

    Label {
        x: Theme.horizontalPageMargin
        height: Theme.itemSizeMedium
        visible: eventList.missingItems.length > 0
        text: eventList.missingItems.length + " event(s) not on device anymore"
        color: Theme.highlightColor
        verticalAlignment: Text.AlignVCenter
    }
}
