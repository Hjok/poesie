(defun recherche_but (R F B)
  (let (res)
    ;;Si le but fait partie des faits, on renvoie vrai
    (if (member B F :test #'equal) (setq res t)
      ;;Sinon on cherche parmi les règles (si on trouve un chemin on arrete de chercher)
      (loop for x in R while (not res) do
        (if (equal (car(cddr x)) B)  
          ;; Si le but est résultat d'une règle, on voit si on peut satisfaire ses conditions    
          (let ((res_pro t))
            ;;On recherche donc pour chaque condition si elle est vérifiée, si une condition est fausse, on s'interompt
            (loop for y in (car(cdr x)) while res_pro do
              (setq res_pro (recherche_but R F y))
            )
            ;; Si les conditions sont satisfaites, on note qu'on a trouvé et on sort donc de la boucle de recherche
            (if res_pro (setq res t))
          )
        )
      )
    )
  res
  )
)
