## Realization and Comparison on Ukulele Sound Synthesis Models
### MUMT 618 Final Project

## Abstract
The goal of this project is to build and compare different models that synthesize ukulele sound. The body and air response of a ukulele is first measured. I then implemented both Karplus-Strong algorithm and digital waveguide model. To improve the result, a timbre control filter and a pluck position filter are added before the input signal is fed into the loop. The results of the two methods are compared in terms of spectrum and spectrogram. The effects of different summation location in digital waveguide model are also studied. Finally, I wrote a script to play MIDI files using the generated ukulele sound. 

## Introduction
Ukulele is getting increasingly popular due to its small size and its easiness to learn. Musicians and music enthusiasts can use synthesized ukulele sounds to reduce the cost of music production. Another advantage of synthesized sound is that it has unlimited frequency range. This project implements two algorithms to produce ukulele sound.

Many techniques have been developed to generate musical sound. In 1983, Karplus-Strong (KS) algorithm was first proposed [<sup>1</sup>](#refer-anchor-1). This simple and efficient algorithm produces a rich and natural plucked-string sound. Julius Smith and David Jaffe then explained its relationship to physics and proposed several extensions of the method [<sup>2</sup>](#refer-anchor-2). Later, Julius Smith introduced the digital waveguide theory based on physics [<sup>3</sup>](#refer-anchor-3). In 1998, Matti Karjalainen and others showed the derivation from digital waveguide to an extension of Karplus-Strong algorithm [<sup>4</sup>](#refer-anchor-4).

The first aim of this project is to build a model that can generate ukulele sound, and to play a MIDI file with it. The second aim of this project is to compare the results of Karplus-Strong algorithm and digital waveguide model. Although the two methods are equivalent with the linear and time-invariant (LTI) assumption, the resulting sounds are slightly different. The results of different summation location in digital waveguide model are also compared. The spectrums and spectrograms are analysed to evaluate the similarity and difference. 

## Methodology
### Body-to-Air Response
The classic model of plucked string instruments includes four components: excitation, waveguide, body response, and air response \cite{gary:01}. Due to the LTI assumption, body and air response can be commuted together and used as an excitation table. 
<div align="center">
<img src="https://github.com/yinanazhou/ukulele-sound-synthesis/blob/master/figure/recording.jpg" width=50%>
 </div>


The first step of this project is to measure the body-to-air response of a ukulele. The setting of the recording is illustrated in \figref{recording}. The ukulele measured here is a general concert ukulele. The body-to-air response is recorded via the following steps: 

## Reference
<div id="refer-anchor-1"></div>

- [1] [Digital synthesis of plucked-string and drum timbres](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.144.5585&rep=rep1&type=pdf)
