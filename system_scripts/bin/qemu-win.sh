#!/bin/sh

qemu-system-x86_64 \
	--enable-kvm \
	-smp cores=1,threads=2 \
	-cpu host \
	-hda /home/b/Qemu/windows10.img \
	-boot d \
	-m 4096 \
	-cdrom /home/b/Downloads/Win10_2004_English_x64.iso

	#-net nic -net user,smb=/home/b/Qemu/windows10_share
