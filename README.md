# Algorithms-of-the-Mind
Course materials for Algorithms of the Mind

Follow the steps in the rest of this document to set up your coding and computation environment for this course.

# Connect to Grace

Start by reading YCRC's tutorials https://docs.ycrc.yale.edu/clusters-at-yale/, including the section on Open On Demand (OOD) Web Portal https://docs.ycrc.yale.edu/clusters-at-yale/access/ood/.

Grace is the HPC cluster we will be using for this course. It's served and maintained by YCRC. 

(Now, there are a number of ways in which you can work on Grace. Here I'll describe the method I find most convenient -- follow along, or figure out your own method. And ask away if you run into any trouble.)

## Access to the Open On Demand (OOD) interface on Grace

OOD provides a graphical user interface. That's how we will be able to use Jupyter Notebooks on the cluster, which is the primary manner in which you will develop code and execute it in this course.

YCRC provided this course with a specific OOD server (which is different from the common URL listed on their webiste for Grace).

Go to the following URL for our class-specific OOD server and log in using your Yale credentials (you need to be on the Yale VPN) https://psyc261.ycrc.yale.edu.

Username: `psyc261_[NETID]` (replace `[NETID]` with your Yale netid)
Password: your passpowrd associated with your Yale netid. 

### Open a shell terminal using OOD

On the top menu row (blue banner), click "Clusters" and then click ">_Grace Shell Access".

You have landed on a login node on Grace with a shell terminal. 

Because we cannot do computation on a login node, we gotta get an interactive session on a compute node (see the tutorials linked above). But before, let's start a `tmux` session.

### Open a tmux screen on your shell terminal

When using a remote terminal, you are strongly recommended to use a screen manager, e.g., `tmux`, which allows you to not lose your terminal session due to connection failures or simply logging out. It is like being able to put your remote terminal session into sleep mode (instead of shutting it up and re-starting each time you need it). 

Read up on `tmux` https://docs.ycrc.yale.edu/clusters-at-yale/guides/tmux/

Now follow along to create a new tmux session on your shell terminal (notice that we are still on the initial login node).

```
# create a new tmux session
tmux
```

or, if you have already started a `tmux` session, connect back to it again:

```
# attach back an already existing session
tmux a -t0
```

(You can view your currently active tmux sessions via: `tmux ls`)

### Start an interactive session on a compute note

Now you are ready to move to a compute node by starting an interactive session within your `tmux` screen:

```
# Allocate an interactive session on a compute node:
salloc -p day
```

(See the getting started and slurm tutorials on YCRC's tutorials.)

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

On the bottom of this output, the string on the right-hand-side of `@` symbol is the ID of the compute node you landed on when you requested a session ([slurm](https://docs.ycrc.yale.edu/clusters-at-yale/job-scheduling/) did it). Record it and, from here on, replace all `[COMPUTE-NODE-ID]` with that. (Notice that, in my case, this string would have been `r904u07n02`).

# Clone this course repo

At your home directory on Grace:

```
cd ~
git clone https://github.com/CNCLgithub/Algorithms-of-the-Mind.git
cd Algorithms-of-the-Mind
```

(the command `cd ~` brings you to your home directory.)

## To download updates made to this repo as we go along in the semester

```
git fetch origin
git merge origin/main
```

Beyond the first usage as above, you can simply use the command `git pull` in the subsequent downloads. (The `git pull` does both `fetch` and `merge` in one go assuming the remote name `origin` and branch name `main`).

# Copy the Apptainer container 

(See class discussion/PDF of the slides for an intro to containers)

```
cp /home/iy42/class_container/base.sif ~/Algorithms-of-the-Mind/container
```

or if you wanna build it yourself (assuming you are on a compute node):

```
cd ~/Algorithms-of-the-Mind/container
./build_container.sh
```
(you might need to give executable permission on this file before you can run the above command: `chmod +x ./build_container.sh`)

NOTE: Building a container takes a while.

# Fire the Jupyter notebook server using your container 

The following command launches a Jupyter notebook and serves it so that we can access it via browser

```
# In this command, we give a custom `JULIA_DEPOT_PATH` so that we can add new Julia packages locally
apptainer run --env "JULIA_DEPOT_PATH=./julia:/opt/julia" base.sif
```

Part of the output should include something like the following

```
[I 2023-08-28 09:59:31.939 ServerApp]     http://127.0.0.1:8888/lab?token=8a4554c1a14cd098d98f2e7a1c9b1f9bab1c06ebbc76e1dd
```

We will soon (but not just yet) click on (or copy and paste on your browser's address line) this URL after creating an SSH tunnel (see below).

# Create an SSH tunnel

Now open a shell terminal on your own local computer (e.g., `iterm` on Mac OS X)

Run the following command to make an SSH tunnel

```
ssh -NL localhost:8888:[COMPUTE-NODE-ID].grace.ycrc.yale.edu:8888 psyc261_NETID@grace.hpc.yale.edu
```

while replacing `[COMPUTE-NODE-ID]` with your node's ID and `NETID` with your YALE net id.

# Connect to your Jupyter Notebook

Now, go back to your `tmux` screen and click on the link we mentioned above, the one that starts with `http://127.0.0.1:8888`

You (should) have arrived!: A Jupyter Notebook screen in your `Algorithms-of-the-Mind` folder. 

Happy model building!



