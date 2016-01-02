(setq rules
    '(
        (((>= ANNEE 1800)(<= ANNEE 1900)) (equal PERIODE "Romantique"))
        (((< ANNEE 1800)) (!= PERIODE "Romantique"))
        (((> ANNEE 1900)) (!= PERIODE "Romantique"))
        (((equal PERIODE "Romantique")(equal FORME "Vers"))(eq POESIE t))
        (((in AUTEUR '("Hugo" "Lamartine"))) (equal PERIODE "Romantique"))
    )
)
(setq facts
    '(
        (= ANNEE 1850)
        (equal FORME "Vers")
        ;;(equal AUTEUR "Hugo")
    )

)