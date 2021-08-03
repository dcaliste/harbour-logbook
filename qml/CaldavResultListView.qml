import QtQuick 2.2
import Sailfish.Silica 1.0
import org.nemomobile.calendar 1.0

Column {
    property alias model: eventList.identifiers

    EventListModel {
        id: eventList
    }

    width: parent.width

    Repeater {
        width: parent.width
        model: eventList
        delegate: EventListDelegate {}
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
