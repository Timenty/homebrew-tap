cask "lidawake" do
  version "1.3.0"
  sha256 "dc82066b51b1964098ce7ee57e952a1aea7a2e848be187fd372af54f2cd2b857"

  url "https://github.com/Timenty/lid-awake/releases/download/v#{version}/LidAwake.zip"
  name "LidAwake"
  desc "Menu bar toggle that keeps the laptop awake with the lid closed"
  homepage "https://github.com/Timenty/lid-awake"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "LidAwake/LidAwake.app"

  # Ad-hoc signed (not notarized): clear the quarantine flag so macOS lets it open.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/LidAwake.app"]
  end

  # Quitting restores normal sleep if LidAwake was on.
  uninstall quit: "local.lidawake"

  zap delete: "/etc/sudoers.d/lidawake",
      trash:  "~/Library/Preferences/local.lidawake.plist"

  caveats <<~EOS
    Look for the mug in the menu bar. The first time you turn it on, macOS asks
    for your password once to install a narrowly scoped sudo rule
    (/etc/sudoers.d/lidawake: pmset disablesleep/lowpowermode/sleepnow only).

    Launch at login: right-click the mug → Open at Login.
  EOS
end
