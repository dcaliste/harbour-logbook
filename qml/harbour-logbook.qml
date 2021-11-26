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

            delegate: BackgroundItem {
                id: logItem
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
                        color: logItem.highlighted ? Theme.highlightColor : (content.success ? Theme.primaryColor : Theme.errorColor)
                        Icon {
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
                            color: logItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
                        }
                    }
                    SyncErrorLabel {
                        anchors {
                            left:parent.left
                            leftMargin: Theme.paddingLarge
                            right:parent.right
                        }
                        error: syncResults.minorCode
                    }
                    Repeater {
                        id: results
                        property int idWidth: 0
                        model: syncResults.results
                        delegate: SyncResultItem {
                            width: parent.width - x
                            x: Theme.paddingLarge
                            syncResult: modelData
                            targetLabelWidth: Math.min(width * 0.75, results.idWidth)
                            onTargetLabelImplicitWidthChanged: {
                                results.idWidth = Math.max(results.idWidth,
                                                           targetLabelImplicitWidth)
                            }
                        }
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

            VerticalScrollDecorator {}
        }
    }
}
