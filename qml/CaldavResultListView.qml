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
