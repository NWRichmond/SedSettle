# SedSettle
SedSettle interfaces with a digital mass balance for sediment grain size analysis via [settling tube](https://pubs.geoscienceworld.org/sepm/jsedres/article-abstract/54/2/603/97733/the-analysis-of-grain-size-measurements-by-sieving). To use SedSettle, you must have a settling tube, a digital mass balance capable of reporting mass to a computer, and a computer running MATLAB (all versions post-2005 should work). 

SedSettle is written in MATLAB and should function on Windows 10, MacOS, and Linux so long as the operating system can communicate with the mass balance. This code was tested using an OHAUS Adventurer AX622 Mass Balance on MacOS High Sierra and with CDM 2.08.28 WHQL Certified x86 (32-bit) drivers on Windows 10.

To use the code, open SettlingTubeInterface.m, and make sure that all directories in the SedSettle package are added to your MATLAB path.
