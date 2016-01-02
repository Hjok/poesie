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

;; A function to invert sign, useful to buil counter-proposal
(defun invert_sign (s)
  (let (res)
    (cond ((or (eq s '=) (eq s 'equal) (eq s 'eq)) (setq res '!=))
      ((eq s '!=) (setq res 'equal))
      ((eq s '>) (setq res '<=))
      ((eq s '<) (setq res '>=))
      ((eq s '>=) (setq res '<))
      ((eq s '<=) (setq res '>))
    )
    res
  )
)

(defun check_user (y)
  (let (res)
    (format t "is it true? (t, nil, nknow) ~a " y)
    (setq res (read))
    (cond   
      ;; Si l'utilisateur dit qua la proposition est vraie, on l'ajoute à la base de faits et on renvoie vrai
      ((equal t res) (setq F (cons y F)) t)
      ;; Si l'utilisateur dit que la proposition est fausse
      ((equal nil res) 
        ;; Si la proposition est inversible
        (if (!= (invert_sign(car y)) nil)
          ;;On construit la contre-proposition et on l'ajoute à la base de faits
         (setq F (cons (list (invert_sign (car y)) (cadr y) (caddr y)) F)))
        ;; Qu'il y ait contre-proposition ou pas, on renvoie faux
        nil)
      ;; Si l'utilisateur ne sait pas, on renvoie nil
      (t nil))
    )
  )

(defun recherche_but (B)
  (let (res)
    ;;Si le but est  confirmé directement par les faits, on renvoie vrai
    (loop for x in F while (not res) do
      (setq res (compareFacts B x))
      )
    (if (not res)
      ;;Sinon on cherche parmi les règles (si on trouve un chemin on arrete de chercher)
      (loop for x in R while (not res) do
        (if (compareFacts B (cadr x))  
          ;; Si le but est satisfait par le résultat d'une règle, on voit si on peut satisfaire les conditions de celle-ci 
          (let ((res_pro t))
            ;;On recherche donc pour chaque condition si elle est vérifiée, si une condition est fausse, on s'interompt
            (loop for y in (car x) while res_pro do
              (setq res_pro (recherche_but y))
              (if (not res_pro)
                (setq res_pro (check_user y))
                )
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

(defun isItPoetry (rules)
  (declare (special F))
  (declare (special R))
  (setq R rules)
  (setq F '())
  (recherche_but '(equal POESIE t))
)