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

Label {
    property int error: SyncResults.NO_ERROR
    wrapMode: Text.Wrap
    text: {
        switch (error) {
            case SyncResults.NO_ERROR:
            return "Sync completed without any error."
            case SyncResults.ITEM_FAILURES:
            return "Some events were not synced, without preventing the sync process to complete."
            case SyncResults.AUTHENTICATION_FAILURE:
            return "Cannot authenticate to the server."
            case SyncResults.DATABASE_FAILURE:
            return "Error with the storage database."
            case SyncResults.ABORTED:
            return "Sync was aborted."
            case SyncResults.CONNECTION_ERROR:
            return "Network failure preventing sync to proceed."
            case SyncResults.LOW_BATTERY_POWER:
            return "Sync was ajourned due to low battery level."
            default:
            return "Some unknown error occured."
        }
    }
    font.pixelSize: Theme.fontSizeSmall
    color: Theme.secondaryHighlightColor
}
