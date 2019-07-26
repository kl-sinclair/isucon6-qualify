set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends ansible aptitude gcc git libc6-dev tzdata make
snap install --classic go
rm -rf isucon6-qualify
git clone https://github.com/kl-sinclair/isucon6-qualify.git
(
  cd isucon6-qualify
  make
  ln -s isupam_linux bin/isupam
)
(
  cd isucon6-qualify/provisioning/image/ansible
  PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i localhost, *.yml --connection=local -t dev
)
(
  cd isucon6-qualify/provisioning/image
  ./db_setup.sh
)
rm -rf isucon6-qualify
usermod -G sudo -a -s /bin/bash isucon
usermod -G users,isucon,google-sudoers isucon
echo "Provisioning Successful for image"
