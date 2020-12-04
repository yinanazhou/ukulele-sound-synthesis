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
 Figure 1. Setting of Recording
 </div>
 
The first step of this project is to measure the body-to-air response of a ukulele. The setting of the recording is illustrated in Figure 1. The ukulele measured here is a general concert ukulele. The body-to-air response is recorded via the following steps: 

1. Suspend the ukulele on a guitar stand with a height-adjustable neck so that nothing touches the body; 
2. Damp the strings; 
3. Place a R$\emptyset$DE NT1-A microphone 0.5 meters right in front of the soundhole; 
4. Use a drumstick to tap on the bridge in the horizontal direction, and record the sound;
5. Trim the audio to get the short tap part. 
### Timbre Control Filter
Figure 2 shows the spectrum of the real ukulele sound at G4 in the range of $0Hz$ to $6kHz$. It is worth noting that the signal nearly has no frequency components above $4kHz$. Thus, a timbre control filter with low-pass characteristics is added before the excitation signal is fed into the pluck position filter. The low-pass filter designed here is a Chebyshev filter.

<div align="center">
<img src="https://github.com/yinanazhou/ukulele-sound-synthesis/blob/master/figure/4th_real_spectrum.png" width=30%>
Figure 2. Spectrum of Ukulele at G4
 </div>
 
### Pluck Position Filter
The pluck position filter $P(z)$ simulates the standing wave pattern that the $n$th partial and its integer multiples will not be excited if the string is plucked at $1/n$th the distance from one end. The general pluck position of a ukulele is around the soundhole, which is approximately $8cm$ from the bridge. The string length of a concert ukulele is $38cm$. Therefore, $n$ is rounded to $5$ here. 
<div align="center">
<img src="https://github.com/yinanazhou/ukulele-sound-synthesis/blob/master/figure/4th_real_spectrum.png" width=30%>
Figure 3. Pluck Position Filter
 </div>

The pluck position filter is actually a feedforward comb filter. It can create $M$ notches at equal frequency intervals of $f_s/M$Hz, where $f_s$ is the sample rate. Thus, to simulate the pluck position, the signal is fed into the comb filter of order $M$ shown in Figure 3. The order $M$ is a fraction of the total delayline length. The transfer function can be expressed as $P(z)=b_0+b_Mz^{-M}.$
### Digital Waveguide Model
Digital waveguide model simulates the vibration of a string from a physics standpoint (Figure 4). It consists of two delaylines that represent two opposite travelling waves. The string of a ukulele has terminated ends on both sides. The displacements of the travelling waves will be inversed at both ends. Thus, the values are multiplied by the reflection coefficients after the waves reach the end. Here, the reflection coefficients are set to $-1$.
<div align="center">
<img src="https://github.com/yinanazhou/ukulele-sound-synthesis/blob/master/figure/dw_org.png.png" width=30%>
Figure 4. Original Digital Waveguide Model
 </div>

In addition, a string attenuation filter is needed so that the string vibration could decay over time. In this project, I used a one-zero filter, whose transfer function is $G(z)=\rho[(1-S)+Sz^{-1}].$

In this filter, the loss factor $\rho$ controls the overall decay rate. It can be obtained with the desired decay time. In this project, the value is set to $0.995$ based on experiments to make the output not decay too slowly or too fast. However, the decay produced by $\rho$ is not frequency dependent. 

The stretch factor $S$ simulates the frequency-dependent damping effect. It is a value between $0$ and $1$, which is used to adjust the relative decay rate for high frequencies in contrast to low frequencies. Stretch factor $S$ is set to $0.5$ here, to get the fastest high-frequency decay. 
<div align="center">
<img src="https://github.com/yinanazhou/ukulele-sound-synthesis/blob/master/figure/digital_with_timbre.png" width=30%>
Figure 5. Lumped Digital Waveguide Model
 </div>

Moreover, the string attenuation filter can be lumped with the left multiplier (Figure 5). The transfer function of the string attenuation filter then becomes $G(z)=-\rho[(1-S)+Sz^{-1}].$
Now, filter $G(z)$ represents both losses and inversion that happen at the left end of the string. 

The total delay in the loop determines the frequency that corresponds to the pitch of the resulting signal. In this model, two delaylines provide a phase delay of $2N$ samples in total. The phase delay of the string attenuation filter is half a sample. Thus, the phase decay of the loop is $2N + 0.5$ samples. The desired phase decay can be expressed as $f_s/f_0$, where $f_0$ is the desired fundamental frequency of the output. Therefore, the delayline length $N$ can be expressed as $N=\frac{\frac{f_s}{f}+0.5}{2}$ samples.

One problem is that the length of the delayline has to be an integer. Thus, the delayline length must be rounded, which will cause tuning problems, especially for high frequencies. To address this problem, I implemented all-pass interpolation to allow a fractional delayline length.

The output is the sum of the two delaylines at a certain read location, in this case, the soundhole. The MATLAB script $playDW.m$ implements this model.
### Karplus Strong Algorithm
Owing to the LTI assumption, the two delaylines can be combined into one. Besides, two reflection coefficients can also be lumped together and cancel each other out. As a result, a delayline with double the length above and the original string attenuation filter are left in the feedback loop (Figure 6). 
<div align="center">
<img src="https://github.com/yinanazhou/ukulele-sound-synthesis/blob/master/figure/ks_timbre.png" width=30%>
Figure 6. Karplus Strong Algorithm
 </div>

The resulting model is an extended form of Karplus-Strong model. The original Karplus-Strong model implements a two-point average to simulate the frequency-dependent decay. The transfer function is $H(z) = \frac{1}{2}(1+z^{-1})$. The transfer function $H(z)$ is the same as $G(z)$ when $\rho$ is set to $1$. In this project, I set $\rho$ the same value as above. Thus, the transfer function becomes $G_{ks}(z)=0.995\times\frac{1}{2}(1+z^{-1})$, which is the equivalence of the original string attenuation filter in the digital waveguide model.

Another difference is that the original Karplus-Strong algorithm feeds white noises into the delayline. In the case of the ukulele, I used the filtered body-to-air response as the input of the delayline.

The MATLAB script $playKS.m$ employs the method described above.

### MIDI Implementation
MIDI Implementation

## Reference
<div id="refer-anchor-1"></div>

- [1] [Digital synthesis of plucked-string and drum timbres](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.144.5585&rep=rep1&type=pdf)
