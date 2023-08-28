# Algorithms-of-the-Mind
Course materials for Algorithms of the Mind

# Connect Grace

Start by reading YCRC's tutorials https://docs.ycrc.yale.edu/clusters-at-yale/ and including their page on Open On Demand (OOD) Web Portal https://docs.ycrc.yale.edu/clusters-at-yale/access/ood/.

Now, there are a number of ways in which you can work on Grace. Here I'll describe the method I find most convenient -- follow along, or figure out your own method. And ask away if you run into any trouble.

## Access to the Open On Demand (OOD) interface on Grace

OOD provides a graphical-user-interface. That's how we will use Jupyter Notebooks, which is the primary manner in which you will develop code and execute it in this course.

Go to the following URL and log in using your Yale credentials (you need to be on the Yale VPN) https://ood-grace.ycrc.yale.edu/

### Open a shell terminal using OOD

On the top menu row, click "Clusters" -> ">_Grace Shell Access"

You have landed on a login node on Grace. However, we cannot do computation on a login node, so we gotta get an interactive session on a compute node.

### Open a tmux screen

When using a remote terminal, you are strongly recommended to use a screen manager, e.g., `tmux`, which allows you to note lose your terminal session due to connection failures or simply loggin out.

Read up on tmux https://docs.ycrc.yale.edu/clusters-at-yale/guides/tmux/

```
# create a new tmux session
tmux
```
or

```
# attach back an already existing session
tmux a -t0
```

(You can view the current active tmux sessions via: `tmux ls`)

### Start an interactive session on a compute note

Now you are ready to move to a compute node by starting an interactive session:

```
# Allocate an interactive session:
salloc -p day
```

This should lead to an output similar to the following

```
salloc: Pending job allocation 24871129
salloc: job 24871129 queued and waiting for resources
salloc: job 24871129 has been allocated resources
salloc: Granted job allocation 24871129
salloc: Waiting for resource configuration
salloc: Nodes r904u07n02 are ready for job
[NET-ID@r904u07n02.grace ~]$
```
On the bottom of this output, the string on the right-hand-side of @ is the ID of the compute node you landed. Record it and, from here on, replace all `[COMPUTE-NODE-ID]` with that. (In my case, this string is `r904u07n02`.

# Clone this repo

At your home directory on Grace:

```
git clone https://github.com/CNCLgithub/Algorithms-of-the-Mind.git
cd Algorithms-of-the-Mind
```

## To download updates made to this repo as we go along in the semester

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

# Start the container 

The following command launches a Jupyter notebook and serves it

```
# We give a custom `JULIA_DEPOT_PATH` so that we can add new packages locally
apptainer run --env "JULIA_DEPOT_PATH=./julia:/opt/julia" base.sif
```

Part of the output should include something like the following

```
[I 2023-08-28 09:59:31.939 ServerApp]     http://127.0.0.1:8888/lab?token=8a4554c1a14cd098d98f2e7a1c9b1f9bab1c06ebbc76e1dd
```

We will click on (or copy and paste on your browser's address line) this URL after creating an SSH tunnel (see below).

# Make an SSH tunnel

Now open a shell terminal on your own local computer (e.g., `iterm` on Mac OS X)

Run the following command to make an SSH tunnel

```
ssh -NL localhost:8888:[COMPUTE-NODE-ID].grace.ycrc.yale.edu:8888 [NETID]@grace.hpc.yale.edu
```

while replacing `[COMPUTE-NODE-ID]` with your node's ID and `[NETID]` with your YALE net id.

# Connect to your Jupyter Notebook

Now, go back to your tmux screen and click on the link that starts with `http://127.0.0.1:8888`

You (should) have arrived!: A Jupyter Notebook screen in your `Algorithms-of-the-Mind` folder. 




