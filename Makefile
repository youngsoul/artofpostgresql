# @ suppresses the normal 'echo' of the command that is executed.
# - means ignore the exit status of the command that is executed (normally, a non-zero exit status would stop that part of the build).
# + means 'execute this command under make -n' (or 'make -t' or 'make -q') when commands are not normally executed.

# Containers ids
db-id=$(shell docker ps -a -q -f "name=artofpostgressql-db")

# Run docker containers
run:
	@docker-compose -f docker-compose.yml up

run-db:
	@docker-compose -f docker-compose.yml up db

# restart containers with a stop then run
restart: stop run

# Stop docker containers, but not remove them nor the volumes
stop:
	@docker-compose stop
stop-db:
	-@docker stop $(db-id)

# Stop docker containers, remove them AND the named data volumes
down:
	@docker-compose down -v


# Remove docker containers
rm-db:
	-@docker rm $(db-id)


shell-db:
	@docker exec -it $(db-id) bash

volumes:
	@docker volume ls


#make volname=books_postgres_data remove-volume
remove-volume:
	@docker volume rm $(volname)
