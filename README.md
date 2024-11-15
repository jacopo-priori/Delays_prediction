# Flight Delay Prediction Project

This project aims to train and develop a machine learning model to predict flight departure delays using selected features. We implemented various classification models, including K-Nearest Neighbors (KNN), Lasso Logistic Regression, Decision Trees, Random Forest, and XGBoost, with parameter tuning and cross-validation. After testing our models, we found that the XGBoost model yielded the best performance with an accuracy of 66%.

## Table of Contents
- [Abstract](#abstract)
- [Introduction](#introduction)
- [Dataset](#dataset)
- [Methodology](#methodology)
- [Results](#results)
- [Conclusion](#conclusion)
- [Installation and Usage](#installation-and-usage)
- [Appendix](#appendix)
- [Contributors](#contributors)

## Abstract
The objective of this project is to build a model that can predict if a flight will be delayed based on key flight information. Our models were trained on a subset of a 2015 dataset from Kaggle. Although the XGBoost model achieved an accuracy of 66%, further improvements could be made with access to additional external data sources to increase accuracy.

## Introduction
Each year, flight delays disrupt millions of passengers' travel plans, causing operational inefficiencies, crew shortages, and increased costs. Predicting delays in advance can provide early warnings to airlines and passengers, allowing them to better prepare. This project aims to develop a model that reliably predicts departure delays to mitigate these consequences.

While many delay prediction models show impressive accuracy on Kaggle, they often use data that isn't available until after a delay has occurred, leading to unrealistic predictions. Our approach avoids these pitfalls by focusing on predictors that offer genuine foresight into potential delays.

## Dataset
We used a subset of the 2015 flight delay dataset from Kaggle. Due to the large size of the original dataset, we performed a stratified sample to create a subset, resulting in similar accuracy with significantly reduced computational time. The full dataset (flights.csv) can be downloaded from Kaggle:

- [Kaggle Flight Delay Dataset](https://www.kaggle.com/datasets/usdot/flight-delays)

**Note**: Download `flights.csv` manually from Kaggle and place it in the repository directory to use the code.

### Key Variables
- **DEPARTURE_DELAY**: The number of minutes a flight is delayed. A negative value indicates early departure.
- **FLIGHT_DELAYED**: Binary variable indicating if the flight was delayed (1) or not (0).
- **ARRIVAL_DELAY**: The delay on arrival.
- **Other Variables**: Created to aid model performance, including `NUM_DEPARTURES`, `NUM_ARRIVALS`, and `DAY_OF_YEAR`.

### Data Preprocessing
Steps included:
1. Dropping irrelevant or inconsistent columns.
2. Handling missing values.
3. Creating binary variables for delay status.
4. Addressing data inconsistencies in airport codes.

## Methodology
Our project included five machine learning models with 5-fold cross-validation and parameter tuning:
1. **Lasso Logistic Regression**: Utilized for variable selection, optimized using different lambda values.
2. **K-Nearest Neighbors (KNN)**: Tested with k values ranging from 5 to 13.
3. **Decision Tree Classifier**: Tuned parameters like `max_depth`, `min_samples_split`, and `min_samples_leaf`.
4. **Random Forest Classifier**: Ensemble of decision trees, optimized with parameters `n_estimators` and `max_depth`.
5. **XGBoost Classifier**: The best-performing model with `learning_rate`, `max_depth`, and `n_estimators` tuned.

We defined a helper function, `evaluate_model_with_cv`, to automate the 5-fold CV, model training, and evaluation metric generation.

## Results
Among the models tested, **XGBoost** achieved the highest accuracy at **66.2%**, with the following optimal parameters:
- `learning_rate`: 0.2
- `max_depth`: 4
- `n_estimators`: 30

| Model             | Parameter(s)                | Accuracy | Precision | Recall | F1 Score |
|-------------------|-----------------------------|----------|-----------|--------|----------|
| Lasso Regression  | lambda: 0.001               | 63.1%    | 59.6%     | 63.1%  | 56.8%    |
| KNN               | neighbors: 8                | 65.6%    | 63%       | 65%    | 62%      |
| Decision Tree     | max_depth: 10, min_samples_leaf: 1 | 65.6%    | 64%       | 66%    | 63%      |
| XGBoost           | learning_rate: 0.2, max_depth: 4, n_estimators: 30 | **66.2%** | 65%       | 66%    | 62%      |
| Random Forest     | max_depth: 6, n_estimators: 30 | 64.9%    | 63%       | 65%    | 59%      |

The XGBoost model displayed moderate performance, with an AUC score of 0.66.

## Conclusion
XGBoost emerged as the best model for predicting flight delays. However, with a top accuracy of 66.2%, this model is still limited and may benefit from more feature-rich data for improved performance. Airlines could use a similar model combined with additional data sources to enhance prediction reliability.

## Installation and Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flight-delay-prediction.git
   cd flight-delay-prediction
