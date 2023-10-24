# Algorithms-of-the-Mind

**Course description**: This course introduces computational theories of psychological processes, with a pedagogical focus on perception and high-level cognition. Each week students learn about new computational methods grounded in neural and/or cognitive phenomena. Lectures introduce these topics conceptually; lab sections provide hands-on instruction with programming assignments and review of mathematical concepts. Lectures cover a range of computational methods across the fields of computational statistics, artificial intelligence, and machine learning including probabilistic programming, artificial neural networks, differentiable simulators, and sampling- and optimization-based inference methods. Students work through weekly lab sections, weekly reading responses, four homework assignments, in addition to a final paper or a computational modeling project. 

The course materials are partially publicly available in this repo. We aim to make all content publicly available. 


|          | Topic                                                                                    |
|----------|------------------------------------------------------------------------------------------|
| Class 1  | Introduction & course logistics                                                          |
| Class 2  | An origins story and the pillars of mental representations                               |
| Class 3  | Cognition and probability                                                                |
| Class 4  | Probability                                                                              |
| Class 5  | Statistical Estimation                                                                   |
| Class 6  | Generative models: Representing working models of the world with probabilistic programs  |
| Class 7  | Algorithms for inference: Markov chain Monte Carlo                                       |
| Class 8  | Algorithms for inference: Sequential Monte Carlo                                         |
| Class 9  | Vision as inverse graphics: graphics-based generative models                             |
| Class 10 | Composability of generative models                                                       |
| Class 11 | Intuitive physics: generative models with temporal kernels                               |
| Class 12 | Intuitive physics: physics-based generative models                                       |
| Class 13 | Extending the toolbox: Autodiff and differentiable generative models                     |
| Class 14 | Extending the toolbox: optimization for inference                                        |
| Class 15 | Extending the toolbox: Deep neural networks for learning to do inference                 |
| Class 16 | Efficient inference in the brain                                                         |
| Class 17 | Growing a mind: Bayesian learning of domain knowledge                                    |
| Class 18 | Human attention: Adaptive computation & goal-conditioned world models                    |
| Class 19 | Extending the toolbox: Generative models of agents; MDPs                                 |
| Class 20 | Thinking about others: computational social cognition                                    |
| Class 21 | Interfacing the physical and the social                                                  |
| Class 22 | Affective processing: generative models of how we feel                                   |
| Class 23 | Closing: Multi-level inquiry of mental representations across the mind and brain         |
| Class 24 | Project presentations                                                                    |



# Setup 

Follow the steps in the rest of this document to set up your computational environment for this course.

## Connect to Grace

Start by reading YCRC's tutorials https://docs.ycrc.yale.edu/clusters-at-yale/, including the section on Open On Demand (OOD) Web Portal https://docs.ycrc.yale.edu/clusters-at-yale/access/ood/.

Grace is the HPC cluster we will be using for this course. It's served and maintained by YCRC. 

(Now, there are a number of ways in which you can work on Grace. Here I'll describe the method I find most convenient -- follow along, or figure out your own method. And ask away if you run into any trouble.)

### Access to the Open On Demand (OOD) interface on Grace

OOD provides a graphical user interface. That's how we will be able to use Jupyter Notebooks on the cluster, which is the primary manner in which you will develop code and execute it in this course.

YCRC provided this course with a specific OOD server (which is different from the common URL listed on their webiste for Grace).

Go to the following URL for our class-specific OOD server and log in using your Yale credentials (you need to be either on-campus on Yale Secure or on the Yale VPN) https://psyc261.ycrc.yale.edu.

**Username:** `psyc261_[NETID]` (replace `[NETID]` with your Yale netid)

**Password:** your passpowrd associated with your Yale netid. 

#### Open a shell terminal using OOD

On the top menu row (blue banner), click "Clusters" and then click ">_Grace Shell Access".

You have landed on a login node on Grace with a shell terminal. 

Because we cannot do computation on a login node, we gotta get an interactive session on a compute node (see the tutorials linked above). But before, let's start a `tmux` session.

#### Open a tmux screen on your shell terminal

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

#### Start an interactive session on a compute note

Now you are ready to move to a compute node by starting an interactive session within your `tmux` screen:

```
# Allocate an interactive session on a compute node:
salloc -p day
```

(See the [getting started](https://docs.ycrc.yale.edu/clusters-at-yale/job-scheduling/) and [slurm](https://docs.ycrc.yale.edu/clusters-at-yale/job-scheduling/) tutorials on YCRC's tutorials.)

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

On the bottom of this output, the string on the right-hand-side of `@` symbol is the ID of the compute node you landed on when you requested a session. Record it and, from here on, replace all `[COMPUTE-NODE-ID]` with that. (Notice that, in my case, this string would have been `r904u07n02`).

## Clone this course repo

At your home directory on Grace:

```
cd ~
git clone https://github.com/CNCLgithub/Algorithms-of-the-Mind.git
cd Algorithms-of-the-Mind
```

(the command `cd ~` brings you to your home directory.)

### To download updates made to this repo as we go along in the semester

```
git fetch origin
git merge origin/main
```

Beyond the first usage as above, you can simply use the command `git pull` in the subsequent downloads. (The `git pull` does both `fetch` and `merge` in one go assuming the remote name `origin` and branch name `main`).

## Understand the Apptainer container 

(See class discussion/PDF of the slides for an intro to containers)

The container definition file is located at 

```
cd ~/Algorithms-of-the-Mind/container/base.def
```

The built container that we will be accessing when we use the Jupyther app is located at

```
/gpfs/gibbs/project/psyc261/shared/base.sif
```

**Side track:** If you wanna build the container yourself (assuming you are on a compute node):

```
cd ~/Algorithms-of-the-Mind/container
./build_container.sh
```
(you might need to give executable permission on this shell file before you can run the above command: `chmod +x ./build_container.sh`)

NOTE: Building a container takes a while.

## Fire the Jupyter app

On the top menu row (blue banner), click "Courses" and then click ">_PSYC261".

Launch a session using the interface (standard settings should be fine).

You (should) have arrived!: A Jupyter Notebook on your browser, being run on the HPC. Proceed to the folder of this repo (the `Algorithms-of-the-Mind` folder).

Happy model building!
