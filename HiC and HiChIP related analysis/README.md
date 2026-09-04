# HiC and HiChIP related analysis

`1.pepline_Hic_202607.sh`: 用于对Hi-C或HiChIP的原始数据进行上游分析，最后可以获取hic文件。

`2.HiCExplorer-HiC.sh`: 用于Hi-C的下游分析，主要依赖[HiCExplorer](https://hicexplorer.readthedocs.io/en/latest/index.html)。

`3.analysis_HiChIP_202608.sh`: 用于HiChIP的下游分析。

`4.calculate_Hic_counts_in_loops.py`: 在`2.HiCExplorer-HiC.sh`中用于分析两组之间差异的Hi-C loop。

`FitChIP configfile.rar`: `2.HiCExplorer-HiC.sh`和`3.analysis_HiChIP_202608.sh`中使用[FitChIP](https://ay-lab.github.io/FitHiChIP/html/usage/installation.html)分析的参数文件。

`hicPlotTADs track.rar`: `3.analysis_HiChIP_202608.sh`中hicPlotTADs作图所需要的track参数文件。

`loops.rar`: `2.HiCExplorer-HiC.sh`和`3.analysis_HiChIP_202608.sh`中使用[FitChIP](https://ay-lab.github.io/FitHiChIP/html/usage/installation.html)分析后获取的Hi-C或HiChIP loop。

===========================================================================================
