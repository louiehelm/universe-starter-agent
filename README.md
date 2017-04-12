# High performance GRU-A3C agent

- 80% performance increase over the current LSTM-based A3C starter agent on `PongDeterministic-v3` environment.

- 20% higher throughput in all Atari environments.

- 10-100% data-efficiency increase in various Atari environments. This boost is not well-characterized or well-tuned yet.

- 3 small, initial hyperparameter changes extend these gains even more.

- Using recently added NADAM optimizer vs ADAM

- GRU-based RNNs appear both more stable and more tolerant of a wider hyperparameter space than LSTMs for discrete RL tasks.

- Research cycles were shortened 30% more by MKL-optimized [`manjaro-ml-dotfiles`](https://github.com/louiehelm/manjaro-ml-dotfiles). This improves upon the recommended `universe` dev environment of `ubuntu` + `anaconda`.


## New GRU-A3C Agent (~3x faster @ Atari Pong)


`python train.py --num-workers 8 --env-id PongDeterministic-v3 --visualise --log-dir /tmp/pong`

GRU-A3C can solve `PongDeterministic-v3` in under **30 minutes** on a high-end Mac (vs **2 hours** for the original starter agent). To solve `PongDeterministic-v3` in 30 minutes before, the LSTM-based agent required 2x as many agents, runing on 4x as many cores, all at higher clock speeds.

![pong](http://i.imgur.com/QphU60g.png "GRU Pong")


This smaller pool of agents can also solve `PongDeterministic-v3` with fewer total frames (~900k vs 2.5-3.2M). Data efficiency gains from GRU-based A3C agents need more characterization but definitely appear significant.


# Major Changes

* Replace LSTMs in A3C model with [more principled GRUs](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)
* RNN switched to time-major data format to avoid two extra transposes per step


# Minor Changes

* 100% higher learning rate with slower decay
* ADAM optimizer -> [NADAM optimizer](https://github.com/tensorflow/tensorflow/commit/86d3891ba6612552347beaabe27edac11f5758d7)
* Local steps increased 20 -> 30
* 10% dropout
* Asyncronous visualiser


GRUs appear less overwhelmed by higher learning rates and more resilient to a wider range of hyperparams in general.

Google recently accepted my NADAM patches into TensorFlow. It tends to converge faster and more stablely than ADAM in all but pathological cases. GRU-A3C works great with ADAM, but why not use the more principled, higher performance optimizer?

Local steps can scale both lower and higher with GRU-based agents:

- 15 provides less actions per second but higher data efficiency

- 30 provides more actions per second with slightly worse data efficiency



These hyperparameter changes are not exhaustively tuned, nor the prime drivers of higher performance. They mostly serve to demonstrate a new set of learning parameters that was previously unworkable with LSTMs but which appears both well-behaved and high performance with GRUs in many environments.



## Terminal Visualiser

![vis](http://i.imgur.com/oFuBqJP.jpg "Terminal Visualiser")

Display 2 running agents: `./term_vis.sh 2` 

There is also a small code patch to allow asyncronous visualisation via bash script (requires w3m-img)

* Visualisation can be switched on / off even on live training runs
* Uses 60% less CPU per frame vs pyglet when actively displaying
* Workers spend 0% CPU updating visualisation unless  the script is actually running
* Can visualise over SSH via X-Forwarded terminals (e.g., ssh -L localhost:12345:localhost:12345 -Ycv -i <.pem file> ubuntu@xxx.xxx.xxx.xxx) [see above]
