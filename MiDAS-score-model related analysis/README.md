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

`1.input_data_process.R`：获取
