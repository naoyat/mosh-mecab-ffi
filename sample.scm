(import (rnrs)
        (mosh)
        (binding mecab-ffi))

(let ([m (mecab-new2 "")] [src (string->utf8z "ぼく、ひげぽん。")])
  (let loop ((n (mecab-sparse-tonode m src)))
    (unless (mecab-node-eos? n)
      (when (mecab-node-normal? n)
        (format #t "~d ~a pos:~d chartype:~d\n"
                (mecab-node-surface n)
                (mecab-node-feature n)
                (mecab-node-posid n)
                (mecab-node-char-type n)))
      (loop (mecab-node-next n))))
  (mecab-destroy m))

