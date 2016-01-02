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

(defun check_user (but)
  (let (res)
    (format t "is it true? (t/nil/?) ~a " but)
    (setq res (read))
    (cond   ((equal t res)
             (push but *facts*)
             1)
          ((equal nil res) nil)
          ((equal '? res) 0))
    ))

(defun recherche_but (B)
  (format t "but recherché : ~a~%" B)
  (format t "faits : ~a~%" *facts*)
  (let (res rep)
    ;; Si le but fait partie des faits, on renvoie vrai
    (loop for x in *facts* while (not res) do
          (setq res (compareFacts B x)))
    (unless res
      ;; Sinon on demande à l'utilisateur
      (if (eql (setq rep (check_user B)) 1) (setq res t))
      ;; Si oui, res vaut t
      ;; Si non, on passe (but inatteignable)
      ;; S'il ne sait pas, on cherche parmi les règles (si on trouve un chemin on arrete de chercher)
      (loop for x in *rules* while (and (not res) rep) do
            (if (compareFacts B (cadr x))  
                ;; Si le but est satisfait par le résultat d'une règle, on voit si on peut satisfaire les conditions de celle-ci 
                (let ((res_pro t))
                  ;; On recherche donc pour chaque condition si elle est vérifiée, si une condition est fausse, on s'interompt
                  (loop for y in (car x) while res_pro do
                        (setq res_pro (recherche_but y)))
                  ;; Si les conditions sont satisfaites, on note qu'on a trouvé et on sort donc de la boucle de recherche
                  (if res_pro (setq res t))
                  )
              )
            )
      )
    res
    )
  )