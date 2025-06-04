infra/run:
	vagrant up
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.60 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.61 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.70 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.71 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.80 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.81 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.90 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.91 ls -lah
	ansible-playbook --inventory-file hosts.yml main.yml --vault-password-file ansible_vault_pwd.txt
	sleep 180
	kubectl apply -f metrics_server.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
	sleep 120
	kubectl apply -f ip_address_pool.yaml
	kubectl apply -f l2_advertisement.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/cloud/deploy.yaml
	sleep 180
	kubectl apply -f longhorn.yaml

infra/destroy:
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.60"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.61"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.70"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.71"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.80"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.81"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.90"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.91"
	vagrant destroy -f