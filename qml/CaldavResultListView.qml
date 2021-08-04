import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Calendar 1.0
import org.nemomobile.calendar 1.0
import org.nemomobile.dbus 2.0

Column {
    property alias model: eventList.identifiers

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
        delegate: CalendarEventListDelegate {
            useActiveDay: false
            onClicked: {
                calendar.call("viewEvent",
                    [
                        model.event.uniqueId,
                        model.event.recurrenceId,
                        Qt.formatDateTime(model.occurrence.startTime, Qt.ISODate)
                    ])
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
