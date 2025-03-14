enum ServerProperty: String {
    case acceptTransfers = "accepts-transfers"
    case allowFlight = "allow-flight"
    case allowNether = "allow-nether"
    case broadcastConsoleToOps = "broadcast-console-to-ops"
    case broadcastRconToOps = "broadcast-rcon-to-ops"
    case bugReportLink = "bug-report-link"
    case debug = "debug"
    case difficulty = "difficulty"
    case enableCommandBlock = "enable-command-block"
    case enableJmxMonitoring = "enable-jmx-monitoring"
    case enableQuery = "enable-query"
    case enableRcon = "enable-rcon"
    case enableStatus = "enable-status"
    case enforceSecureProfile = "enforce-secure-profile"
    case enforceWhitelist = "enforce-whitelist"
    case entityBroadcasrRangePercentage = "entity-broadcast-range-percentage"
    case forceGamemode = "force-gamemode"
    case functionPermissionLevel = "function-permission-level"
    case gamemode = "gamemode"
    case generateStructures = "generate-structures"
    case generatorSettings = "generator-settings"
    case hardcore = "hardcore"
    case hideOnlinePlayers = "hide-online-players"
    case initialDisabledPacks = "initial-disabled-packs"
    case initialEnabledPacks = "initial-enabled-packs"
    case levelName = "level-name"
    case levelSeed = "level-seed"
    case levelType = "level-type"
    case logIps = "log-ips"
    case maxChanedNeighborUpdates = "max-chained-neighbor-updates"
    case maxPlayers = "max-players"
    case maxTickTime = "max-tick-time"
    case maxWorldSize = "max-world-size"
    case motd = "motd"
    case networkCompressionThreshold = "network-compression-threshold"
    case onlineMode = "online-mode"
    case opPermissionLevel = "op-permission-level"
    case pauseWhenEmptySeconds = "pause-when-empty-seconds"
    case playerIdleTimeout = "player-idle-timeout"
    case preventProxyConnections = "prevent-proxy-connections"
    case pvp = "pvp"
    case queryPort = "query.port"
    case rateLimit = "rate-limit"
    case rconPassword = "rcon.password"
    case rconPort = "rcon.port"
    case regionFileCompression = "region-file-compression"
    case requireResourcePack = "require-resource-pack"
    case resourcePack = "resource-pack"
    case resourcePackID = "resource-pack-id"
    case resourcePackPrompt = "resource-pack-prompt"
    case resourcePackSha1 = "resource-pack-sha1"
    case serverIp = "server-ip"
    case serverPort = "server-port"
    case simulationDistance = "simulation-distance"
    case spawnMonsters = "spawn-monsters"
    case spawnProtection = "spawn-protection"
    case syncChunkWrites = "sync-chunk-writes"
    case textFilteringConfig = "text-filtering-config"
    case textFilteringVersion = "text-filtering-version"
    case useNativeTransport = "use-native-transport"
    case viewDistance = "view-distance"
    case whiteList = "white-list"

    var defaultValue: String {
        switch self {
        case .acceptTransfers:
            return "false"
        case .allowFlight:
            return "false"
        case .allowNether:
            return "true"
        case .broadcastConsoleToOps:
            return "true"
        case .broadcastRconToOps:
            return "true"
        case .bugReportLink:
            return ""
        case .debug:
            return "false"
        case .difficulty:
            return "easy"
        case .enableCommandBlock:
            return "false"
        case .enableJmxMonitoring:
            return "false"
        case .enableQuery:
            return "false"
        case .enableRcon:
            return "false"
        case .enableStatus:
            return "true"
        case .enforceSecureProfile:
            return "true"
        case .enforceWhitelist:
            return "false"
        case .entityBroadcasrRangePercentage:
            return "100"
        case .forceGamemode:
            return "false"
        case .functionPermissionLevel:
            return "2"
        case .gamemode:
            return "survival"
        case .generateStructures:
            return "true"
        case .generatorSettings:
            return "{}"
        case .hardcore:
            return "false"
        case .hideOnlinePlayers:
            return "false"
        case .initialDisabledPacks:
            return ""
        case .initialEnabledPacks:
            return "vanilla"
        case .levelName:
            return "world"
        case .levelSeed:
            return ""
        case .levelType:
            return "minecraft\\:normal"
        case .logIps:
            return "true"
        case .maxChanedNeighborUpdates:
            return "1000000"
        case .maxPlayers:
            return "20"
        case .maxTickTime:
            return "60000"
        case .maxWorldSize:
            return "29999984"
        case .motd:
            return "A Minecraft Server"
        case .networkCompressionThreshold:
            return "256"
        case .onlineMode:
            return "true"
        case .opPermissionLevel:
            return "4"
        case .pauseWhenEmptySeconds:
            return "-1"
        case .playerIdleTimeout:
            return "0"
        case .preventProxyConnections:
            return "false"
        case .pvp:
            return "true"
        case .queryPort:
            return "25565"
        case .rateLimit:
            return "0"
        case .rconPassword:
            return ""
        case .rconPort:
            return "25575"
        case .regionFileCompression:
            return "deflate"
        case .requireResourcePack:
            return "false"
        case .resourcePack:
            return ""
        case .resourcePackID:
            return ""
        case .resourcePackPrompt:
            return ""
        case .resourcePackSha1:
            return ""
        case .serverIp:
            return ""
        case .serverPort:
            return "25565"
        case .simulationDistance:
            return "10"
        case .spawnMonsters:
            return "true"
        case .spawnProtection:
            return "16"
        case .syncChunkWrites:
            return "true"
        case .textFilteringConfig:
            return ""
        case .textFilteringVersion:
            return "0"
        case .useNativeTransport:
            return "true"
        case .viewDistance:
            return "10"
        case .whiteList:
            return "false"
        }
    }
}
