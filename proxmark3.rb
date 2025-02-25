class Proxmark3 < Formula
  desc "Proxmark3 client, CDC flasher, HID flasher and firmware bundle"
  homepage "http://www.proxmark.org"
  url "https://github.com/proxmark/proxmark3/archive/v3.1.0.tar.gz"
  sha256 "855bf191479b1389c0761dc34fa6c738dc775599e95e679847f4c7f1c276d8de"
  head "https://github.com/ethahae/proxmark3.git"

#  depends_on "automake" => :build
  depends_on "readline"
  depends_on "p7zip" => :build
  depends_on "libusb"
  depends_on "libusb-compat"
  depends_on "pkg-config" => :build
#  depends_on "wget"
  depends_on "qt5"
  depends_on "perl"
  depends_on "proxmark/proxmark3/arm-none-eabi-gcc" => :build

  def install
    ENV.deparallelize

#    system "make", "-C", "client/hid-flasher/"
    system "make", "clean"      
    system "make", "all"
    
    bin.mkpath
    bin.install "client/flasher" => "proxmark3-flasher"
#    bin.install "client/hid-flasher/flasher" => "proxmark3-hid-flasher"
    bin.install "client/proxmark3" => "proxmark3"
    bin.install "client/fpga_compress" => "fpga_compress"

    # default keys
    bin.install "client/default_keys.dic" => "default_keys.dic"
    bin.install "client/default_pwd.dic" => "default_pwd.dic"

    # hardnested files
    (bin/"hardnested/tables").mkpath
    (bin/"hardnested").install "client/hardnested/bf_bench_data.bin"
    (bin/"hardnested/tables").install Dir["client/hardnested/tables/*"]

    # lua libs for proxmark3 scripts
    (bin/"lualibs").mkpath
    (bin/"lualibs").install Dir["client/lualibs/*"]

    # lua scripts
    (bin/"scripts").mkpath
    (bin/"scripts").install Dir["client/scripts/*"]

    # trace files for experimentations
    (bin/"traces").mkpath
    (bin/"traces").install Dir["traces/*"]
    
    # emv public keys file
    if File.exist?("client/emv/capk.txt") then
      (bin/"emv").mkpath
      (bin/"emv").install "client/emv/capk.txt"
    end

    share.mkpath
    # compiled firmware for flashing
    (share/"firmware").mkpath
    (share/"firmware").install "armsrc/obj/fullimage.elf" => "fullimage.elf"
    (share/"firmware").install "bootrom/obj/bootrom.elf" => "bootrom.elf"


#    ohai "Install success! Upgrade devices on HID firmware with proxmark3-hid-flasher, or devices on more modern firmware with proxmark3-flasher."
    ohai "Install success!  Only proxmark3-flasher (modern firmware) is available."
    ohai "The latest bootloader and firmware binaries are ready and waiting in the current homebrew Cellar within share/firmware."
  end

  test do
    system "proxmark3", "-h"
  end
end
