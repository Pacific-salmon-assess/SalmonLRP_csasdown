library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

# State of the Salmon Learning Tree 3 - full names, no abbreviations

decision_tree <- grViz("digraph graph2 {
      # define node aesthetics
graph [layout = dot]

node [shape= rectangle, style=filled, fillcolor='floralwhite', fontsize=20, fontname = Arial, penwidth=0.1]        
tab1 [label =  'Is abundance absolute & < 1500?']
tab2 [label = 'Are abundances absolute & < 10,000?']
tab3 [label = 'RED', fillcolor=Red, shape=oval]
tab4 [label =  'Is there a relative abundance lower \\nbenchmark (e.g., Sgen, percentile)?']
tab5 [label = 'Is there a relative abundance lower \\nbenchmark (e.g., Sgen, percentile)?']
tab8 [label = 'Is abundance < 0.79 x long-term \\ngeometric average?']
tab9 [label = 'Is abundance < relative abundance \\nlower benchmark? (e.g., Sgen, percentile)?']
tab10 [label = 'Is abundance < 0.79 x long-term \\ngeometric average?']
tab11 [label = 'Is abundance < relative abundance \\nlower benchmark? (e.g., Sgen, percentile)?']
tab16 [label = 'Is the trend in abundances over \\nthe most recent 3 generations < -70%?']
tab17 [label = 'RED', fillcolor=Red, shape=oval]
tab18 [label = 'Is abundance < than 1.1 x relative abundance \\nupper benchmark (e.g., 0.8 x SMSY, percentile)?']
tab19 [label = 'RED', fillcolor=Red, shape=oval]
tab20 [label = 'AMBER', fillcolor=Gold, shape=oval]
tab21 [label = 'RED', fillcolor=Red, shape=oval]
tab22 [label = 'AMBER', fillcolor=Gold, shape=oval]
tab23 [label = 'RED', fillcolor=Red, shape=oval]
tab32 [label = 'Is abundance < 233% x the long-term \\ngeometric average?' ]
tab33 [label = 'RED', fillcolor=Red, shape=oval]
tab36 [label = 'GREEN', fillcolor=Limegreen, shape=oval]
tab37 [label = 'AMBER', fillcolor=Gold, shape=oval]
tab64 [label = 'GREEN', fillcolor=Limegreen, shape=oval]
tab65 [label = 'AMBER', fillcolor=Gold, shape=oval]

# set up node layout

edge [fontname=Arial, fontsize=20, color=DimGray, fontcolor=DimGray]
tab1 -> tab2 [label='no'];
tab1 -> tab3 [label='yes'];
tab2 -> tab4 [label='no'];
tab2 -> tab5 [label='yes'];
tab4 -> tab8 [label='no'];
tab4 -> tab9 [label='yes'];
tab8 -> tab16 [label='no'];
tab8 -> tab17 [label='yes'];
tab16 -> tab32 [label='no'];
tab32 -> tab64 [label='no'];
tab32 -> tab65 [label='yes'];
tab16 -> tab33 [label='yes'];
tab9 -> tab18 [label='no'];
tab9 -> tab19 [label='yes'];
tab18 -> tab36 [label='no'];
tab18 -> tab37 [label='yes'];
tab5 -> tab10 [label='no'];
tab10 -> tab20 [label='no'];
tab10 -> tab21 [label='yes'];
tab5 -> tab11 [label='yes'];
tab11 -> tab22 [label='no'];
tab11 -> tab23 [label='yes']
}
")
decision_tree %>%
  export_svg %>% charToRaw %>% rsvg_png("figure/decision_tree.png")


# State of the Salmon Learning Tree 3 - Original names

# decision_tree <- grViz("digraph graph2 {
#       # define node aesthetics
# graph [layout = dot]
# 
# node [shape= rectangle, style=filled, fillcolor='cornsilk', fontname = Arial]        
# tab1 [label =  'DataType = AbsAbd & AbsLBM <1.5?']
# tab2 [label = 'DataType = AbsAbd & AbsUBM <1?']
# tab3 [label = 'RED', fillcolor=Red ]
# tab4 [label =  'Have Rel LBM Metric?']
# tab5 [label = 'Have Rel LBM Metric?']
# tab8 [label = 'LongTrend <79?']
# tab9 [label = 'RelLBM <1?']
# tab10 [label = 'LongTrend <79?']
# tab11 [label = 'RelLBM <1?']
# tab16 [label = '%Change < -70?']
# tab17 [label = 'RED', fillcolor=Red]
# tab18 [label = 'RelUBM < 1.1?']
# tab19 [label = 'RED', fillcolor=Red]
# tab20 [label = 'AMBER', fillcolor=Gold]
# tab21 [label = 'RED', fillcolor=Red]
# tab22 [label = 'AMBER', fillcolor=Gold]
# tab23 [label = 'RED', fillcolor=Red]
# tab32 [label = 'GREEN', fillcolor=Limegreen]
# tab33 [label = 'AMBER', fillcolor=Gold]
# tab36 [label = 'GREEN', fillcolor=Limegreen]
# tab37 [label = 'AMBER', fillcolor=Gold]
# 
# # set up node layout
# 
# edge [fontname=Arial]
# tab1 -> tab2 [label='no'];
# tab1 -> tab3 [label='yes'];
# tab2 -> tab4 [label='no'];
# tab2 -> tab5 [label='yes'];
# tab4 -> tab8 [label='no'];
# tab4 -> tab9 [label='yes'];
# tab8 -> tab16 [label='no'];
# tab8 -> tab17 [label='yes'];
# tab16 -> tab32 [label='no'];
# tab16 -> tab33 [label='yes'];
# tab9 -> tab18 [label='no'];
# tab9 -> tab19 [label='yes'];
# tab18 -> tab36 [label='no'];
# tab18 -> tab37 [label='yes'];
# tab5 -> tab10 [label='no'];
# tab10 -> tab20 [label='no'];
# tab10 -> tab21 [label='yes'];
# tab5 -> tab11 [label='yes'];
# tab11 -> tab22 [label='no'];
# tab11 -> tab23 [label='yes']
# }
# ")
# decision_tree %>%
#   export_svg %>% charToRaw %>% rsvg_png("figure/decision_tree.png")
