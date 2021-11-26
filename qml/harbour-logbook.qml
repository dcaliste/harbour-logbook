/*************************************************************************************
**
** Copyright (C) 2020-2021 Damien Caliste <dcaliste@free.fr>.
** 
** This file is part of the logbook demonstration application for Buteo log viewing.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the copyright holder nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
** 
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
*************************************************************************************/

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
