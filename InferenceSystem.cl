(defun compareFacts (CONDITION FAIT)
  (let ((res NIL))
   (cond
      ;; Si la condition et le fait sont strictement identiques, on valide directement
      ((equal CONDITION FAIT)
        (setq res t)
      )
      ;;Si la condition porte sur le même symbole que le fait
      ((equal (cadr CONDITION) (cadr FAIT))
        (cond
          ;; Si les opérateurs sont les mêmes, ou que l'opérateur du fait est une égalité
          ((or (equal (car CONDITION) (car FAIT)) (member (car FAIT) '(equal eq = eql)))
            ;; On utilise la transitivité
            (setq res (eval (list (car CONDITION) (caddr FAIT) (caddr CONDITION))))
          )
          ;;Si seule la restrictivité des opérateurs change, on compare avec l'opérateur de la condition
          ((or (and (member (car FAIT) '(> >=)) (member (car CONDITION) '(> >=))) (and (member (car FAIT) '(< <=)) (member (car CONDITION) '(< <=))))
            ;; On compare en utilisant l'opérateur de la condition
            (setq res (eval (list (car CONDITION) (caddr FAIT) (caddr CONDITION))))
          )
        
        )
      )
    )
  )
)


(defun recherche_but (R F B)
  (let (res)
    ;;Si le but fait partie des faits, on renvoie vrai
    (loop for x in F while (not res) do
      (setq res (compareFacts B x))
    )
    (if (not res)
      ;;Sinon on cherche parmi les règles (si on trouve un chemin on arrete de chercher)
      (loop for x in R while (not res) do
        (if (compareFacts B (cadr x))  
          ;; Si le but est staisfait par le résultat d'une règle, on voit si on peut satisfaire les conditions de celle-ci 
          (let ((res_pro t))
            ;;On recherche donc pour chaque condition si elle est vérifiée, si une condition est fausse, on s'interompt
            (loop for y in (car x) while res_pro do
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