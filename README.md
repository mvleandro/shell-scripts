# Shell Script Repository

This repository contains various shell scripts aimed at reducing toil tasks and automating processes.

## Description

The shell scripts in this repository are designed to simplify common tasks and automate repetitive processes. They can be used to manage Kubernetes clusters, perform system administration tasks, and more.

## Scripts

- `check_kube_state.sh`: Script to check the state of Kubernetes resources.

## Getting Started

To use the scripts in this repository, clone it to your local system, and ensure you have the necessary permissions to execute them.

```bash
git clone git@github.com:mvleandro/shell-scripts.git
cd shell-scripts
chmod +x *.sh
```

## Running the Scripts

### check_kube_state.sh
To run the check_kube_state.sh script with Kubernetes context parameters, use the following command format:

```bash
./check_kube_state.sh context1 [context2] ...
```

Example:
```bash
./check_kube_state.sh my-kube-context production-kube-context
```
This will check for unhealthy pods and resources in the Kubernetes clusters associated with my-kube-context and production-kube-context.

## Makefile options
To learn about all the available options and how to run the scripts using the Makefile, you can use the make help command. This will display a list of all the commands you can use, along with a brief description of what they do.

Simply open your terminal, navigate to the root directory of this repository, and run:

```bash
make help
```


## Contributing
We welcome contributions! Please feel free to submit a pull request or open an issue if you have any suggestions or find any bugs.

## License
This project is licensed under the [License](LICENSE)  file in the root directory of this source tree.
