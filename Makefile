
local_generate:
	xcodegen generate --spec local.yml

clean:
	@find . -name "*.xcodeproj" -exec rm -rf {} +
