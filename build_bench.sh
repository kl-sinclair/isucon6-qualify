#!/bin/sh

set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends ansible gcc git libc6-dev aptitude make
snap install --classic go
export GOPATH=/tmp/go
mkdir -p ${GOPATH}/src/github.com/isucon/
cd ${GOPATH}/src/github.com/isucon
rm -rf isucon6-qualify
git clone https://github.com/isucon/isucon6-qualify.git
(
  cd isucon6-qualify/bench
  go get github.com/Songmu/timeout
  go get github.com/mitchellh/go-homedir
  go get github.com/PuerkitoBio/goquery
  go get github.com/marcw/cachecontrol
  make
)
(
  cd isucon6-qualify/provisioning/bench
  PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i localhost, ansible/*.yml --connection=local
)
rm -rf ${GOPATH}
usermod -G sudo -a -s /bin/bash isucon
echo "Provisioning Successful for bench"
