# Superstore SQL Analysis

A SQL analysis of 9,994 retail orders from the Superstore dataset, answering:
1. Top 10 customers by lifetime sales value
2. Sub-Categories with declining year-over-year profit
3. Average shipping time by shipping mode
4. Most profitable city in each region

Built using SQLite — joins, CTEs, and window functions.
## Key Findings
- **Sean Miller** is the top lifetime customer at **$25,043** in total sales — about $6,000 ahead of the next-highest customer
- **Tables** had the sharpest profit decline of any sub-category, worsening from a $2,951 loss to an $8,141 loss in 2017
- Shipping speed scales almost exactly with service tier — Same Day ships almost instantly, while Standard Class averages about 5 days
- **New York City** drives more East region profit than any other city in the dataset — over **$62,000**, more than double the next-highest city (Los Angeles)
