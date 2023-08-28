# Algorithms-of-the-Mind
Course materials for Algorithms of the Mind

# Connecting to and using Grace

Start by reading YCRC's tutorials https://docs.ycrc.yale.edu/clusters-at-yale/ and including their page on Open On Demand (OOD) Web Portal https://docs.ycrc.yale.edu/clusters-at-yale/access/ood/.

Now, there are a number of ways in which you can work on Grace. Here I'll describe the method I find most convenient -- follow along, or figure out your own method. And ask away if you run into any trouble.

## Access to the Open On Demand (OOD) interface on Grace

OOD provides a graphical-user-interface. That's how we will use Jupyter Notebooks, which is the primary manner in which you will develop code and execute it in this course.

Go to the following URL and log in using your Yale credentials (you need to be on the Yale VPN) https://ood-grace.ycrc.yale.edu/

### Open a terminal using OOD

On the top menu row, click "Clusters" -> ">_Grace Shell Access"

You hs
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
(you might need to give executable permission on this file before you can run the above command: `chmod +x ./build_container.sh`)



