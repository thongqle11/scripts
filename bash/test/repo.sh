repo_name=rhel7dvd.repo
mount -o loop /dev/sr0 /mnt
cp /mnt/media.repo /etc/yum.repos.d/$repo_name
chmod 644 /etc/yum.repos.d/$repo_name
sed -i 's/^gpgcheck=0.*/gpgcheck=1/' /etc/yum.repos.d/$repo_name
echo "enabled=1
baseurl=file:///mnt/ 
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> /etc/yum.repos.d/$repo_name
yum clean all
subscription-manager clean

