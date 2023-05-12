library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

# State of the Salmon Learning Tree 3 - full names, no abbreviations

decision_tree <- grViz("digraph {
      # define node aesthetics
graph [layout = dot]

node [shape= rectangle, style=filled, fillcolor='floralwhite', fontsize=50, fontname = Arial, penwidth=0.1]        
tab1 [label =  'L’abondance est-elle absolue et inférieure à 1 500?']
tab2 [label = 'L’abondance est-elle absolue et inférieure à 10 000?']
tab3 [label = 'ROUGE', fillcolor=Red, shape=oval]
tab4 [label =  'Y a-t-il un PRI de l’abondance \\nrelative (p. ex. Ggén, centile)?']
tab5 [label = 'Y a-t-il un PRI de l’abondance \\nrelative (p. ex. Ggén, centile)?']
tab8 [label = 'L’abondance est-elle inférieure à \\n0,79 x la moyenne géométrique à long terme?']
tab9 [label = 'L’abondance est-elle inférieure au PRI \\nde l’abondance relative (p. ex. Ggén, centile)?']
tab10 [label = 'L’abondance est-elle inférieure à \\n0,79 x la moyenne géométrique à long terme?']
tab11 [label = 'L’abondance est-elle inférieure au PRI \\nde l’abondance relative (p. ex. Ggén, centile)?']
tab16 [label = 'La tendance de l’abondance au cours des trois \\ndernières générations est-elle inférieure à -70 %?']
tab17 [label = 'ROUGE', fillcolor=Red, shape=oval]
tab18 [label = 'L’abondance est-elle inférieure à 1,1 x le PRS \\nde l’abondance relative (p. ex. 0,8 x GRMD, centile)?']
tab19 [label = 'ROUGE', fillcolor=Red, shape=oval]
tab20 [label = 'AMBRE', fillcolor=Gold, shape=oval]
tab21 [label = 'ROUGE', fillcolor=Red, shape=oval]
tab22 [label = 'AMBRE', fillcolor=Gold, shape=oval]
tab23 [label = 'ROUGE', fillcolor=Red, shape=oval]
tab32 [label = 'L’abondance est-elle inférieure à 2,33 x la \\nmoyenne géométrique à long terme?' ]
tab33 [label = 'ROUGE', fillcolor=Red, shape=oval]
tab36 [label = 'VERT', fillcolor=Limegreen, shape=oval]
tab37 [label = 'AMBRE', fillcolor=Gold, shape=oval]
tab64 [label = 'VERT', fillcolor=Limegreen, shape=oval]
tab65 [label = 'AMBRE', fillcolor=Gold, shape=oval]

# set up node layout

edge [fontname=Arial, fontsize=50, color=DimGray, fontcolor=DimGray, minlen=3]
tab1 -> tab2 [label='non'];
tab1 -> tab3 [label='oui'];
tab2 -> tab4 [label='non'];
tab2 -> tab5 [label='oui'];
tab4 -> tab8 [label='non'];
tab4 -> tab9 [label='oui'];
tab8 -> tab16 [label='non'];
tab8 -> tab17 [label='oui'];
tab16 -> tab32 [label='non'];
tab32 -> tab64 [label='non'];
tab32 -> tab65 [label='oui'];
tab16 -> tab33 [label='oui'];
tab9 -> tab18 [label='non'];
tab9 -> tab19 [label='oui'];
tab18 -> tab36 [label='non'];
tab18 -> tab37 [label='oui'];
tab5 -> tab10 [label='non'];
tab10 -> tab20 [label='non'];
tab10 -> tab21 [label='oui'];
tab5 -> tab11 [label='oui'];
tab11 -> tab22 [label='non'];
tab11 -> tab23 [label='oui']
}
")
decision_tree %>%
  export_svg %>% charToRaw %>% rsvg_png("figure/decision_tree.png", width=4000, height=2000)


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
