import QtQuick 2.2
import Sailfish.Silica 1.0
import Buteo.Profiles 0.1

Page {
    id: root

    property string clientProfile
    property date syncDate
    property bool scheduled: true
    property int error
    property var syncResults
    readonly property var _localListing: localAdditionsOrModifications(syncResults)
    readonly property var _remoteListing: remoteAdditionsOrModifications(syncResults)

    function localAdditionsOrModifications(results) {
        var uids = []
        for (var i = 0; i < results.length; i++) {
            uids = uids.concat(results[i].localAdditions)
            uids = uids.concat(results[i].localModifications)
        }
        return uids
    }

    function remoteAdditionsOrModifications(results) {
        var uids = []
        for (var i = 0; i < results.length; i++) {
            uids = uids.concat(results[i].remoteAdditions)
            uids = uids.concat(results[i].remoteModifications)
        }
        return uids
    }

    function listingView(profile) {
        switch (profile) {
        case "caldav":
            return "CaldavResultListView.qml"
        default:
            console.warn("not supported client profile: " + clientProfile)
            return ""
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: header.height + content.height

        PageHeader {
            id: header
            title: "Sync items"
            description: (root.scheduled ? "automatic" : "manual") + " at " + Format.formatDate(root.syncDate, Format.Timepoint)
        }

        Column {
            id: content

            width: parent.width
            anchors.top: header.bottom

            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                visible: error != SyncResults.NO_ERROR
                text: "error code " + error
                color: Theme.errorColor
            }

            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                text: "Downloaded from server"
                horizontalAlignment: Text.AlignRight
                color: Theme.highlightColor
            }
            Loader {
                width: parent.width
                active: _localListing.length > 0
                source: listingView(root.clientProfile)
                onLoaded: item.model = _localListing
            }
            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                visible: _localListing.length == 0
                height: Theme.itemSizeSmall
                text: "None"
                color: Theme.secondaryHighlightColor
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                text: "Sent to remote"
                horizontalAlignment: Text.AlignRight
                color: Theme.highlightColor
            }
            Loader {
                width: parent.width
                active: _remoteListing.length > 0
                source: listingView(root.clientProfile)
                onLoaded: item.model = _remoteListing
            }
            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                visible: _remoteListing.length == 0
                height: Theme.itemSizeSmall
                text: "None"
                color: Theme.secondaryHighlightColor
                verticalAlignment: Text.AlignVCenter
            }
        }

        VerticalScrollDecorator {}
    }
}
