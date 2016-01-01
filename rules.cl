(defparameter *rules* nil)

(setq *rules*
    '(
      ; R1 - R4
      (((equal ECRITURE "Vers") (equal VERSIFICATION "Classique") (in EPOQUE (17 18))) (eq POESIE t))
      (((equal ECRITURE "Vers") (equal TYPE-FORME "Médiévale") (in EPOQUE (11 12 13 14 15))) (eq POESIE t))
      (((equal ECRITURE "Vers") (equal TYPE-FORME "Renaissance") (= EPOQUE 16)) (eq POESIE t))
      (((in ECRITURE ("Vers" "Prose")) (in EPOQUE (19 20 21))) (eq POESIE t))

      ; RA1 - RA8
      (((in AUTEUR ("Ruteboeuf", "Meung", "de Machaut", "de Pisan", "Chartier", "Charles d'Orléan", "Villon"))) (equal MOUVEMENT "Moyen-Âge"))
      (((in AUTEUR ("Ronsard", "du Bellay", "Scève", "de Saint-Gellais", "Marot", "Rabelais", "du Guillet", "Tyard", "Baïf", "Jodelle", "Dorat", "Belleau"))) (equal MOUVEMENT "Humaniste"))
      (((in AUTEUR ("d'Aubigné", "de Viau"))) (equal MOUVEMENT "Baroque"))
      (((in AUTEUR ("Boileau", "Malherbe", "Racine", "La Fontaine"))) (equal MOUVEMENT "Classicisme"))
      (((in AUTEUR ("Piron", "Delille", "Parny", "Gilbert", "Millevoye", "Chénier"))) (equal MOUVEMENT "Lumières"))
      (((in AUTEUR ("Hugo", "Lamartine", "Vigny", "Musset", "Nerval", "Baudelaire"))) (equal MOUVEMENT "Romantisme"))
      (((in AUTEUR ("Gautier", "Banville", "de Lisle", "de Heredia"))) (equal MOUVEMENT "Parnasse"))
      (((in AUTEUR ("Rimbaud", "Verlaine"))) (equal MOUVEMENT "Symbolisme"))
      
      ; RM1 - RM6
      (((equal MOUVEMENT "Moyen-Âge")) (<= EPOQUE 15))
      (((in MOUVEMENT ("Humaniste Baroque"))) (= EPOQUE 16))
      (((equal MOUVEMENT "Classicisme")) (= EPOQUE 17))
      (((equal MOUVEMENT "Lumières")) (= EPOQUE 18))
      (((in MOUVEMENT ("Romantisme Parnasse Symbolisme"))) (= EPOQUE 19))
      (((equal MOUVEMENT "Moderne")) (>= EPOQUE 20))
      
      ; RH, RTR, RVL
      (((eq HIATUS t)) (>= EPOQUE 20))
      (((equal METRIQUE "Alexandrin") (equal RYTHME "4+4+4")) (>= EPOQUE 19))
      (((equal VERS "Libre")) (>= EPOQUE 19))
      
      ; RE, RR, RC
      (((equal APOCOPE "Fin-vers") (eq ELISION t)) (equal E-CADUC "Classique"))
      (((equal POSITION-RIMES "Fin-vers") (eq ALTERNANCE-RIMES t) (eq RIMES-S-P nil)) (equal RIME "Classique"))
      (((eq CESURE-EPIQUE nil) (eq CESURE-ENJAMBANTE nil)) (equal CESURE "Classique"))
      
      ; RV
      (((eq MAJUSCULE t) (equal E-CADUC "Classique") (eq HIATUS nil) (equal RIME "Classique") (equal CESURE "Classique")) (equal VERSIFICATION "Classique"))
      
      ; RShR1 - RShR6
      (((equal SCHEMA-RIMES "ABaAabAB")) (equal FORME "Triolet"))
      (((equal SCHEMA-RIMES "ABba-abAB-abbaA")) (equal FORME "Rondel"))
      (((equal SCHEMA-RIMES "aabba-aab-refrain-aabba-refrain")) (equal FORME "Rondeau"))
      (((equal SCHEMA-RIMES "A1bA2-abA1-abA2-abA1-abA2-abA1A2")) (equal FORME "Villanelle"))
      (((equal SCHEMA-RIMES "abba-abba-ccd-eed")) (equal FORME "Sonnet marotique"))
      (((equal SCHEMA-RIMES "abba-abba-ccd-ede")) (equal FORME "Sonnet français"))
      
      ; RFM, RFR
      (((in FORME ("Triolet", "Rondel", "Rondeau", "Lai", "Virelai", "Ballade"))) (equal TYPE-FORME "Médiévale"))
      (((in FORME ("Ode", "Sextine", "Villanelle", "Sonnet marotique", "Sonnet français"))) (equal TYPE-FORME "Renaissance"))
    )
)