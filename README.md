# 📊 Statistical Hypothesis Testing in R

**COMP1814 – Statistical Techniques with R**  
University of Greenwich | 2025/26  
Student: Jeet Nadiapara

---

## 📌 Project Overview
A comprehensive statistical analysis using R, exploring the relationship between 
maternal smoking and infant birth weight using hypothesis testing, 
normality checks, and Monte Carlo simulation.

---

## 📂 Files
| File | Description |
|------|-------------|
| `COMP1814_Code_1387168.R` | Full R analysis script |
| `birthwt_student_1387168.csv` | Dataset used for analysis |
| `Rplot.png` | Boxplot: Birth weight by smoking status |

---

## 🔬 Analysis Performed
- ✅ Data cleaning & factor conversion
- ✅ Summary statistics (mean, median, std dev)
- ✅ Boxplot visualisation
- ✅ Independent two-sample t-test (Welch)
- ✅ Shapiro-Wilk normality test
- ✅ QQ plots & histograms
- ✅ Wilcoxon rank-sum test
- ✅ Fisher's exact test & Chi-squared test
- ✅ 10,000-iteration Monte Carlo simulation
- ✅ Statistical power analysis

---

## 🛠️ Tech Used
- R (Base)
- ggplot2
- dplyr
- MASS package

---

## 📈 Key Findings
- Welch t-test: t = -2.23, p = 0.029 *(significant at 5%)*
- Wilcoxon test: W = 5249.5, p = 0.007 *(significant)*
- Statistical power at moderate effect size: ~37.71%
- Both groups confirmed normally distributed (Shapiro-Wilk p > 0.05)
