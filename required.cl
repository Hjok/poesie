(defun != (a b)
    (not (equal a b))
)
(defun in (param list)
    (member param list :test #'equal)
)