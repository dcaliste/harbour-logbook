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
