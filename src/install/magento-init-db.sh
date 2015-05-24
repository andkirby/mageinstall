#!/usr/bin/env bash
# ======= Recreate DB =======
if [ "$INSTALL_RUN" = true ] || ( [ "$SAMPLE_DATA_SQL_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ] )
then
    $DB_CONNECT_COMMAND -h$DB_HOST -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
    has_tables=$($DB_CONNECT_COMMAND -h$DB_HOST -D$DB_NAME -e "SHOW TABLES;")
    if [ ! -z "$has_tables" ] ; then
        echo "Drop tables in database '$DB_NAME'..."
        $DB_CONNECT_COMMAND -h$DB_HOST -e "
            USE \`$DB_NAME\`;
            SET FOREIGN_KEY_CHECKS = 0;
            SELECT DATABASE() FROM DUAL INTO @current_dbname;
            SET @tables = '';
            SET SESSION group_concat_max_len = 1000000;
            SELECT GROUP_CONCAT(table_schema, '.', table_name) INTO @tables
              FROM information_schema.tables
              WHERE table_schema = @current_dbname; -- specify DB name here.
            SET @tables = CONCAT('DROP TABLE ', @tables);
            PREPARE stmt FROM @tables;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET FOREIGN_KEY_CHECKS = 1;" 2>&1
        echo "Database refreshed."
    fi
fi
