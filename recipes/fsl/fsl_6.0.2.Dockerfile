# Generated by: Neurodocker version 0+unknown
# Latest release: Neurodocker version 0.7.0
# Timestamp: 2020/06/30 16:19:59 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/ReproNim/neurodocker

Bootstrap: docker
From: debian:stretch

%post
su - root

export ND_ENTRYPOINT="/neurodocker/startup.sh"
apt-get update -qq
apt-get install -y -q --no-install-recommends \
    apt-utils \
    bzip2 \
    ca-certificates \
    curl \
    locales \
    unzip
apt-get clean
rm -rf /var/lib/apt/lists/*
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG="en_US.UTF-8"
chmod 777 /opt && chmod a+s /opt
mkdir -p /neurodocker
if [ ! -f "$ND_ENTRYPOINT" ]; then
  echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT"
  echo 'set -e' >> "$ND_ENTRYPOINT"
  echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT"
  echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT";
fi
chmod -R 777 /neurodocker && chmod a+s /neurodocker

printf '#!/bin/bash\nls -la' > /usr/bin/ll

chmod +x /usr/bin/ll

mkdir /afm01 /90days /30days /QRISdata /RDS /data /short /proc_temp /TMPDIR /nvme /local /gpfs1 /working /winmounts /state /autofs /cluster /local_mount /scratch /clusterdata /nvmescratch

apt-get update -qq
apt-get install -y -q --no-install-recommends \
    bc \
    dc \
    file \
    libfontconfig1 \
    libfreetype6 \
    libgl1-mesa-dev \
    libgl1-mesa-dri \
    libglu1-mesa-dev \
    libgomp1 \
    libice6 \
    libopenblas-base \
    libxcursor1 \
    libxft2 \
    libxinerama1 \
    libxrandr2 \
    libxrender1 \
    libxt6 \
    sudo \
    wget
apt-get clean
rm -rf /var/lib/apt/lists/*
echo "Downloading FSL ..."
mkdir -p /opt/fsl-6.0.2
curl -fsSL --retry 5 https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.2-centos6_64.tar.gz \
| tar -xz -C /opt/fsl-6.0.2 --strip-components 1 
sed -i '$iecho Some packages in this Docker container are non-free' $ND_ENTRYPOINT
sed -i '$iecho If you are considering commercial use of this container, please consult the relevant license:' $ND_ENTRYPOINT
sed -i '$iecho https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence' $ND_ENTRYPOINT
sed -i '$isource $FSLDIR/etc/fslconf/fsl.sh' $ND_ENTRYPOINT
echo "Installing FSL conda environment ..."
bash /opt/fsl-6.0.2/etc/fslconf/fslpython_install.sh -f /opt/fsl-6.0.2


test "$(getent passwd neuro)" || useradd --no-user-group --create-home --shell /bin/bash neuro
su - neuro

echo '{
\n  "pkg_manager": "apt",
\n  "instructions": [
\n    [
\n      "base",
\n      "debian:stretch"
\n    ],
\n    [
\n      "user",
\n      "root"
\n    ],
\n    [
\n      "_header",
\n      {
\n        "version": "generic",
\n        "method": "custom"
\n      }
\n    ],
\n    [
\n      "run",
\n      "printf '"'"'#!/bin/bash\\\nls -la'"'"' > /usr/bin/ll"
\n    ],
\n    [
\n      "run",
\n      "chmod +x /usr/bin/ll"
\n    ],
\n    [
\n      "run",
\n      "mkdir /afm01 /90days /30days /QRISdata /RDS /data /short /proc_temp /TMPDIR /nvme /local /gpfs1 /working /winmounts /state /autofs /cluster /local_mount /scratch /clusterdata /nvmescratch"
\n    ],
\n    [
\n      "fsl",
\n      {
\n        "version": "6.0.2"
\n      }
\n    ],
\n    [
\n      "env",
\n      {
\n        "FSLOUTPUTTYPE": "NIFTI_GZ"
\n      }
\n    ],
\n    [
\n      "env",
\n      {
\n        "DEPLOY_PATH": "/opt/fsl-6.0.2/bin/:/opt/fsl-6.0.2/fslpython/envs/fslpython/bin/"
\n      }
\n    ],
\n    [
\n      "user",
\n      "neuro"
\n    ]
\n  ]
\n}' > /neurodocker/neurodocker_specs.json

%environment
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export ND_ENTRYPOINT="/neurodocker/startup.sh"
export FSLDIR="/opt/fsl-6.0.2"
export PATH="/opt/fsl-6.0.2/bin:$PATH"
export FSLOUTPUTTYPE="NIFTI_GZ"
export FSLMULTIFILEQUIT="TRUE"
export FSLTCLSH="/opt/fsl-6.0.2/bin/fsltclsh"
export FSLWISH="/opt/fsl-6.0.2/bin/fslwish"
export FSLLOCKDIR=""
export FSLMACHINELIST=""
export FSLREMOTECALL=""
export FSLGECUDAQ="cuda.q"
export FSLOUTPUTTYPE="NIFTI_GZ"
export DEPLOY_PATH="/opt/fsl-6.0.2/bin/:/opt/fsl-6.0.2/fslpython/envs/fslpython/bin/"

%runscript
/neurodocker/startup.sh "$@"
