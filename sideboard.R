# Example data
library(ggplot2)

# Assuming 'expr_data' is a matrix of normalized expression values (rows = genes, columns = samples)
expr_data_log <- log2(exprs(gset) + 1)  # Log2 transform the data if necessary

# Convert to long format for ggplot2
expr_df <- as.data.frame(expr_data_log)
expr_long <- reshape2::melt(expr_df)

# Plot the density
ggplot(expr_long, aes(x = value, color = variable)) +
  geom_density() +
  labs(title = "Expression Value Density Plot", x = "Expression Values (log2)", y = "Density") +
  theme_minimal()
