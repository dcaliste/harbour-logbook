import QtQuick 2.2
import Sailfish.Silica 1.0
import Buteo.Profiles 0.1

ApplicationWindow
{
    initialPage: page

    Page {
        id: page

        SilicaListView {
            anchors.fill: parent

            model: MultiSyncResultModel {
                id: resultModel
            }

            PullDownMenu {
                MenuItem {
                    text: resultModel.sorting == SyncResultModel.ByDate ?
                        "sort by account" : "sort by date"
                    onClicked: {
                        if (resultModel.sorting == SyncResultModel.ByDate) {
                            resultModel.sorting = SyncResultModel.ByAccount
                        } else {
                            resultModel.sorting = SyncResultModel.ByDate
                        }
                    }
                }
            }

            header: Column {
                width: parent.width

                PageHeader {
                    title: "Sync logs"
                }

                ComboBox {
                    label: "Visibility"
                    menu: ContextMenu {
                        MenuItem {
                            text: "all profiles"
                            onClicked: resultModel.filter = ""
                        }
                        Repeater {
                            model: resultModel.filterList
                            delegate: MenuItem {
                                text: modelData.label ? modelData.label : modelData.id
                                onClicked: resultModel.filter = modelData.id
                            }
                        }
                    }
                }
            }

            delegate: logItem

            VerticalScrollDecorator {}
        }
    }

    Component {
        id: logItem

        BackgroundItem {
            width: parent.width
            height: Math.max(Theme.itemSizeSmall, content.height + 2 * Theme.paddingSmall)

            Column {
                id: content
                property bool success: syncResults.majorCode == SyncResults.SYNC_RESULT_SUCCESS
                anchors.centerIn: parent
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                spacing: Theme.paddingSmall
                
                Label {
                    id: profile
                    width: parent.width
                    text: profileName
                    color: content.success ? Theme.highlightColor : Theme.errorColor
                    Image {
                        anchors.right: date.left
                        anchors.rightMargin: Theme.paddingSmall
                        anchors.verticalCenter: date.verticalCenter
                        visible: syncResults.scheduled
                        source: "image://theme/icon-s-sync"
                    }
                    Label {
                        id: date
                        anchors.right: parent.right
                        anchors.baseline: profile.baseline
                        text: Format.formatDate(syncResults.syncTime, Format.Timepoint)
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: Theme.secondaryHighlightColor
                    }
                }
                SyncErrorLabel {
                    anchors {
                        left:parent.left
                        leftMargin: Theme.paddingLarge
                        right:parent.right
                    }
                    visible: !content.success
                    error: syncResults.minorCode
                }
                Repeater {
                    model: syncResults.results
                    delegate: resultItem
                }
            }
            onClicked: {
                pageStack.animatorPush("SyncResultPage.qml",
                                       { clientProfile: clientName,
                                         syncDate: syncResults.syncTime,
                                         scheduled: syncResults.scheduled,
                                         error: syncResults.minorCode,
                                         syncResults: syncResults.results})
            }
        }
    }

    Component {
        id: resultItem

        Item {
            width: parent ? parent.width - x : 0
            x: Theme.paddingLarge
            height: delta.height

            Label {
                id: label
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.target
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
            }
            Flow {
                id: delta
                width: parent.width - label.width
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
                    Image {
                        source: "image://theme/icon-s-cloud-download"
                    }
                    Label {
                        text: delta.change(modelData.local)
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
                Row {
                    id: remote
                    spacing: Theme.paddingSmall
                    Image {
                        source: "image://theme/icon-s-cloud-upload"
                    }
                    Label {
                        text: delta.change(modelData.remote)
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }
        }
    }
}
