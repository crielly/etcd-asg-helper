ZIP_NAME=etcdasghelper.zip

.DEFAULT_GOAL: build

build:
    echo "Creating ZIP at ${ZIP_NAME} for deploy to Lambda"
    zip -R ${ZIP_NAME} '*.py'

clean:
	echo "Cleaning up ${ZIP_NAME} if found"

	@if [ -e "${ZIP_NAME}" ]; \
		then \
		rm "${ZIP_NAME}"; \
	fi

.PHONY: clean
