A robust, lightweight server-side anti-cheat designed to intercept and block unauthorized coordinate teleportation, map exploits, and sudden position manipulation on Roblox. 

Instead of using basic loops with delayed checking, which leaves severe loopholes, this framework utilizes a **mathematical delta-distance verification pipeline** synced strictly to `RunService.Heartbeat`. 

## Features
* The configuration definitions reside isolated inside `ServerStorage`. This physically blocks exploiters from sniffing or reading your max velocity bounds via local memory dumps.
* Tracks player positions on every single physics frame step. Exploiters cannot teleport to steal objects and snap back to a safe zone before a check executes, if they are caught mid-vector translation.
* Evaluates `AssemblyLinearVelocity` to automatically allow high velocity game impulses (like launch pads, vehicles, or explosive knockbacks), keeping false positives at zero.
* Upgraded with safe fallback definitions. If a configuration asset ever drops offline, the runtime loop handles the error gracefully without breaking or throwing server errors.
* Fully purges active player tracking arrays during `PlayerRemoving` sequences to prevent garbage collection and heap leaks on long-running servers.

## File Structure 
Built cleanly to match modern professional engineering environments:

```text
roblox-anti-teleport/
├── src/
│   ├── ServerScriptService/
│   │   └── AntiTeleport.server.luau  # Core frame checker
│   └── ServerStorage/
│       └── TeleportConfig.luau        # Secure hidden configurations
├── default.project.json               # Rojo engine map
└── README.md                          # Rojo Documentation
```

## Configuration Setup
You can easily adjust threshold parameters inside `src/ServerStorage/TeleportConfig.luau`:

```lua
local TeleportConfig = {
    MAX_SPEED_LIMIT = 45,       -- max character walkspeed threshold
    LATENCY_CUSHION = 8,        -- cushion multiplier for ping spikes/desync
    MAX_VIOLATIONS = 5,         -- flagged frames allowed before snapping back
    TELEPORT_BACK = true        -- forcefully rubber-band the user to last safe position
}
return TeleportConfig
```

## Commissions
I specialize in constructing secure, backend structures, memory optimized databases, and networking systems for Roblox (Luau). If you are looking to hire a script for your studio, hit me up :)

* **GitHub:** @anti-noclip
