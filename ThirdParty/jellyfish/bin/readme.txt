This directory contains the following built versions of jellyfish:

   jellyfish_x64_api71.pyd - Built using the 64 bit MSVC compiler packaged with the
                             Windows 7.1 API.  To be used with 64 bit Python 3.3 and
                             higher.


Copy the appropriate build for your installation up to the parent directory and rename it
to jellyfish.pyd.

The following directions describe how jellyfish_x64_api71.pyd was built.  Instructions
will need to be tweaked for other versions.  Most of this was derived from
https://github.com/cython/cython/wiki/64BitCythonExtensionsOnWindows:

   - Download GRMSDKX_EN_DVD.iso from Microsoft at
     https://www.microsoft.com/en-us/download/details.aspx?id=8442

   - Mount the ISO

   - Install the SDK.  Only the Windows Headers and Libraries, Tools, and Visual C++
     Compilers options under Windows Native Code Development were selected.  Also, the
     Visual C++ 2010 Redistributables were not uninstalled as the above cited article
     recommends.

   - Open the Windows SDK 7.1 Command Prompt from the Start Menu

   - Type "set DISTUTILS_USE_SDK=1"

   - Type "setenv /x64 /release".  This should cause the text on the screen to change
     color from yellow to green.

   - Change directory to the jellyfish source code directory

   - Compile the jellyfish code using "\python33\python setup.py build_ext", assuming
     Python is installed in "\python33".

   - If successful, a pyd file should have been created in
     jellyfish\source\build\lib.win-amd64-3.3.  To test, change directory to this folder,
     open a Python command prompt (using "\python33\python", again, assuming Python
     Python is installed in "\python33", type "import jellyfish", followed by
     jellyfish.levenshtein_distance('jellyfish', 'smellyfish').  If all is well, the
     number 2 should be printed to your console.


To include this pyd file in your project, simply reference the extension in your Python
code using something akin to

   "import .. ThirdParty.jellyfish.bin.jellyfish_x64_api71 as jellyfish"
   
The path may need to be tweaked depending upon the relative location of the project to
the jellyfish bin directory.
