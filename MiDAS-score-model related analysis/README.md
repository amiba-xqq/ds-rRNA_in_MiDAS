# MiDAS-score-model related analysis

首先我们使用R脚本获取用于LightGBM模型训练的原始数据`GDSC_TPM_input_data.csv`，具体的训练代码见于`4.model_building.LightGBM2.0.ipynb`,在jupyter notebook上运行该脚本依赖Python3(>= 3.8)，并需要下面的依赖库：
* numpy(2.2.6)
* pandas(3.0.5)
* lightgbm(4.7.0)
* scikit-learn(1.9.0)
* scipy(1.18.0)
* tqdm(4.66.4)
* optuna(4.9.0)
* shap(0.52.0)
* matplotlib(3.11.1)
* joblib(1.4.2)
* statsmodels(0.14.6)

`1.input_data_process.R`：分析GDSC数据库中获取的药物敏感性和突变相关数据，最后获得用于模型训练的输入数据。

`2.test_data_CCLE.R`：分析CCLE数据库中获取的药物敏感性和突变相关数据，最后获得用于验证模型的数据。

`3.TPM_GDSC.R`：分析GDSC数据库中的基因表达相关数据，最后获得所有MiDAS region gene的TPM值。

`4.model_building.LightGBM2.0.ipynb`: LightGBM模型训练的jupyter notebook脚本。

`GDSC_TPM_input_data.csv`: `3.TPM_GDSC.R`最后得到的用于中介效应分析的输入数据。

`GDSC_input_data.2.0.csv`: `1.input_data_process.R`最后得到的用于模型训练的输入数据。

`MiDAS_regions.xls`: MiDAS发生区域及相关基因，数据来自于文章：[Macheret M, Bhowmick R, Sobkowiak K, et al. High-resolution mapping of mitotic DNA synthesis regions and common fragile sites in the human genome through direct sequencing. Cell Res. 2020](http://doi.org/10.1038/s41422-020-0358-x)

`MiDAS_score_model.LightGBM2.0.lgb`:`4.model_building.LightGBM2.0.ipynb`最后训练获得的MiDAS-score-model模型文件。

`model_save.LightGBM2.0.joblib`：`4.model_building.LightGBM2.0.ipynb`保存的所有python对象数据。

`test_CCLE.csv`: `2.test_data_CCLE.R`最后获取的来自于CCLE数据库的用于验证模型的输入数据。

===========================================================================================

First, we use an R script to obtain the raw data `GDSC_TPM_input_data.csv` for LightGBM model training. The specific training code can be found in `4.model_building.LightGBM2.0.ipynb`. Running this script in a Jupyter Notebook requires Python 3 (>= 3.8) and the following dependencies:
* numpy(2.2.6)
* pandas(3.0.5)
* lightgbm(4.7.0)
* scikit-learn(1.9.0)
* scipy(1.18.0)
* tqdm(4.66.4)
* optuna(4.9.0)
* shap(0.52.0)
* matplotlib(3.11.1)
* joblib(1.4.2)
* statsmodels(0.14.6)

`1.input_data_process.R`: Analyzes drug sensitivity and mutation-related data obtained from the GDSC database, ultimately producing the input data for model training.

`2.test_data_CCLE.R`: Analyzes drug sensitivity and mutation-related data obtained from the CCLE database, ultimately producing the data used for model validation.

`3.TPM_GDSC.R`: Analyzes gene expression-related data from the GDSC database, ultimately yielding the TPM values for all MiDAS region genes.

`4.model_building.LightGBM2.0.ipynb`: Jupyter Notebook script for LightGBM model training.

`GDSC_TPM_input_data.csv`: The input data obtained from `3.TPM_GDSC.R`, intended for mediation effect analysis.

`GDSC_input_data.2.0.csv`: The input data obtained from `1.input_data_process.R`, intended for model training.

`MiDAS_regions.xls`: MiDAS occurring regions and related genes, with data sourced from the article: [Macheret M, Bhowmick R, Sobkowiak K, et al. High-resolution mapping of mitotic DNA synthesis regions and common fragile sites in the human genome through direct sequencing. Cell Res. 2020](http://doi.org/10.1038/s41422-020-0358-x)

`MiDAS_score_model.LightGBM2.0.lgb`: The MiDAS-score-model model file obtained from training in `4.model_building.LightGBM2.0.ipynb`.

`model_save.LightGBM2.0.joblib`: All Python object data saved by `4.model_building.LightGBM2.0.ipynb`.

`test_CCLE.csv`: The input data for model validation obtained from the CCLE database through `2.test_data_CCLE.R`.
