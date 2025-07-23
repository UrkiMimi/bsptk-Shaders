# bsptk-Shaders

## THESE MAY NOT WORK ON VIVIFY MAPS
Shaders that I've made for BSPTK. The majority of them were made with Amplify and may contain some internal code leftovers from the port. 

**You can use these shaders with custom models [Ex. Vivify maps, Custom Sabers] though be warned you may run into some problems due to the Beat Saber's modern bloomfog implementation not defining gamma correction. Theses shaders aren't stereo fixed properly meaning that bloomfog will not render in `SinglePass` or `SinglePass-Instanced`.**

## Shader progress
Almost all shaders here are recreated/fixed. There are some inconsistencies like BlueNoise being omitted and mirrors being slightly broken. 0.12+ spectrograms haven't been recreated yet.

Some shaders like the ParameticBox shader are omitted since they are decompiled [here.(OpenShaders-0.11.2)](https://github.com/whatdahopper/OpenShaders-0.11.2) 


# Credits
- [QosmeticsUnityProject](https://github.com/Qosmetics/UnityProject) for slice.cginc
- [BeatSaberShaderTools](https://github.com/whatdahopper/BeatSaberShaderTools) for Bloomfog.cginc
