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
    readonly property string _itemDelegate: {
        switch (clientProfile) {
        case "caldav":
            return "CaldavResultListView.qml"
        default:
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

            SyncErrorLabel {
                id: errorLabel
                width: parent.width - 2 * Theme.horizontalPageMargin
                height: implicitHeight + Theme.paddingLarge
                x: Theme.horizontalPageMargin
                visible: error != SyncResults.NO_ERROR
            }

            SyncItemListView {
                title: "Downloaded from server"
                delegate: _itemDelegate
                itemUids: {
                    var uids = []
                    for (var i = 0; i < syncResults.length; i++) {
                        uids = uids.concat(syncResults[i].localAdditions)
                        uids = uids.concat(syncResults[i].localModifications)
                        uids = uids.concat(syncResults[i].localFailures)
                    }
                    return uids
                }
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
                itemUids: {
                    var uids = []
                    for (var i = 0; i < syncResults.length; i++) {
                        uids = uids.concat(syncResults[i].remoteAdditions)
                        uids = uids.concat(syncResults[i].remoteModifications)
                        uids = uids.concat(syncResults[i].remoteFailures)
                    }
                    return uids
                }
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
                hintText: "service: " + clientProfile
            }
        }

        VerticalScrollDecorator {}
    }
}
