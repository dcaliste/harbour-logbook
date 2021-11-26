import QtQuick 2.2
import Sailfish.Silica 1.0
import Buteo.Profiles 0.1

Item {
    property var syncResult
    property alias targetLabelImplicitWidth: label.implicitWidth
    property alias targetLabelWidth: label.width

    height: delta.height

    Label {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        text: syncResult.target
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
        truncationMode: TruncationMode.Fade
    }
    Flow {
        id: delta
        width: parent.width - label.width - Theme.paddingLarge
        anchors.left: label.right
        anchors.leftMargin: Theme.paddingLarge
        spacing: Theme.paddingLarge
        function change(item) {
            var out = ""
            if (item.added) out += ", A: " + item.added
            if (item.deleted) out += ", D: " + item.deleted
            if (item.modified) out += ", M: " + item.modified
            if (out.length > 0) {
                return out.slice(2)
            } else {
                return "no change"
            }
        }
        Row {
            id: local
            spacing: Theme.paddingSmall
            width: Math.max(parent.width / 4, implicitWidth)
            Icon {
                source: "image://theme/icon-s-cloud-download"
            }
            Label {
                text: delta.change(syncResult.local)
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
            }
        }
        Row {
            id: remote
            spacing: Theme.paddingSmall
            width: Math.max(parent.width / 4, implicitWidth)
            Icon {
                source: "image://theme/icon-s-cloud-upload"
            }
            Label {
                text: delta.change(syncResult.remote)
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
            }
        }
    }
}
