# jupyter-docker

## Build and run
set external dir as workspace in `build` file by replace `<your path>` to your workspace path
```
docker build -t jupyter .
docker run --name jupyter --restart=always --network=host -p 8888:8888 -v <your path>:/home/jupyter jupyter
```
