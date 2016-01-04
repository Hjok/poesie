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
          ;; Si les opérateurs sont les mêmes (et pas !=), ou que l'opérateur du fait est une égalité et que la condition n'est pas une exclusion
          ((or (and (equal (car CONDITION) (car FAIT)) (!= (car CONDITION) '!=)) (and (member (car FAIT) '(equal eq = eql)) (not (eq (car CONDITION) 'notin))))
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

;; A function to invert sign, useful to build counter-proposal
(defun invert_sign (s)
  (let (res)
    (cond 
      ((or (eq s '=) (eq s 'equal) (eq s 'eq)) (setq res '!=))
      ((eq s '!=) (setq res 'equal))
      ((eq s '>) (setq res '<=))
      ((eq s '<) (setq res '>=))
      ((eq s '>=) (setq res '<))
      ((eq s '<=) (setq res '>))
      ((eq s 'in) (setq res 'notin))
      ((eq s 'notin) (setq res 'in))
    )
    res
  )
)

(defun check_user (y)
  (let (res)
    (format t "is it true? (t, nil, nknow) ~a " y)
    (setq res (read))
    (cond   
      ;; Si l'utilisateur dit qua la proposition est vraie, on l'ajoute à la base de faits et on renvoie 0
      ((equal t res) (setq F (cons y F)) 0)
      ;; Si l'utilisateur dit que la proposition est fausse
      ((equal nil res) 
        ;; Si la proposition est inversible
        (if (!= (invert_sign(car y)) nil)
          ;;On construit la contre-proposition et on l'ajoute à la base de faits
         (setq F (cons (list (invert_sign (car y)) (cadr y) (caddr y)) F)))
        ;; Qu'il y ait contre-proposition ou pas, on renvoie 1
        1)
      ;; Si l'utilisateur ne sait pas, on renvoie nil
      (t 2))
    )
  )

(defun recherche_but (B)
  (let (res)
    ;;Si le but est  confirmé directement par les faits, on renvoie vrai
    (loop for x in F while (not res) do
      (setq res (compareFacts B x))
      )
    ;; Si le but est inversible, on vérifie qu'il n'est pas infirmée directement par la base de faits
    (if (and (not res) (!= (invert_sign(car B)) nil))
      (loop for x in F do
        (if (compareFacts (list (invert_sign (car B)) (cadr B) (caddr B)) x)
          ;;Si c'est le cas, on retourne nil directement
          (return-from recherche_but nil)
        )
      )
    )
    (if (not res)
      (let ((userAnswer (check_user B)))
        (cond 
          ;;Si l'utilisateur confirme on marque vrai
          ((= userAnswer 0) (setq res t))
          ;;Si il infirme, on renvoie immédiatement faux, inutille de chercher plus loin
          ((= userAnswer 1) (return-from recherche_but nil))
        )
      )
    )
    (if (not res)
      ;;Sinon on cherche parmi les règles (si on trouve un chemin on arrete de chercher)
      (loop for x in *rules* while (not res) do
        (if (compareFacts B (cadr x))  
          ;; Si le but est satisfait par le résultat d'une règle, on voit si on peut satisfaire les conditions de celle-ci 
          (let ((res_pro t))
            ;;On recherche donc pour chaque condition si elle est vérifiée, si une condition est fausse, on s'interompt
            (loop for y in (car x) while res_pro do
              (setq res_pro (recherche_but y))
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

(defun isItPoetry ()
  (declare (special F))
  (setq F '())
  (recherche_but '(equal POESIE t))
)