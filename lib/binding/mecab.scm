(library (binding mecab)
         (export mecab-new2
                 mecab-version
                 mecab-strerror
                 mecab-destroy
                 mecab-get-partial mecab-set-partial!
                 ;;mecab-get-theta mecab-set-theta!
                 mecab-get-lattice-level mecab-set-lattice-level!
                 mecab-get-all-morphs mecab-set-all-morphs!
                 mecab-sparse-tostr mecab-sparse-tostr2 ;mecab-sparse-tostr3
                 mecab-sparse-tonode mecab-sparse-tonode2
                 mecab-nbest-sparse-tostr mecab-nbest-sparse-tostr2 ;mecab-nbest-sparse-tostr3
                 mecab-nbest-init mecab-nbest-init2
                 mecab-nbest-next-tostr mecab-nbest-next-tostr2
                 mecab-nbest-next-tonode
                 mecab-format-node
                 mecab-dictionary-info

                 mecab-node-prev mecab-node-next mecab-node-enext mecab-node-bnext
                 mecab-node-surface mecab-node-feature mecab-node-id
                 mecab-node-length mecab-node-rlength
                 mecab-node-rc-attr mecab-node-lc-attr
                 mecab-node-posid mecab-node-char-type
                 mecab-node-stat mecab-node-normal? mecab-node-unknown? mecab-node-bos? mecab-node-eos?
                 mecab-node-best?
                 mecab-node-sentence-length
                 ;; mecab-node-alpha mecab-node-beta mecab-node-prob
                 mecab-node-wcost mecab-node-cost
                 ;; mecab-node-token
                 
                 string->utf8z
                 )
         (import (rnrs)
                 (rnrs r5rs)
                 (mosh ffi)
                 )

(define libmecab (open-shared-library "/usr/local/lib/libmecab.1.dylib"))

(define mecab-new2
  (c-function libmecab void* mecab_new2 char*))
(define mecab-version
  (c-function libmecab char* mecab_version))
(define mecab-strerror
  (c-function libmecab char* mecab_strerror void*))
(define mecab-destroy
  (c-function libmecab void mecab_destroy void*))

;; パラメータ変更系
(define mecab-get-partial
  (c-function libmecab int mecab_get_partial void*))
(define mecab-set-partial!
  (c-function libmecab void mecab_set_partial void* int))
;(define mecab-get-theta
;  (c-function libmecab float mecab_get_theta void*))
;(define mecab-set-theta!
;  (c-function libmecab void mecab_set_theta void* float))
(define mecab-get-lattice-level
  (c-function libmecab int mecab_get_lattice_level void*))
(define mecab-set-lattice-level!
  (c-function libmecab int mecab_set_lattice_level void* int))
(define mecab-get-all-morphs
  (c-function libmecab int mecab_get_all_morphs void*))
(define mecab-set-all-morphs!
  (c-function libmecab void mecab_set_all_morphs void* int))

(define mecab-sparse-tostr
  (c-function libmecab char* mecab_sparse_tostr void* char*))
(define mecab-sparse-tostr2
  (c-function libmecab char* mecab_sparse_tostr void* char* int))
;(define mecab-sparse-tostr3
;  (c-function libmecab char* mecab_sparse_tostr void* char* int char* int))
(define mecab-sparse-tonode ; mecab_node_t* を返す
  (c-function libmecab void* mecab_sparse_tonode void* char*)) ;; (m, str)
(define mecab-sparse-tonode2 ; mecab_node_t* を返す
  (c-function libmecab void* mecab_sparse_tonode2 void* char* int)) ;; (m str len)

(define mecab-nbest-sparse-tostr
  (c-function libmecab char* mecab_nbest_sparse_tostr void* int char*))
(define mecab-nbest-sparse-tostr2
  (c-function libmecab char* mecab_nbest_sparse_tostr2 void* int char* int))
;(define mecab-nbest-sparse-tostr3
;  (c-function libmecab char* mecab_nbest_sparse_tostr3 void* int char int char* int))
(define mecab-nbest-init
  (c-function libmecab int mecab_nbest_init void* char*))
(define mecab-nbest-init2
  (c-function libmecab int mecab_nbest_init2 void* char* int))
(define mecab-nbest-next-tostr
  (c-function libmecab char* mecab_nbest_next_tostr void*))
(define mecab-nbest-next-tostr2
  (c-function libmecab char* mecab_nbest_next_tostr2 void* char* int))
(define mecab-nbest-next-tonode ; mecab_node_t*
  (c-function libmecab void* mecab_nbest_next_tonode void*))
(define mecab-format-node
  (c-function libmecab char* mecab_format_node void* void*)) ; (mecab node)
(define mecab-dictionary-info ; mecab_dictionary_info_t* を返す
  (c-function libmecab void* mecab_dictionary_info void*))

;; APIs not supported:
;;  MECAB_DLL_EXTERN int           mecab_do (int argc, char **argv);
;;  MECAB_DLL_EXTERN mecab_t*      mecab_new(int argc, char **argv);
;;  MECAB_DLL_EXTERN int           mecab_dict_index(int argc, char **argv);
;;  MECAB_DLL_EXTERN int           mecab_dict_gen(int argc, char **argv);
;;  MECAB_DLL_EXTERN int           mecab_cost_train(int argc, char **argv);
;;  MECAB_DLL_EXTERN int           mecab_system_eval(int argc, char **argv);
;;  MECAB_DLL_EXTERN int           mecab_test_gen(int argc, char **argv);

;;
;; mecab_node_t
;;
(define (mecab-node-prev node-ptr) (pointer-ref node-ptr 0))
(define (mecab-node-next node-ptr) (pointer-ref node-ptr 1))
(define (mecab-node-enext node-ptr) (pointer-ref node-ptr 2))
(define (mecab-node-bnext node-ptr) (pointer-ref node-ptr 3))
(define (mecab-node-surface node-ptr)
  (pointer->string* (pointer-ref node-ptr 8)
                    (mecab-node-length node-ptr)) )
(define (mecab-node-feature node-ptr)
;  (string-tokenize
  (map (lambda (s) (if (string=? "*" s) #f s))
       (string-split (pointer->string (pointer-ref node-ptr 9)) #\,)))

(define (mecab-node-id node-ptr)
  (pointer-ref node-ptr 10))
(define (mecab-node-length node-ptr)
  (bitwise-bit-field (pointer-ref node-ptr 11) 0 16))
(define (mecab-node-rlength node-ptr)
  (bitwise-bit-field (pointer-ref node-ptr 11) 16 32))
(define (mecab-node-rc-attr node-ptr)
  (bitwise-bit-field (pointer-ref node-ptr 12) 0 16))
(define (mecab-node-lc-attr node-ptr)
  (bitwise-bit-field (pointer-ref node-ptr 12) 16 32))
(define (mecab-node-posid node-ptr)
  (bitwise-bit-field (pointer-ref node-ptr 13) 0 16))
(define (mecab-node-char-type node-ptr)
  (bitwise-bit-field (pointer-ref node-ptr 13) 16 24))
(define (mecab-node-stat node-ptr)
  (case (bitwise-bit-field (pointer-ref node-ptr 13) 24 32)
    [(0) 'mecab-nor-node]
    [(1) 'mecab-unk-node]
    [(2) 'mecab-bos-node]
    [(3) 'mecab-eos-node]))
(define (mecab-node-normal? node-ptr)
  (eq? 'mecab-nor-node (mecab-node-stat node-ptr)))
(define (mecab-node-unknown? node-ptr)
  (eq? 'mecab-unk-node (mecab-node-stat node-ptr)))
(define (mecab-node-bos? node-ptr)
  (eq? 'mecab-bos-node (mecab-node-stat node-ptr)))
(define (mecab-node-eos? node-ptr)
  (eq? 'mecab-eos-node (mecab-node-stat node-ptr)))
(define (mecab-node-best? node-ptr)
  (bitwise-bit-set? (pointer-ref node-ptr 14) 0))
(define (mecab-node-sentence-length node-ptr) ; available only when BOS
  (pointer-ref node-ptr 15))
;(define (mecab-node-alpha node-ptr)
;  (pointer-ref node-ptr 16))
;(define (mecab-node-beta node-ptr)
;  (pointer-ref node-ptr 17))
;(define (mecab-node-prob node-ptr)
;  (pointer-ref node-ptr 18))
(define (mecab-node-wcost node-ptr)
  (bitwise-bit-field (pointer-ref node-ptr 19) 0 16))
(define (mecab-node-cost node-ptr)
  (pointer-ref node-ptr 20))
;(define (mecab-node-token node-ptr)
;  (pointer-ref node-ptr 21))

;;
;; utilities by naoya_t
;;
(define (string->utf8z str)
  ;;文字列をutf-8なbytevectorに変換。文字列側に\x0;があっても無視されるので、変換後に末尾に0を足す
  (let* ([u8 (string->utf8 str)]
         [len (bytevector-length u8)]
         [u8z (make-bytevector (+ len 1))])
;;  (bytevector-copy u8z u8) ;memcpy的なのはどうすればいい
;    (format #t "len: ~d\n" len)
    (let loop ((i 0))
      (when (< i len)
        (bytevector-u8-set! u8z i (bytevector-u8-ref u8 i))
        (loop (+ i 1))))
    (bytevector-u8-set! u8z len 0)
    u8z))

(define (read-from-ptr ptr bvec words)
  (let loop ((i 0))
    (when (< i words)
      (let ((word (pointer-ref ptr i)))
        (bytevector-uint-set! bvec (* i 4) word (endianness little) 4)
        (loop (+ i 1))))))

(define (pointer->string* ptr len)
  (let* ([words (quotient (+ len 4) 4)]
         [bvec (make-bytevector (* words 4))])
;   (format #t "(pointer->string* ptr:~a len:~d words:~d bvec:~a)\n"
;           ptr len words bvec)
    (read-from-ptr ptr bvec words)
    (bytevector-u8-set! bvec len 0)
    (utf8->string bvec)))


;; from 逆引きScheme
(define (string-split-by-char str spliter)
  (let loop ((ls (string->list str)) (buf '()) (ret '()))
    (if (pair? ls)
      (if (char=? (car ls) spliter)
        (loop (cdr ls) '() (cons (list->string (reverse buf)) ret))
        (loop (cdr ls) (cons (car ls) buf) ret))
      (reverse (cons (list->string (reverse buf)) ret)))))

(define (string-split-by-string str spliter)
  (if (zero? (string-length spliter))
    (list str)
    (let ((spl (string->list spliter)))
      (let loop ((ls (string->list str)) (sp spl) (tmp '()) (buf '()) (ret '()))
        (if (pair? sp)
          (if (pair? ls)
            (if (char=? (car ls) (car sp))
              (loop (cdr ls) (cdr sp) (cons (car ls) tmp) buf ret)
              (loop (cdr ls) spl '() (cons (car ls) (append tmp buf)) ret))
            (reverse (cons (list->string (reverse (append tmp buf))) ret)))
          (loop ls spl '() '() (cons (list->string (reverse buf)) ret)))))))

(define (string-split str spliter)
  (cond [(char? spliter) (string-split-by-char str spliter)]
        [(string? spliter) (string-split-by-string str spliter)]
        [else #f]))
)
