# csgenny

ReGenny scripts for FFXIVClientStructs.

## Usage

This project uses some Node.js libraries to bundle and minify the scripts:

```shell
npm i
cp config.example.lua config.lua
$EDITOR config.lua
node build.js
```

After loading a project and attaching to FFXIV, select File > Run Lua Script and select a file in the `dist` folder.

## Scripts

### resolver

The resolver converts various bangs in the Address field into their location in memory. You can use the following bangs:

- `instance!` to resolve the instance of a class from data.yml
  - `instance!classname`, e.g. `instance!Client::System::Framework::Framework`

Using this requires [my ReGenny fork](https://github.com/NotNite/regenny/tree/address-resolvers) until my PR is merged.

## Contributing

Please use [StyLua](https://github.com/JohnnyMorganz/StyLua) for formatting (`npm run format`) and [lua-language-server](https://github.com/LuaLS/lua-language-server) for linting and typechecking.
