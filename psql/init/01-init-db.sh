#!/bin/bash
set -o errexit

readonly REQUIRED_ENV_VARS=(
    "PSQL_DB_USER"
    "PSQL_DB_PASSWORD"
    "PSQL_DB_DATABASE"
    "POSTGRES_USER"
)

main() {
    check_env_vars_set
    init_user_and_db
}

check_env_vars_set() {
    for required_env_var in ${REQUIRED_ENV_VARS[@]}; do
        if [[ -z "${!required_env_var}" ]]; then
            echo "Error: 
Required Environment Variables '$required_env_var' are not set.
Make sure the following required (mandatory) environment variables set:

${REQUIRED_ENV_VARS[@]}

Aborting the check!"
            exit 1
        fi
    done
}

init_user_and_db() {
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER $PSQL_DB_USER WITH PASSWORD '$PSQL_DB_PASSWORD';
        CREATE DATABASE $PSQL_DB_DATABASE;
        GRANT ALL PRIVILEGES ON DATABASE $PSQL_DB_DATABASE TO $PSQL_DB_USER;
EOSQL
}

main "$@"
