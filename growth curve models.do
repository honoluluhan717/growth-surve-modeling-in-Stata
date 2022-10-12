use http://www.stata-press.com/data/r14/childweight.dta, clear
cd C:\Users\wangy63
describe

/*Model 0: traditional regression 
Equation: 
weightij = β0j + β1j (age) + rij
*/

reg weight age
predict p_weight
graph twoway (line p_weight age, connect(ascending))
graph save model_0_0, replace
graph twoway (line p_weight age if girl ==0, connect(ascending))
graph save model_0_1, replace
graph twoway (line p_weight age if girl ==1, connect(ascending))
graph save model_0_2, replace
mixed weight age, nolog
est store model_0

/*Model 1 : Linear Growth curve model with a random intercept
Level 1 Model:
Weightij = β0j + β1j (Age) + rij
Level 2 Model:
β0j = γ00 + u0j
Full Model:
Weightij = γ00 + γ10(Age) + u0j + rij
*/

mixed weight age || id: , nolog
graph save model_1, replace
est store model_1

/*Model 2: Linear Growth curve model with random intercept and slope
Level 1 Model:
Weightij = β0j + β1j (Age) + rij
Level 2 Model:
β0j = γ00 + u0j
β1j = γ10 + u1j
Full Model:
Weightij = γ00 + γ10(Age) + u0j + u1j(Age) + rij
*/

mixed weight age || id: age, covariance(unstructured) nolog
graph save model_2, replace
est store model_2

/*Model 3 : Curvilinear Growth model with random intercept
Level 1 Model:
Weightij = β0j + β1j (Age) + + β2j (Age2) rij
Level 2 Model:
β0j = γ00 + u0j
β1j = γ10 + u1j 
β2j = γ20 + u2j
Full Model:
Weightij = γ00 + γ10(Age) + γ20(Age2) + u0j + u1j(Age) + u2j
(Age2) + rij
*/

mixed weight age c.age#c.age || id: age, covariance(unstructured) nolog
graph save model_3, replace
est store model_3

* Compare Models 1 through 3
lrtest model_0 model_1
lrtest model_1 model_2
lrtest model_2 model_3

/*Model 4: Same linear and curvilinear time effects for boys and girls
Level 1 Model:
Weightij = β0j + β1j (Age) + β2j (Age2) + rij
Level 2 Model:
β0j = γ00 + γ01(girl) + u0j
β1j = γ10 + u1j 
β2j = γ20 + u2j
Full Model:
Weightij = γ00 + γ10(Age) + γ20(Age2) + γ01(girl) + u0j + u1j(Age) + 
u2j(Age2) + rij
*/

mixed weight age c.age#c.age i.girl || id: age, covariance(unstructured) nolog
margins i.girl, at(age=(0(1)3)) vsquish
marginsplot, name(model_4, replace) x(age)

/*Model 5: Different linear and curvilinear time effects for boys and girls
Level 1 Model:
Weightij = β0j + β1j (Age) + β2j (Age2) + rij
Level 2 Model:
β0j = γ00 + γ01(girl) + u0j
β1j = γ10 + γ11(girl) + u1j 
β2j = γ20 + γ21(girl) + u2j
Full Model:
Weightij =
γ00 + γ01(girl) + u0j + 
γ10(Age) + γ11 (Age)(girl) + u1j (Age) + 
γ20 (Age2) + γ21 (Age2)(girl) + u2j(Age2) + rij
= γ00 + γ10(Age) + γ20 (Age2) + γ01(girl) + γ11 (Age)(girl) + γ21 (Age2)(girl) + u0j + 
u1j (Age) +u2j(Age2) +rij
*/

mixed weight i.girl##c.age##c.age|| id: age, covariance(unstructured) nolog
margins i.girl, at(age=(0(1)3)) vsquish
marginsplot, name(model_5, replace) x(age)









