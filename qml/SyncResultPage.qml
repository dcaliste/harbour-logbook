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
    readonly property string _itemDelegate: {
        switch (clientProfile) {
        case "caldav":
            return "CaldavResultListView.qml"
        default:
            return ""
        }
    }

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

            SyncErrorLabel {
                id: errorLabel
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                visible: error != SyncResults.NO_ERROR
            }
            Item {
                width: 1
                height: Theme.paddingMedium
            }

            SyncItemListView {
                title: "Downloaded from server"
                delegate: _itemDelegate
                itemUids: _localListing
                deletedItemText: {
                    var n = 0
                    for (var i = 0; i < syncResults.length; i++) {
                        n += syncResults[i].localDeletions.length
                    }
                    return n ? "%1 incidence(s) deleted on device".arg(n) : ""
                }
                failureMessages: {
                    var messages = {}
                    for (var i = 0; i < syncResults.length; i++) {
                        for (var j = 0; j < syncResults[i].localFailures.length; j++) {
                            messages[syncResults[i].localFailures[j]] = syncResults[i].localMessage(syncResults[i].localFailures[j])
                        }
                    }
                    return messages
                }
                visible: _itemDelegate.length > 0
            }
            SyncItemListView {
                title: "Sent to remote"
                delegate: _itemDelegate
                itemUids: _remoteListing
                deletedItemText: {
                    var n = 0
                    for (var i = 0; i < syncResults.length; i++) {
                        n += syncResults[i].remoteDeletions.length
                    }
                    return n ? "%1 incidence(s) remotely deleted".arg(n) : ""
                }
                failureMessages: {
                    var messages = {}
                    for (var i = 0; i < syncResults.length; i++) {
                        for (var j = 0; j < syncResults[i].remoteFailures.length; j++) {
                            messages[syncResults[i].remoteFailures[j]] = syncResults[i].remoteMessage(syncResults[i].remoteFailures[j])
                        }
                    }
                    return messages
                }
                visible: _itemDelegate.length > 0
            }
            ViewPlaceholder {
                enabled: _itemDelegate.length == 0
                text: "no support for detailed logging"
                hintText: "sync service: " + clientProfile
            }
        }

        VerticalScrollDecorator {}
    }
}
