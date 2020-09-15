chmod 755 ta
chmod 755 ver
chmod 755 fex
chmod 755 iex
chmod 755 wwn
chmod 755 scan
chmod 755 mprefresh
chmod 755 qif
chmod 755 qiff
chmod 755 qiscsi
chmod 755 qagent
chmod 755 linux_sysinfo_e4.py
chmod 755 qssh
chmod 755 show_gids.sh

echo "copying ta to /usr/local/bin..."
cp ta /usr/local/bin/
echo "Done."

echo "copying ver to /usr/local/bin..."
cp ver /usr/local/bin/
echo "Done."

echo "copying fex to /usr/local/bin..."
cp fex /usr/local/bin/
echo "Done."

echo "copying iex to /usr/local/bin..."
cp iex /usr/local/bin/
echo "Done."

echo "copying wwn to /usr/local/bin..."
cp wwn /usr/local/bin/
echo "Done."

echo "copying scan to /usr/local/bin..."
cp scan /usr/local/bin/
echo "Done."

echo "copying mprefresh to /usr/local/bin..."
cp mprefresh /usr/local/bin/
echo "Done."

echo "copying qif to /usr/local/bin..."
cp qif /usr/local/bin/
echo "Done."

echo "copying qiff to /usr/local/bin..."
cp qiff /usr/local/bin/
echo "Done."

echo "copying qiscsi to /usr/local/bin..."
cp qiscsi /usr/local/bin/
echo "Done."

echo "copying qagent to /usr/local/bin..."
cp qagent /usr/local/bin/
echo "Done."

echo "copying linux_sysinfo_e4.py to /usr/local/bin..."
cp linux_sysinfo_e4.py /usr/local/bin/
echo "Done."

echo "copying linux_sysinfo_e4.py to /usr/local/bin..."
cp qssh /usr/local/bin/
echo "Done."

echo "show_gids.sh to /root/..."
cp show_gids.sh /root/
echo "Done."
systemctl stop firewalld.service
systemctl disable firewalld.service

cp /usr/bin/expect /usr/local/bin
mkdir -p /eit/vms/
