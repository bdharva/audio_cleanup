# audio_cleanup

This script uses several Sound eXchange (SoX) effects in combination to normalise and trim voice recordings that may have been recorded using different microphones, with differing background noise etc.

## Setup

* Install SoX (Documentation & download: http://sox.sourceforge.net/)
* Locate the installation location for SoX nad place the .sh script in that same directory
* Open terminal and add the following entry to your .bash_profile: `alias cleanup="/usr/local/bin/cleanup.sh"`

## Usage

With the setup out of the way, you can now use the audio cleanup script with `cleanup <file in> <file out>`, where `<file in>` is the audio file you'd like to clean up and `file out` is how/where you'd like the output to audio file to be named and saved.

If you're working with a master file of multiple voice clips, you'll first need to break them apart. Record a list of the breakpoints you'd like to use and then repeatedly run `sox infile outfile trim starttime =endtime` on the source file to produce all of the output files you need for the individual audio clips.

## Understanding the Script

You'll probably want to mess with some of the values in the script to tune it to your needs. Here's a brief overview of the SoX effects used in the script. For more/better details, check out [the SoX documentation](http://sox.sourceforge.net/sox.html).

* `remix`
  * Performs a mix-down of all input channels to mono
* `highpass`
  * Follows the form `highpass n` where `n` is a frequency in Hz
  * Applies a high-pass filter of the specified frequency
* `norm`
  * Alias for `gain -n`
  * Normalises the audio to 0dB FSD if no argument is provided
  * Arguments:
    * `-n`, where `n` is in decibels, will normalize to the specified amount below 0dB FSD
* `compand`
  * Follows the form `compand attack1,decay1 soft-knee-dB:in-dB1,out-dB1,...,in-dBn,out-dBn gain initial-volume-dB delay`
  * Attack and decay are in seconds, with attack typically less than decay
  * The soft knee dB value rounds the points where adjacent segments of transfer function meet
  * The list of input values must be in increasing order and are specified in dB relative to the maximum possible signal amplitude.
  * [This is a great write-up](https://sourceforge.net/p/sox/mailman/sox-users/thread/6BD30DC3-1EB7-4B3B-B866-C0777B464A3A%40senortoad.com/#msg23427259) that dives into the intricacies of `compand` in more clarity and detail than I will even bother to attempt here.
* `vad`
  * Voice activity detector
  * Attempts to trim silence and background sounds from the ends of the audio.
  * Can only trim from the front, so the audio must be reversed to trim from the back.
  * Options:
    * -T: time constant (seconds) used to help ignore short bursts of sound
    * -p: amount of audio (Seconds) to preserve before trigger point
    * -t: measurement level used to trigger activity detection
* `fade`
  * Follows the form `fade n` where `n` is a duration in seconds
  * Applies a fade effect of the specified duration to the beginning and the end of the audio clip
* `reverse`
  * Flips the audio clip (good for using `vad` to trim silence at the end and to flip back)
