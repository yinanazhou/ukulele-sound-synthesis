## Realization and Comparison on Ukulele Sound Synthesis Models
### MUMT 618 Final Project

This project synthesizes sound using digital waveguide model and Karplus-Strong algorithm.

- ukulele.m calls playDW.m, playDW.m and playmidi.m. It has two features:
  1. Generate sample note;
  2. Play MIDI file.  
  
&emsp;&emsp;The user can choose desired fundamental frequency，specify model, change MIDI files, and designate the name of file to be saved.
When inputting filenames, quotation marks cannot be omitted.

- playDW.m is a basic implementation of digital waveguide model. The parameters are sampling rate, desired fundamental frequency, samples to count, body-to-air response of the string instrument, and velocity.

- playDW.m is a basic implementation of Karplus-Strong algorithm. The parameters are sampling rate, desired fundamental frequency, samples to count, body-to-air response of the string instrument, and velocity.

- playmidi.m is a function that extract MIDI information and call playDW.m or plaKS.m to generate sounds.

- lowp.m implements the lowpass filter, which is used as the timbre control filter in this project.

- spec.m is a function to draw spectrograms of the signal.

- BR.wav is the recorded body-to-air response of a concert ukulele.
