---
output:
  pdf_document: default
  html_document: default
---
# GT Introduction to Analytics Modeling - Week 9 HW

## Introduction
For this homework, we describe analytics models and data that could be used to make good recommendations to the retailer. More specifically, we attempt to answer the question: _How much shelf space should the company have to maximize their sales or their profit?_

Restrictions to incorporate are as follows:

1. For each product type, the retailer imposed a minimum amount of shelf space required, and a maximum amount that can be devoted.
2. The physical size of each store means there's a total amount of shelf space that has to be used.
3. The key is the division of that shelf space among the product types.

Additional items to consider are:

1. How to measure the effects.  
2. How to estimate the extra sales the company might get with different amounts of shelf space.

## Solution Summary
A summary of the models in this solution in the {given, use, to} format are as follows.  Note that more details are provdided in the next section. 

__Given__
Historical product sales data
Product dimension data
Retail space dimension data

__use__
an optimization model

__to__
estimate the amount of each product to place on the shelf

## Solution Description
This section provides a more detailed description and idea behind the summarized solution.

### Modeling
From an optimization perspective, this problem reminds me of the Diet problem we tackeled in week 7.  In the Diet problem, we have constraints in the form of an upper and lower bound on nutrition, and our goal is to minimize cost. Relating this to the retail space, we have upper and lower bound constraints in the form of maximum and minimum product usage, as well as a maximum in due to total available shelf space.  The cost aspect to the detail problem maps to value (or expected sales) in the retail problem.   

We can formulate the retail problem as follows:

$maximize \sum c_i \times v_i$

subject to 

$\sum c_i \le C$, $c_i \le Cmax$, $c_i \ge Cmin$

where $c_i is the capacity used for item $i$, $v_i$ is the value of item $i$, and $C$ represents the available capacity.  We also have $Cmin$ and $Cmax$ that represent the minimum and maximum constraint for hte products

To support this formulation, we need a method to estimate the value of a product per unit capacity. As described in the data section, we can use historical data to establish a baseline for each product.

### Measuring Effects
To measure the effects of a configuration, we can limit the number of configurations to a finite number (e.g. 3 configurations). We can then (randomly) sample these configurations so that we end up with different configurations at different stores.  With the configurations in place, sales can be tracked to provide data for validating our configurations.  The result is that we have sales values for each configuration.  We can then perform statistical tests to determine if there are differences in the sales values.  ANOVA is an example of one such test.

### Data
For this problem, we need to know shelf capacity as this serves as an upper bound on available capacity.  We also need capacity related values for the products.  We would expect this information to be readily available from the retailer and product vendor.  We can assume that we would not vary depth and height since in general, it wouldn't make sense to put a product behind another, nor would it useful to stack products on top of one another (on the same shelf).  Therfore, we only need to be concerned with a product width.

And finally we need product data that can be used to estimate sales as a function of the amount of the product on the shelf.  Assuming most of the products have been sold before, we can use historical data to determine a baseline using an averaging technique.  Since this is simply a baseline, this holds even if we don't have data on how much of the product was on the shelf. For new products, we estimate sales using data for similiar or even competing products.
