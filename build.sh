#!/bin/bash
#
# See https://askubuntu.com/questions/627174/how-would-i-upgrade-systemd.

sudo apt-get install build-essential devscripts -y
sudo apt-get build-dep systemd -y

cd 229

if ! test -e systemd_229.orig.tar.gz ; then
    wget http://archive.ubuntu.com/ubuntu/pool/main/s/systemd/systemd_229.orig.tar.gz
fi
if ! test -e systemd_229-4ubuntu21.4.debian.tar.xz; then
    wget http://archive.ubuntu.com/ubuntu/pool/main/s/systemd/systemd_229-4ubuntu21.4.debian.tar.xz
fi
if ! test -e systemd_229-4ubuntu21.4.dsc; then
    wget http://archive.ubuntu.com/ubuntu/pool/main/s/systemd/systemd_229-4ubuntu21.4.dsc
fi

# clean first
rm -rf systemd-229

# prepare
tar -xvf systemd_229.orig.tar.gz
tar -C systemd-229/ -xvJf systemd_229-4ubuntu21.4.debian.tar.xz

# add extra patches
echo "# github.com/cofyc/systemd-build patches" >> systemd-229/debian/patches/series
for f in $(ls patches); do
    cp patches/$f systemd-229/debian/patches
    echo "$f" >> systemd-229/debian/patches/series
done

# apply version patch
diff -u systemd-229/debian/changelog changelog
cp changelog systemd-229/debian/changelog

# build
cd systemd-229
/usr/bin/dpkg-buildpackage -us -uc -b -j8
