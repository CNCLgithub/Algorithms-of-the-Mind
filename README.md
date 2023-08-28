# Algorithms-of-the-Mind
Course materials for Algorithms of the Mind

# Connecting to and using grace

Start by reading YCRC's tutorials https://docs.ycrc.yale.edu/clusters-at-yale/

Allocate an interactive session: `salloc -p day`


# Cloning this repo

At your home directory on Grace:

```
git clone https://github.com/CNCLgithub/Algorithms-of-the-Mind.git
cd Algorithms-of-the-Mind
```

# To download updates made to this repo

```
git fetch origin
git merge origin/main
```

Beyond the first usage as above, you can use the `git pull` command which does both commands at one: `git pull origin main`

# Copy the Apptainer container 

```
cp /home/iy42/class_container/base.sif ~/Algorithms-of-the-Mind/container
```

or if you wanna build it yourself (assuming you are on a compute node):

```
cd ~/Algorithms-of-the-Mind/container
./build_container.sh
```
(you might need to give executable permission on this file before you can run the above command: `chmod +x ./build_container.sh`

