import QtQuick 2.2
import Sailfish.Silica 1.0
import Buteo.Profiles 0.1

Page {
    id: root

    property string clientProfile
    property date syncDate
    property bool scheduled: true
    property alias error: errorLabel.error
    property var syncResults
    readonly property var _localListing: localAdditionsOrModifications(syncResults)
    readonly property var _remoteListing: remoteAdditionsOrModifications(syncResults)
    readonly property int _localDeletions: localDeletions(syncResults)
    readonly property int _remoteDeletions: remotelDeletions(syncResults)

    function localAdditionsOrModifications(results) {
        var uids = []
        for (var i = 0; i < results.length; i++) {
            uids = uids.concat(results[i].localAdditions)
            uids = uids.concat(results[i].localModifications)
            uids = uids.concat(results[i].localFailures)
        }
        return uids
    }

    function remoteAdditionsOrModifications(results) {
        var uids = []
        for (var i = 0; i < results.length; i++) {
            uids = uids.concat(results[i].remoteAdditions)
            uids = uids.concat(results[i].remoteModifications)
            uids = uids.concat(results[i].remoteFailures)
        }
        return uids
    }

    function localDeletions(results) {
        var n = 0
        for (var i = 0; i < results.length; i++) {
            n += results[i].localDeletions.length
        }
        return n
    }

    function remoteDeletions(results) {
        var n = 0
        for (var i = 0; i < results.length; i++) {
            n += results[i].remoteDeletions.length
        }
        return n
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
        contentHeight: content.height

        Column {
            id: content

            width: parent.width

            PageHeader {
                title: "Synced items"
                description: (root.scheduled ? "automatic" : "manual") + " at " + Format.formatDate(root.syncDate, Format.Timepoint)
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
            SyncErrorLabel {
                id: errorLabel
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                visible: error != SyncResults.NO_ERROR
            }
            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                visible: _localDeletions > 0
                height: Theme.itemSizeSmall
                text: "%1 incidence(s) deleted on device".arg(_localDeletions)
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
            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                visible: _remoteDeletions > 0
                height: Theme.itemSizeSmall
                text: "%1 incidence(s) remotely deleted".arg(_remoteDeletions)
                color: Theme.secondaryHighlightColor
                verticalAlignment: Text.AlignVCenter
            }
        }

        VerticalScrollDecorator {}
    }
}
