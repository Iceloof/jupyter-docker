# jupyter-docker

## Config
set external dir as workspace in `build` file by replace `<your path>` to your workspace path
```
docker run --name jupyter --restart=always --network=host -p 8888:8888 -v <your path>:/home/jupyter jupyter
```

## Build and run
you can change docker run args in `build` file line 5
```
./build
```
