### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Mello Oof Mega Omega Gawd Overlord Kernel by Mayur @marshmello_61
do.devicecheck=1
do.modules=1
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=RMX2170
device.name2=RMX2061
#device.name3=toroplus
#device.name4=tuna
#device.name5=
supported.versions=11 - 14
supported.patchlevels=
'; } # end properties

### AnyKernel install
# begin attributes
attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
} # end attributes

# shell variables
block=/dev/block/bootdevice/by-name/boot
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh && attributes;


# Patch prop for app crash due to JNI mismatch (not all roms have these props
# so add it)
# ui_print " " "Patching system to fix some old app crash"
# patch_prop /vendor/build.prop "ro.kernel.android.checkjni" "0"
# patch_prop /vendor/build.prop "ro.kernel.checkjni" "0"

# Patch prop for battery saving
# ui_print " " "Patching vendor for battery saving for ROMs that don't have"
# patch_prop /vendor/build.prop "pm.sleep_mode" "1"
# patch_prop /vendor/build.prop "power.saving.mode" "1"

# Patch prop to disable post FP animation for faster unlock
# ui_print " " "Patching vendor for making FP unlock faster for ROMs that don't have"
# patch_prop /vendor/build.prop "persist.wm.enable_remote_keyguard_animation" "0"

# Patch prop to enable smooth scrolling
# ui_print " " "Patching vendor to enable smooth scrolling for ROMs that don't have"
# patch_prop /vendor/build.prop "ro.vendor.perf.scroll_opt" "true"


# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

# init.rc
#backup_file init.rc;
#replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

# init.tuna.rc
#backup_file init.tuna.rc;
#insert_line init.tuna.rc "nodiratime barrier=0" after "mount_all /fstab.tuna" "\tmount ext4 /dev/block/platform/omap/omap_hsmmc.0/by-name/userdata /data remount nosuid nodev noatime nodiratime barrier=0";
#append_file init.tuna.rc "bootscript" init.tuna;

# migrate from /overlay to /overlay.d to enable SAR Magisk
if [ -d $ramdisk/overlay ]; then
  rm -rf $ramdisk/overlay;
fi;

# fstab.tuna
#backup_file fstab.tuna;
#patch_fstab fstab.tuna /system ext4 options "noatime,barrier=1" "noatime,nodiratime,barrier=0";
#patch_fstab fstab.tuna /cache ext4 options "barrier=1" "barrier=0,nomblk_io_submit";
#patch_fstab fstab.tuna /data ext4 options "data=ordered" "nomblk_io_submit,data=writeback";
#append_file fstab.tuna "usbdisk" fstab;


write_boot;
## end boot install


# shell variables
#block=vendor_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for vendor_boot patching
#reset_ak;


## AnyKernel vendor_boot install
#split_boot; # skip unpack/repack ramdisk since we don't need vendor_ramdisk access

#flash_boot;
## end vendor_boot install

