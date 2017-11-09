FROM fedora
RUN curl -o /etc/yum.repos.d/bintray-reznikmm-matreshka.repo \
 https://bintray.com/reznikmm/matreshka/rpm && \
 dnf --assumeyes upgrade libsolv && \
 dnf --assumeyes install rpmdevtools && \
 dnf --assumeyes install gcc-gnat && \
 dnf --assumeyes install gprbuild && \
 dnf --assumeyes install gdb && \
 dnf --assumeyes install --repo bintray--reznikmm-matreshka matreshka-devel && \
useradd max && \
su -c rpmdev-setuptree max
COPY ada-pretty.tar.gz /home/max/rpmbuild/SOURCES
COPY * /src/