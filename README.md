# Advanced Digging Script for QBCore & QBOX

A modern and versatile digging script for FiveM servers. This script utilizes `ox_lib` and `ox_inventory` to provide a smooth user experience, featuring item durability, minigames, and accurate ground detection.

## 🌟 Features
* **Accurate Ground Detection:** Players can only dig on specific terrain materials (e.g., sand). Materials can be easily added or modified in the config.
* **Minigame & Animations:** Initiating a dig requires a successful skill check (`ox_lib`). Includes proper animations and shovel props.
* **Shovel Durability:** The shovel's durability decreases with each dig and will eventually break (utilizes `ox_inventory` metadata).
* **Dynamic Loot Table:** Easily configurable loot chances, minimum, and maximum amounts.
* **Discord Logs:** Built-in support for Discord webhooks to log found items, broken shovels, and full inventories.
* **Locales:** Built-in support for English (`en`) and Finnish (`fi`).

## 📋 Requirements
Ensure you have the following resources installed and started before using this script:
* [qb-core](https://github.com/qbcore-framework/qb-core) or [qbx_core](https://github.com/Qbox-project/qbx_core)
* [ox_lib](https://github.com/overextended/ox_lib)
* [ox_inventory](https://github.com/overextended/ox_inventory)

## 🛠️ Installation

1. Download this script and place it in your `resources` folder.
2. Make sure the folder is named `v-digging`
3. Add the recourse to your server.cfg: `ensure v-digging`
4. Add the shovel item to your `ox_inventory/data/items.lua`. Since the script uses an export to trigger the item, it should look like this:

```lua
['shovel'] = {
    label = 'Shovel',
    weight = 1000,
    stack = false,
    consume = 0,
    client = {
        export = 'v-digging.useShovel'
    }
}
```
5. Configure `config.lua` to your liking and set your Discord Webhook in `server/main.lua`.
