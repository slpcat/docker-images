#!/bin/bash

set -e

if [[ -z "${DB_HOST}" ]]; then
    echo "No DB_HOST Provided. Exiting."
    exit 1
fi

if [[ -z "${DB_USER}" ]]; then
    echo "No DB_USER provided. Assuming 'root'"
    DB_USER="root"
fi

if [[ -z "${DB_PASSWORD}" ]]; then
    echo "No DB_PASSWORD provided. Exiting"
    exit 1
fi

if [[ -z "${DB_NAME}" ]]; then
    echo "No DB_NAME provided. Exiting"
    exit 1
fi

if [[ -z "${BACKUP_DIR}" ]]; then
    echo "No BACKUP_DIR defined. Using /backups"
    BACKUP_DIR=/backups
fi


if [[ ! -z "${S3_ACCESSKEY}" ]]; then
    echo "S3 Support recognized, checking secret variable"
    if [[ ! -z "${S3_SECRET}" ]]; then
      echo "S3 Secret defined. We save backups from ${BACKUP_DIR} to s3 as well."
      S3_SUPPORT=1
    fi
fi

if [[ ! -d "${BACKUP_DIR}" ]]; then
   echo "Creating backup dir: ${BACKUP_DIR}"
   mkdir -p "${BACKUP_DIR}"
fi

exec mydumper --compress -h ${DB_HOST} -u ${DB_USER} -p ${DB_PASSWORD} -B ${DB_NAME} -o ${BACKUP_DIR}/${DB_NAME}-$(date +%d-%b-%y)
