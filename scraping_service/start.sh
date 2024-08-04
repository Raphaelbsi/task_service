set -e

host="$DATABASE_HOST"
shift
cmd="$@"

until mysql -h "$host" -u "$DATABASE_USER" -p"$DATABASE_PASSWORD" -e "select 1" >/dev/null 2>&1; do
  echo >&2 "MySQL is unavailable - sleeping"
  sleep 1
done

echo >&2 "MySQL is up - executing command"
exec $cmd
