
BASE_HREF = '/pixabay/'
GITHUB_REPO := https://github.com/vchib1/pixabay.git
BUILD_VER := '1.0.0'

deploy-web:
	@echo "Cleaning up..."
	flutter clean
	@echo "Getting Packages..."
	flutter pub get
	@echo "Building Web..."
	flutter build web --base-href $(BASE_HREF) --release
	@echo "Deploying Web to Repository..."
	cd build/web && \
	git init && \
	git add . && \
	git commit -m "Deploy Web v$(BUILD_VER)" && \
	git branch -m main && \
	git remote add origin $(GITHUB_REPO) && \
	git push -f origin main

	cd ../..
	@echo "Deployment Success :)"

.PHONY: deploy-web
