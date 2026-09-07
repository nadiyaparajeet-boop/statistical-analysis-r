if (!require(MASS)) install.packages("MASS", dependencies=TRUE) 
if (!require(dplyr)) install.packages("dplyr", dependencies=TRUE) 
if (!require(tibble)) install.packages("tibble", dependencies=TRUE) 

library(MASS)     
library(dplyr)    
library(tibble)   

student_id <-001387168
set.seed(student_id)
birthwt <- as_tibble(MASS::birthwt)
birthwt <- birthwt %>% rename(birthwt.below.2500 = low, mother.age = age, mother.weight = lwt,mother.smokes = smoke,previous.prem.labor = ptl,hypertension = ht,uterine.irr = ui,physician.visits = ftv,     birthwt.grams = bwt) 

birthwt <- birthwt %>% mutate( race = recode_factor(race, `1` = "white", `2` = "black", `3` = "other"), mother.smokes = recode_factor(mother.smokes, `0` = "no", `1` = "yes"), hypertension = recode_factor(hypertension, `0` = "no", `1` = "yes"), uterine.irr = recode_factor(uterine.irr, `0` = "no", `1` = "yes"), 
    birthwt.below.2500 = recode_factor(birthwt.below.2500, `0` = "no", `1` = "yes") ) 

# Step 3: Randomize the dataset to ensure unique student datasets 
# (A) Randomly sample a subset of 100 rows for each student 
birthwt_sample <- birthwt %>% sample_n(100, replace = FALSE) 

# (B) Add slight random noise to birth weight values 
birthwt_sample <- birthwt_sample %>% mutate(birthwt.grams = birthwt.grams + rnorm(n(), mean = 0, sd = 20)) 

# (C) Shuffle the smoking status to prevent direct comparison 
birthwt_sample <- birthwt_sample %>% mutate(mother.smokes = sample(mother.smokes)) 

# (D) Randomize variable names for some numerical columns 
random_labels <- sample(c("factorA", "factorB", "factorC")) 
colnames(birthwt_sample)[c(3, 4, 5)] <- random_labels 

# Step 4: Save the unique dataset 
write.csv(birthwt_sample, file = paste0("birthwt_student_", student_id, ".csv"), 
          row.names = FALSE) 

# Step 5: Display confirmation message 
cat("\n   
Your unique dataset has been saved as:", paste0("birthwt_student_", 
                                                student_id, ".csv")) 
cat("\nUse this dataset for your coursework and analysis!\n") 

# Step 6: Show the first few rows 
print(head(birthwt_sample))

birthwt <- read.csv("birthwt_student_1387168.csv")
str(birthwt)
dim(birthwt)


birthwt <- birthwt %>% rename(race = factorA, mother.weight = factorB, mother.smokes = factorC)
birthwt <- birthwt %>%mutate(across(c(mother.smokes, race, hypertension, uterine.irr,birthwt.below.2500), as.factor))
birthwt %>%summarise(across(c(mother.age, mother.weight, birthwt.grams),list(mean=mean, median=median, sd=sd)))
boxplot(birthwt.grams ~ mother.smokes, data = birthwt,col = c("steelblue", "coral"),xlab = "Smoking Status", ylab = "Birth Weight (grams)",main = "Birth Weight by Smoking Status")
tapply(birthwt$birthwt.grams, birthwt$mother.smokes, mean)
tapply(birthwt$birthwt.grams, birthwt$mother.smokes, sd)


# Standard error function
se <- function(x) sd(x) / sqrt(length(x))
tapply(birthwt$birthwt.grams, birthwt$mother.smokes, se)
t.test(birthwt.grams ~ mother.smokes, data = birthwt, var.equal = FALSE)


# QQ plots
par(mfrow = c(1, 2))
qqnorm(birthwt$birthwt.grams[birthwt$mother.smokes == "no"],main = "QQ Plot - Non-smokers")
qqline(birthwt$birthwt.grams[birthwt$mother.smokes == "no"], col = "red")
qqnorm(birthwt$birthwt.grams[birthwt$mother.smokes == "yes"],main = "QQ Plot - Smokers")
qqline(birthwt$birthwt.grams[birthwt$mother.smokes == "yes"], col = "red")


# Histograms
par(mfrow = c(1, 2))
hist(birthwt$birthwt.grams[birthwt$mother.smokes == "no"],main = "Non-smokers", xlab = "Birth Weight (g)", col = "steelblue")
hist(birthwt$birthwt.grams[birthwt$mother.smokes == "yes"],main = "Smokers", xlab = "Birth Weight (g)", col = "coral")


# Shapiro-Wilk test
shapiro.test(birthwt$birthwt.grams[birthwt$mother.smokes == "no"])
shapiro.test(birthwt$birthwt.grams[birthwt$mother.smokes == "yes"])
wilcox.test(birthwt.grams ~ mother.smokes, data = birthwt)


# Contingency table
table(birthwt$mother.smokes, birthwt$birthwt.below.2500)


# Chi-squared and Fisher's exact
chisq.test(table(birthwt$mother.smokes, birthwt$birthwt.below.2500))
fisher.test(table(birthwt$mother.smokes, birthwt$birthwt.below.2500))


# Single simulation, null effect
set.seed(42)
control <- rnorm(50, mean = 100, sd = 15)
treatment <- rnorm(50, mean = 100, sd = 15)
t.test(control, treatment)


# 10,000 simulations with moderate effect
set.seed(42)
p_vals <- replicate(10000, {
control <- rnorm(50, mean = 100, sd = 15)
treatment <- rnorm(50, mean = 105, sd = 15)
t.test(control, treatment)$p.value})
hist(p_vals, breaks = 50, col = "steelblue",
main = "P-value Distribution (10,000 Simulations)",
xlab = "P-value")
abline(v = 0.05, col = "red", lty = 2)
mean(p_vals < 0.05)  


# Boous ~ Small sample (n=30)
set.seed(1387168)
small_sample <- birthwt[sample(nrow(birthwt), 30), ]
t.test(birthwt.grams ~ mother.smokes, data = small_sample, var.equal = FALSE)
wilcox.test(birthwt.grams ~ mother.smokes, data = small_sample)