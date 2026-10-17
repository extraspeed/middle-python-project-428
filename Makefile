install:
	uv sync
	cd frontend && npm ci

build:
	rm -rf frontend/public/assets frontend/public/index.html
	cp -R frontend/node_modules/@hexlet/python-flight-booking-frontend/dist/. frontend/public/
generate_api_spec:
	cd frontend && npx tsp compile contract
start:
	uv run uvicorn --factory app.main:create_app --host 0.0.0.0 --port $${PORT:-8080}
test:
	uv run pytest