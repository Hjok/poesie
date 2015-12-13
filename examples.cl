(setq rules
    '(
        (((>= ANNEE 1800)(<= ANNEE 1850)) (equal PERIODE "Romantique"))
        (((equal PERIODE "Romantique")(equal FORME "Vers"))(eq POESIE t))   
    )
)
(setq facts
    '(
        (= ANNEE 1850)
        (equal FORME "Vers")
    )

)