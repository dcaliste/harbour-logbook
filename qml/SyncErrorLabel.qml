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
