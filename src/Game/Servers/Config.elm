module Game.Servers.Config exposing (..)

import Time exposing (Time)
import Core.Flags as Core
import Game.Meta.Types.Network as Network exposing (NIP)
import Game.Servers.Processes.Config as Processes
import Game.Servers.Logs.Config as Logs
import Game.Servers.Filesystem.Config as Filesystem
import Game.Servers.Tunnels.Config as Tunnels
import Game.Servers.Hardware.Config as Hardware
import Game.Notifications.Config as Notifications
import Game.Servers.Messages exposing (..)
import Game.Servers.Shared exposing (..)


type alias Config msg =
    { flags : Core.Flags
    , toMsg : Msg -> msg
    , batchMsg : List msg -> msg
    , lastTick : Time
    }


processesConfig : CId -> NIP -> Config msg -> Processes.Config msg
processesConfig cid nip config =
    { flags = config.flags
    , toMsg = ProcessesMsg >> ServerMsg cid >> config.toMsg
    , batchMsg = config.batchMsg
    , cid = cid
    , nip = nip
    , lastTick = config.lastTick
    }


logsConfig : CId -> Config msg -> Logs.Config msg
logsConfig cid config =
    { flags = config.flags
    , toMsg = LogsMsg >> ServerMsg cid >> config.toMsg
    , batchMsg = config.batchMsg
    , cid = cid
    }


filesystemConfig : CId -> StorageId -> Config msg -> Filesystem.Config msg
filesystemConfig cid storageId config =
    { flags = config.flags
    , toMsg = FilesystemMsg storageId >> ServerMsg cid >> config.toMsg
    , batchMsg = config.batchMsg
    , cid = cid
    }


tunnelsConfig : CId -> Config msg -> Tunnels.Config msg
tunnelsConfig cid config =
    { flags = config.flags
    , toMsg = TunnelsMsg >> ServerMsg cid >> config.toMsg
    , cid = cid
    }


hardwareConfig : CId -> NIP -> Config msg -> Hardware.Config msg
hardwareConfig cid nip config =
    { flags = config.flags
    , toMsg = HardwareMsg >> ServerMsg cid >> config.toMsg
    , cid = cid
    }


notificationsConfig : CId -> Config msg -> Notifications.Config msg
notificationsConfig cid config =
    { flags = config.flags
    , toMsg = NotificationsMsg >> ServerMsg cid >> config.toMsg
    , lastTick = config.lastTick
    }
