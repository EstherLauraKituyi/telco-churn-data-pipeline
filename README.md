 Project Overview
This project applies System Thinking to the telecommunications sector. I built a complete lifecycle pipeline—moving from raw, "noisy" data ingestion to a predictive Random Forest model that identifies at-risk customers with 76.7% accuracy. 

 The "Engineering" Approach (Medallion Architecture)
Bronze (Ingestion): Migrated raw CSV records into a PostgreSQL staging layer. 
Silver (Transformation): Used deep-stack SQL (CAST, NULLIF, TRIM) to clean data and handle null values. 
Gold (Intelligence): Developed a Random Forest Classifier to assign a "Churn Probability Score" to every account. 

Key Business Insights
Month-to-Month volatility: Identified as the primary structural "fault" with a 42.7% churn rate. 
The Retention Driver: Technical support services correlate with a 60% reduction in churn.
