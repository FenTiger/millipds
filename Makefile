docker:
	nix run .#container.copyToDockerDaemon
	docker history millipds:build-tmp
	docker tag millipds:build-tmp millipds:latest
