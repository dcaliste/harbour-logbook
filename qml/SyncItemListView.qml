import QtQuick 2.2
import Sailfish.Silica 1.0

Column {
    property alias title: section.text
    property alias deletedItemText: deleted.text
    property string delegate
    property var itemUids
    property var failureMessages
    property int deletedItemCount: 0
    width: parent.width
    Label {
        id: section
        width: parent.width - 2 * Theme.horizontalPageMargin
        x: Theme.horizontalPageMargin
        horizontalAlignment: Text.AlignRight
        color: Theme.highlightColor
    }
    Loader {
        width: parent.width
        active: itemUids.length > 0
        source: delegate
        onLoaded: {
            item.model = itemUids
            item.failureMessages = failureMessages
        }
    }
    Label {
        width: parent.width - 2 * Theme.horizontalPageMargin
        x: Theme.horizontalPageMargin
        visible: itemUids.length == 0
        height: Theme.itemSizeSmall
        text: "None"
        color: Theme.secondaryHighlightColor
        verticalAlignment: Text.AlignVCenter
    }
    Label {
        id: deleted
        width: parent.width - 2 * Theme.horizontalPageMargin
        x: Theme.horizontalPageMargin
        visible: text.length > 0
        height: Theme.itemSizeSmall
        color: Theme.secondaryHighlightColor
        verticalAlignment: Text.AlignVCenter
    }
}
