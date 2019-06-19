yum install -y wget docker kubelet-{{ kubernetes_version }} kubectl-{{ kubernetes_version }} kubeadm-{{ kubernetes_version }}
sed -i "s/--selinux-enabled //" /etc/sysconfig/docker
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet
kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16
cp /etc/kubernetes/admin.conf /root/
chown root:root /root/admin.conf
export KUBECONFIG=/root/admin.conf
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown root:root /root/.kube/config
kubect get pod --all-namespaces > /root/prout.log
sleep 360
echo --------- >> /root/prout.log
kubect get pod --all-namespaces >> /root/prout.log
