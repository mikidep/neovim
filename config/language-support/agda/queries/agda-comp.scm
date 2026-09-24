;; Write queries here (see $VIMRUNTIME/queries/ for examples).
;; Move cursor to a capture ("@foo") to highlight matches in the source buffer.
;; Completion for grammar nodes is available (:help compl-omni)


((expr
    (atom
      (qid) @cap (#eq? @cap "hcomp") )
    [
      (atom
          (expr
            (atom
              (qid) @capp (#eq? @capp "doubleComp-faces"))
            (atom (_))
            (atom (_)) @q
            (_)))
      (atom
        (expr
          (lambda
            (untyped_binding (_))+
            (expr
              (atom
                (qid) @capp (#eq? @capp "doubleComp-faces"))
              (atom (_))
              (atom (_)) @q
              (_))
            )
         ))
    ]
    (atom (_)) @p)
  @main
)
