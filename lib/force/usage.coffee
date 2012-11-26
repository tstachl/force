require 'colors'
force = require '../force'

module.exports = [
  "                     -ss+ohmy-                                        ".red
  "                   .hN:    /mm`                                       ".red
  "                  -NM-                                                ".red
  "                 .NMo                                                 ".red
  "                 mMm      .--.         .`  -:-    `.--.       `---`   ".red
  "             +++dMMs+++/hh+:/smd+   /smM/omMMM.`+yo//sMNy` `sds/:oNm/ ".red
  "               .NMy  .dM+     `yMm. `/MMm- `-`-mh`    -yy.-NN-````+MM+".red
  "               hMN.  mMd        mMm   NMo    `NM-         mMh++++++++:".red
  "              :MM+  `MMy        dMM`  NMo    -MM/         MMs         ".red
  "             `mMd    dMm       `NMy   NMo    .MMm`        dMN.       `".red
  "             sMM-    `hMh`    `dMs    NMo     :NMm/`   `//.mMN+.  `:ys".red
  "            -MMy       :sdyoosy+`  -ssdddss.   `+hNNmdhs/   /hmNMNms- ".red
  "            dMN`                                                      ".red
  "           +MM/                                                       ".red
  "          .NMh                                                        ".red
  "          dMm`                        ".red + force.author
  "`-`      yMd`                                                         ".red
  "NMh    .dMs`                                                          ".red
  "-sdo+osy+`                                                            ".red
  ""
  
  "Flawless deployment of Force.com apps to the cloud open-source and"
  "fully customizable."
  "https://github.com/tstachl/force"
  ""
  
  "Usage:".cyan.bold.underline
  ""
  "  force <command> [options]"
  ""
  
  "Commands:".cyan.bold.underline
  ""
  "  login [options]      Authorizes and stores the session."
  "  config [options]     Allows access to the configuration variables."
  "  compile [options]    Tries to compile Apex code."
  "  exec [options]       Execute an anonymous block of code."
  "  test [options]       Runs tests on the Force.com Platform."
  "  retrieve [options]   Retrieves specified metadata components."
  "  deploy [options]     Deploys a set of components."
  "  describe [options]   Retrieves the metadata from the organization."
  "  list [options]       Retrieve information about the metadata."
  ""
]