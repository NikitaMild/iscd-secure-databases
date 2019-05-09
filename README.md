# iscd-secure-databases

Assignments for my secure databases course.

## Prerequisites

Please download a mysql portable distribution and put it into `./mysql` folder.
`mysql-5.7` works, but other versions may work too.

You can download it [here](https://dev.mysql.com/downloads/file/?id=482726)
or from the [download page](https://dev.mysql.com/downloads/mysql/5.7.html)

## Running

Use `make build` to build the container.

Use `make` or `make run` to run the container.

### Old-fashioned way to run

Use `docker-compose build` to build the container. Watch out for warnings and errors!

Use `docker-compose up` to run the container with mysql server.
