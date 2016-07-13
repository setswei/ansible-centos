# Select Source Centos OS
FROM centos:5.11

# Author
MAINTAINER setswei <kyle.hartigan@cybercrysis.net.au>

# Import RPM Keys
RUN rpm --import http://mirror.centos.org/centos/5.11/os/x86_64/RPM-GPG-KEY-CentOS-5 && \
    rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-5 && \
    rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 && \

    # First Cleanup
    yum update -y && \
    yum clean all && \

    # Download and Install EPEL and rpm build tools
    yum -y install epel-release rpm-build make asciidoc python-setuptools python2-devel && \

    # Compile git
    yum -y groupinstall "Development tools" && \
    yum -y install zlib-devel openssl-devel cpio expat-devel gettext-devel tar wget && \
    cd /usr/local/src && \
    wget http://git-core.googlecode.com/files/git-1.7.9.tar.gz && \
    tar xvzf git-1.7.9.tar.gz && \
    cd git-1.7.9 && \
    ./configure && \
    make && \
    make install && \

    # Update Yum
    yum -y update && \

    # Install Ansible - Centos 5.* needs to be complied
    git clone git://github.com/ansible/ansible.git --recursive && \
    cd ./ansible && \
    make rpm && \
    rpm -Uvh ./rpm-build/ansible-*.noarch.rpm && \

    # Yum Clean up
    yum clean all && \

    # Create Ansible Inventory File
    echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts