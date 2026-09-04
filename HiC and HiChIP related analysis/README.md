# HiC and HiChIP related analysis

`1.pepline_Hic_202607.sh`: 用于对Hi-C或HiChIP的原始数据进行上游分析，最后可以获取hic文件。

`2.HiCExplorer-HiC.sh`: 用于Hi-C的下游分析，主要依赖[HiCExplorer](https://hicexplorer.readthedocs.io/en/latest/index.html)。

`3.analysis_HiChIP_202608.sh`: 用于HiChIP的下游分析。

`4.calculate_Hic_counts_in_loops.py`: 在`2.HiCExplorer-HiC.sh`中用于分析两组之间差异的Hi-C loop。

`FitChIP configfile.rar`: `2.HiCExplorer-HiC.sh`和`3.analysis_HiChIP_202608.sh`中使用[FitChIP](https://ay-lab.github.io/FitHiChIP/html/usage/installation.html)分析的参数文件。

`hicPlotTADs track.rar`: `3.analysis_HiChIP_202608.sh`中hicPlotTADs作图所需要的track参数文件。

`loops.rar`: `2.HiCExplorer-HiC.sh`和`3.analysis_HiChIP_202608.sh`中使用[FitChIP](https://ay-lab.github.io/FitHiChIP/html/usage/installation.html)分析后获取的Hi-C或HiChIP loop。

===========================================================================================

`1.pepline_Hic_202607.sh`: Used for upstream analysis of Hi-C or HiChIP raw data to finally obtain a hic file.

`2.HiCExplorer-HiC.sh`: Used for downstream analysis of Hi-C, primarily relying on [HiCExplorer](https://hicexplorer.readthedocs.io/en/latest/index.html).

`3.analysis_HiChIP_202608.sh`: Used for downstream analysis of HiChIP.

`4.calculate_Hic_counts_in_loops.py`: Used in `2.HiCExplorer-HiC.sh` to analyze differential Hi-C loops between two groups.

`FitChIP configfile.rar`: Parameter files for analysis using [FitChIP](https://ay-lab.github.io/FitHiChIP/html/usage/installation.html) in `2.HiCExplorer-HiC.sh` and `3.analysis_HiChIP_202608.sh`.

`hicPlotTADs track.rar`: Track parameter files required for hicPlotTADs plotting in `3.analysis_HiChIP_202608.sh`.

`loops.rar`: Hi-C or HiChIP loops obtained after analysis using [FitChIP](https://ay-lab.github.io/FitHiChIP/html/usage/installation.html) in `2.HiCExplorer-HiC.sh` and `3.analysis_HiChIP_202608.sh`.
