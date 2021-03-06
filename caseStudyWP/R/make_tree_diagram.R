library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

decision_tree <- grViz("digraph graph2 {
      # define node aesthetics
graph [layout = dot]

node [shape= rectangle, style=filled, fillcolor='cornsilk', fontname = Arial]        
tab1 [label =  'DataType = AbsAbd & AbsLBM <1.5?']
tab2 [label = 'DataType = AbsAbd & AbsUBM <1?']
tab3 [label = 'RED', fillcolor='red3' ]
tab4 [label =  'Have Rel LBM Metric?']
tab5 [label = 'Have Rel LBM Metric?']
tab8 [label = 'LongTrend <79?']
tab9 [label = 'RelLBM <1?']
tab10 [label = 'LongTrend <79?']
tab11 [label = 'RelLBM <1?']
tab16 [label = '%Change < -70?']
tab17 [label = 'RED', fillcolor='red3']
tab18 [label = 'RelUBM < 1.1?']
tab19 [label = 'RED', fillcolor='red3']
tab20 [label = 'AMBER', fillcolor='goldenrod1']
tab21 [label = 'RED', fillcolor='red3']
tab22 [label = 'AMBER', fillcolor='goldenrod1']
tab23 [label = 'RED', fillcolor='red3']
tab32 [label = 'GREEN', fillcolor='chartreuse2']
tab33 [label = 'AMBER', fillcolor='goldenrod1']
tab36 [label = 'GREEN', fillcolor='chartreuse2']
tab37 [label = 'AMBER', fillcolor='goldenrod1']

# set up node layout

edge [fontname=Arial]
tab1 -> tab2 [label='no'];
tab1 -> tab3 [label='yes'];
tab2 -> tab4 [label='no'];
tab2 -> tab5 [label='yes'];
tab4 -> tab8 [label='no'];
tab4 -> tab9 [label='yes'];
tab8 -> tab16 [label='no'];
tab8 -> tab17 [label='yes'];
tab16 -> tab32 [label='no'];
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
