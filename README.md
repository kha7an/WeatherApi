

```bash
git clone https://github.com/kha7an/weatherApi

cd weatherApi

bundle install
```
```bash
rails db:create
rails db:migrate
```
```bash
rails server
```
--------------------------------------------

```bash
git clone https://github.com/kha7an/weatherApi
cd weatherApi
```
```bash
docker-compose build
docker-compose up
```
Теперь приложение будет доступно по адресу http://localhost:3000.

## Использование API

### Доступные эндпоинты

- `GET /api/weather/current` - Получить текущую температуру.
- `GET /api/weather/historical` - Получить температуру за последние 24 часа.
- `GET /api/weather/historical/max` - Получить максимальную температуру за последние 24 часа.
- `GET /api/weather/historical/min` - Получить минимальную температуру за последние 24 часа.
- `GET /api/weather/historical/avg` - Получить среднюю температуру за последние 24 часа.
- `GET /api/weather/by_time` - Найти температуру, ближайшую к переданному timestamp.
- `GET /api/health` - Проверка статуса бекенда (возвращает `OK`).
