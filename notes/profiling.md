### How to profile

- https://github-wiki-see.page/m/HaxeFoundation/hashlink/wiki/Profiler

1. add `"profileSamples" : 10000`, to vscode HashLink launch configuration, AND, add `-D hl-profile` to `compile.hxml`
2. run app
3. stop app
4. an `hlprofile.dump` will be generated, this needs to be converted to json format for chrome to read
5. must pull hashlink repo https://github.com/HaxeFoundation/hashlink/tree/master/other/profiler
6. build the profiler.hl project using haxe `haxe /other/profiler/profiler.hxml`
7. run the profiler with the dumpfile: `hl ./other/profiler/profiler.hl hlprofile.dump --out profile.json`
8. open chrome -> performance tool, import the `profile.json` file
